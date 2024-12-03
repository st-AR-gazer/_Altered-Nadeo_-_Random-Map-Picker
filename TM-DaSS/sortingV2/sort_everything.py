import json
import os
import logging
import re
import ahocorasick
import sys
import time
import threading
from special_uids import (
    special_uids,
    official_competition_maps,
    all_TOTD_maps,
    stunt_discovery_maps,
    desert_discovery_maps,
    snow_discovery_maps,
    rally_discovery_maps,
    platform_discovery_maps
)

MAP_DATA_FILE = "map_data.json"
OUTPUT_FILE = "consolidated_maps.json"
LOG_FILE = "processing_errors.log"

OFFICIAL_NADEO_AUTHOR_UID = "d2372a08-a8a1-46cb-97fb-23a161d85ad0"
OFFICIAL_NADEO_TAG = "official nadeo map"

SANITIZE_PATTERN = re.compile(r'\$<([^$>]+)\$>|\$([0-9a-fA-F]{1,3}|[iIoOnNmMwWsSzZtTgG<>]|[lLhHpP](\[[^\]]+\])?)')
PARENTHESIS_PATTERN = re.compile(r'\((.*?)\)')
SQUARE_BRACKETS_PATTERN = re.compile(r'\[([^\]]+)\]')
CLEAN_PATTERN = re.compile(r'^[^\w\-]+|[^\w\-]+$')
FT_PATTERN = re.compile(r"(?:ft'?|featuring)\s+([^\s\)]+)", re.IGNORECASE)
SECTION_JOINED_PATTERN = re.compile(r'section\s+\d+\s+joined', re.IGNORECASE)
FALL_YEAR_PATTERN = re.compile(r'^(spring|fall|winter|summer|training)\s+(\d{4})\s*-\s*(\d{2})\s*-\s*(\d{2})$', re.IGNORECASE)
EMBEDDED_YEAR_PATTERN = re.compile(r'\b(spring|fall|winter|summer|training)[\s\-]?(\d{4})\s*(\w+)\b', re.IGNORECASE)
VALID_YEARS = {str(year) for year in range(2020, 2031)}
PRESERVE_BRACKETS_TAGS = {"race", "stunt", "snow", "desert", "rally", "platform"}

discovery_campaigns = [
    {
        'name': 'snow_discovery',
        'maps': snow_discovery_maps,
        'season': 'fall',
        'year': '2023'
    },
    {
        'name': 'rally_discovery',
        'maps': rally_discovery_maps,
        'season': 'winter',
        'year': '2024'
    },
    {
        'name': 'desert_discovery',
        'maps': desert_discovery_maps,
        'season': 'spring',
        'year': '2024'
    },
    {
        'name': 'stunt_discovery',
        'maps': stunt_discovery_maps,
        'season': 'summer',
        'year': '2024'
    },
    {
        'name': 'platform_discovery',
        'maps': platform_discovery_maps,
        'season': 'fall',
        'year': '2024'
    }
]

for campaign in discovery_campaigns:
    if isinstance(campaign['maps'], dict):
        campaign['maps'] = {k.lower(): v for k, v in campaign['maps'].items()}

def setup_logging(log_file):
    logging.basicConfig(
        filename=log_file,
        filemode='w',
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )

def normalize_apostrophes(name):
    return name.replace("’", "'").replace("‘", "'")

def replace_featuring(name):
    return re.sub(r'\bfeaturing\s+([^\s].*?)(?=\s|$)', r"ft' \1", name, flags=re.IGNORECASE)

def sanitize_name(name):
    def replacer(match):
        if match.group(1):
            return match.group(1)
        return ''
    name = SANITIZE_PATTERN.sub(replacer, name)
    return name.replace('$', '').strip()

def load_map_data(file_path):
    if not os.path.exists(file_path):
        logging.error(f"Map data file not found: {file_path}")
        return None
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        logging.error(f"JSON decode error: {e}")
        return None

def build_special_uids_dict(special_uids_list):
    return {entry["uid"].lower(): entry for entry in special_uids_list if "uid" in entry}

def build_aho_automaton(totd_maps):
    automaton = ahocorasick.Automaton()
    for idx, totd_map in enumerate(totd_maps):
        automaton.add_word(totd_map.lower(), (idx, totd_map.lower()))
    automaton.make_automaton()
    return automaton

def parse_map_name(name, seasons, valid_years):
    name = name.strip()
    three_char_match = re.search(r'\b([ST][01]\d)\b', name, re.IGNORECASE)
    if three_char_match:
        prefix = three_char_match.group(1)[0].upper()
        digits = three_char_match.group(1)[1:]
        if prefix == 'S':
            map_number = digits.zfill(2)
        elif prefix == 'T':
            map_number = str(int(digits) + 20).zfill(2)
        season = 'spring'
        year = '2020'
        name = name.replace(three_char_match.group(1), '').strip()
        additional_info = extract_additional_info_general(name)
        return {
            "season": season,
            "year": year,
            "mapNumber": map_number,
            "additionalInfo": additional_info,
            "missing_fields": {}
        }
    season_match = re.search(r'\b(spring|fall|winter|summer|training)\b', name, re.IGNORECASE)
    year_match = re.search(r'\b(20\d{2})\b', name)
    if season_match:
        season = season_match.group(1).lower()
        if season == 'training':
            year = '2020'
        elif year_match:
            year = year_match.group(1)
        else:
            year = None
    else:
        season = None
        year = None
    map_number_match = re.search(r'\b(\d{2})\b', name)
    if map_number_match:
        map_number = map_number_match.group(1).zfill(2)
    else:
        map_number = None
    additional_info = extract_additional_info_general(name)
    if season:
        additional_info = [info for info in additional_info if info.lower() != season.lower()]
    if year and season != 'training':
        additional_info = [info for info in additional_info if info.lower() != year.lower()]
    if map_number:
        additional_info = [info for info in additional_info if info.lower() != map_number.lower()]
    has_modification = bool(re.search(r'\(.*?\)', name))
    if not has_modification:
        main_map_part = re.sub(r'\b(spring|fall|winter|summer|training)\b', '', name, flags=re.IGNORECASE)
        main_map_part = re.sub(r'\b(20\d{2})\b', '', main_map_part)
        main_map_part = re.sub(r'\b\d{2}\b', '', main_map_part)
        main_map_words = re.findall(r'\b\w[\w\-]*\b', main_map_part)
        additional_info += main_map_words
    return {
        "season": season.lower() if season else None,
        "year": year,
        "mapNumber": map_number,
        "additionalInfo": additional_info,
        "missing_fields": {}
    }

def extract_additional_info_from_parentheses(name):
    matches = PARENTHESIS_PATTERN.findall(name)
    additional_info = set()
    for match in matches:
        if re.match(r'AT by\s+\w+', match, re.IGNORECASE):
            at_by_match = re.match(r'AT by\s+(\w+)', match, re.IGNORECASE)
            if at_by_match:
                ft_entry = f"ft' {at_by_match.group(1)}"
                additional_info.add(ft_entry)
            continue
        cleaned = CLEAN_PATTERN.sub('', match.strip())
        if cleaned:
            additional_info.add(cleaned)
    return list(additional_info)

def extract_additional_info_from_square_brackets(name):
    matches = SQUARE_BRACKETS_PATTERN.findall(name)
    additional_info = set()
    for match in matches:
        if match.lower() in PRESERVE_BRACKETS_TAGS:
            additional_info.add(f'[{match}]')
    return list(additional_info)

def extract_additional_info_general(name):
    additional_info = set()
    excluded_words = set()
    at_by_matches = re.findall(r'AT by\s+(\w+)', name, re.IGNORECASE)
    for at_by_name in at_by_matches:
        ft_entry = f"ft' {at_by_name}"
        additional_info.add(ft_entry)
        excluded_words.update(['at', 'by', at_by_name.lower()])
    ft_matches = re.findall(r"(?:ft'?|featuring)\s+([^\s\)]+)", name, re.IGNORECASE)
    for ft_name in ft_matches:
        ft_entry = f"ft' {ft_name}"
        additional_info.add(ft_entry)
        excluded_words.update(['featuring', 'ft', ft_name.lower()])
    parentheses_matches = PARENTHESIS_PATTERN.findall(name)
    for match in parentheses_matches:
        if re.match(r'AT by\s+\w+', match, re.IGNORECASE):
            continue
        ft_inside_match = FT_PATTERN.match(match.strip())
        if ft_inside_match:
            ft_content = f"ft' {ft_inside_match.group(1)}"
            additional_info.add(ft_content)
            excluded_words.update(['ft', ft_inside_match.group(1).lower()])
        else:
            cleaned = CLEAN_PATTERN.sub('', match)
            if cleaned:
                additional_info.add(cleaned)
                excluded_words.update([cleaned.lower()])
    square_brackets_info = extract_additional_info_from_square_brackets(name)
    additional_info.update(square_brackets_info)
    excluded_additional_info = {"na", "of", "the", "and", "in", "on", "at", "for", "to", "with", "by", "featuring", "ft"}
    words = re.findall(r'\b\w[\w\-]*\b', name)
    for word in words:
        word_clean = CLEAN_PATTERN.sub('', word)
        if not word_clean:
            continue
        if word_clean.isdigit():
            additional_info.add(word_clean)
            continue
        word_lower = word_clean.lower()
        if word_lower in ["spring", "fall", "winter", "summer", "training"]:
            continue
        if word_lower in excluded_words:
            continue
        if word_lower in excluded_additional_info:
            continue
        if len(word_clean) == 2 and word_lower in {'is', 'no'}:
            additional_info.add(word_clean)
            continue
        if '-' in word_clean:
            additional_info.add(word_clean)
            continue
        if len(word_clean) > 2:
            additional_info.add(word_clean)
    return list(additional_info)

def add_special_flags(map_info, sanitized_name, discovery_campaigns, automaton, special_uids_dict):
    map_uid = map_info.get("mapUid", "").lower()
    if map_uid in special_uids_dict:
        special_entry = special_uids_dict[map_uid]
        map_info["season"] = special_entry.get("season", map_info.get("season"))
        map_info["year"] = special_entry.get("year", map_info.get("year"))
        map_info["mapNumber"] = special_entry.get("mapNumber", map_info.get("mapNumber"))
        map_type = special_entry.get("type", None)
        map_info["isType"] = map_type
        alteration = special_entry.get("alteration", None)
        if alteration:
            map_info.setdefault("additionalInfo", []).append(alteration)
    else:
        if map_info.get("season") and map_info.get("year"):
            return
        isType = None
        for campaign in discovery_campaigns:
            maps = campaign['maps']
            if isinstance(maps, dict):
                map_keywords = maps.keys()
            else:
                map_keywords = maps
            for map_keyword in map_keywords:
                if re.search(r'\b' + re.escape(map_keyword.lower()) + r'\b', sanitized_name.lower()):
                    isType = campaign['name'].replace('_', ' ').lower()
                    break
            if isType:
                break
        if not isType:
            if any(True for _ in automaton.iter(sanitized_name.lower())):
                isType = "totd"
        map_info['isType'] = isType if isType else None

def process_maps(map_data, special_uids_dict, seasons, valid_years, automaton, official_competition_maps_set):
    spinner_running = True
    def spinner():
        while spinner_running:
            for c in '|/-\\':
                sys.stdout.write('\r' + c)
                sys.stdout.flush()
                time.sleep(0.1)
    t = threading.Thread(target=spinner)
    t.start()
    try:
        for map_key, map_info in map_data.items():
            map_uid = map_info.get("mapUid", "").lower()
            map_name = map_info.get("name", "")
            filename = map_info.get("filename", "")
            sanitized_name = sanitize_name(map_name)
            sanitized_name = normalize_apostrophes(sanitized_name)
            sanitized_name = replace_featuring(sanitized_name)
            parsed = parse_map_name(sanitized_name, seasons, valid_years)
            map_info.update({
                "season": parsed["season"],
                "year": parsed["year"],
                "mapNumber": parsed["mapNumber"],
                "additionalInfo": parsed["additionalInfo"]
            })
            add_special_flags(map_info, sanitized_name, discovery_campaigns, automaton, special_uids_dict)
            isType = map_info.get("isType")
            if isType == "totd":
                has_modification = bool(re.search(r'\(.*?\)', sanitized_name))
                if has_modification:
                    additional_info = extract_additional_info_from_parentheses(sanitized_name)
                    map_info["additionalInfo"] = additional_info
                else:
                    additional_info = extract_additional_info_general(sanitized_name)
                    map_info["additionalInfo"] = additional_info
            elif isType and any(c['name'] == f"{isType.replace(' ', '_')}" for c in discovery_campaigns):
                campaign = next(c for c in discovery_campaigns if c['name'] == f"{isType.replace(' ', '_')}")
                campaign_maps = campaign['maps']
                if isinstance(campaign_maps, dict):
                    campaign_map_names = set(campaign_maps.keys())
                else:
                    campaign_map_names = set([map.lower() for map in campaign_maps])
                additional_info = map_info.get("additionalInfo", [])
                additional_info = [info for info in additional_info if info.lower() not in campaign_map_names]
                map_info["additionalInfo"] = additional_info
            if not isType:
                parsed_filename = parse_map_name(sanitize_name(filename.replace(".Map.Gbx", "")), seasons, valid_years)
                if parsed_filename["season"] or parsed_filename["year"] or parsed_filename["mapNumber"]:
                    map_info.setdefault("additionalInfo", []).extend(parsed_filename["additionalInfo"])
                    map_info["season"] = parsed_filename["season"] or map_info.get("season")
                    map_info["year"] = parsed_filename["year"] or map_info.get("year")
                    map_info["mapNumber"] = parsed_filename["mapNumber"] or map_info.get("mapNumber")
                    missing_fields = parsed_filename.get("missing_fields", {})
                    if 'season' in missing_fields and missing_fields['season'] is None:
                        logging.warning(f"No season found in filename: '{filename}'")
                    if 'year' in missing_fields and missing_fields['year'] is None:
                        logging.warning(f"No valid year found in filename: '{filename}' (season: {map_info.get('season')})")
                    if 'mapNumber' in missing_fields and missing_fields['mapNumber'] is None:
                        logging.warning(f"No valid map number found in filename: '{filename}'")
            if not isType:
                parsed = parse_map_name(sanitize_name(map_name), seasons, valid_years)
                if parsed["additionalInfo"]:
                    map_info.setdefault("additionalInfo", []).extend(parsed["additionalInfo"])
                missing_fields = parsed.get("missing_fields", {})
                if 'season' in missing_fields and missing_fields['season'] is None:
                    logging.warning(f"No season found in name: '{map_name}'")
                if 'year' in missing_fields and missing_fields['year'] is None:
                    logging.warning(f"No valid year found in name: '{map_name}' (season: {map_info.get('season')})")
                if 'mapNumber' in missing_fields and missing_fields['mapNumber'] is None:
                    logging.warning(f"No valid map number found in name: '{map_name}'")
            additional_info = map_info.get("additionalInfo", [])
            if isType and any(c['name'] == f"{isType.replace(' ', '_')}" for c in discovery_campaigns):
                campaign = next(c for c in discovery_campaigns if c['name'] == f"{isType.replace(' ', '_')}")
                campaign_maps = campaign['maps']
                if isinstance(campaign_maps, dict):
                    campaign_map_names = set(campaign_maps.keys())
                else:
                    campaign_map_names = set([map.lower() for map in campaign_maps])
                additional_info = [info for info in additional_info if info.lower() not in campaign_map_names]
            main_map_words = set(re.findall(r'\b\w[\w\-]*\b', sanitize_name(map_name).split('(')[0]))
            additional_info = [info for info in additional_info if info not in main_map_words]
            season = map_info.get("season", "").lower() if map_info.get("season") else ""
            year = map_info.get("year", "").lower() if map_info.get("year") else ""
            map_number = map_info.get("mapNumber", "").lower() if map_info.get("mapNumber") else ""
            additional_info = [info for info in additional_info if info.lower() not in {season, year, map_number}]
            additional_info = [info for info in additional_info if info != '-']
            additional_info = [info for info in additional_info if not (len(info) ==2 and info.lower() not in {'is', 'no'})]
            map_info["additionalInfo"] = additional_info
            if sanitized_name.lower() in official_competition_maps_set:
                map_info.setdefault("additionalInfo", []).append("!AllOfficialCompetitions")
            if map_info.get("season") == "training" and not map_info.get("year"):
                map_info["year"] = "2020"
            author_uid = map_info.get("author", "").lower()
            if author_uid == OFFICIAL_NADEO_AUTHOR_UID.lower():
                map_info.setdefault("additionalInfo", []).append(OFFICIAL_NADEO_TAG)
            if "additionalInfo" in map_info:
                map_info["additionalInfo"] = list(set(map_info["additionalInfo"]))
    finally:
        spinner_running = False
        t.join()
        print('\rDone!   ')
    return map_data

def main():
    setup_logging(LOG_FILE)
    seasons = ["spring", "fall", "winter", "summer", "training"]
    valid_years = VALID_YEARS
    map_data = load_map_data(MAP_DATA_FILE)
    if not map_data:
        print(f"Failed to load map data. Check '{LOG_FILE}' for details.")
        return
    special_uids_dict = build_special_uids_dict(special_uids)
    automaton = build_aho_automaton(all_TOTD_maps)
    official_competition_maps_set = {map_name.lower() for map_name in official_competition_maps}
    updated_map_data = process_maps(map_data, special_uids_dict, seasons, valid_years, automaton, official_competition_maps_set)
    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(updated_map_data, f, indent=4)
    except Exception as e:
        logging.error(f"Failed to write output file: {e}")
        print(f"Failed to write output file. Check '{LOG_FILE}' for details.")

if __name__ == "__main__":
    main()

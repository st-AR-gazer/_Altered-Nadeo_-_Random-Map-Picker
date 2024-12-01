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

SANITIZE_PATTERN = re.compile(r'\$([0-9a-fA-F]{1,3}|[iIoOnNmMwWsSzZtTgG<>]|[lLhHpP](\[[^\]]+\])?)')
PARENTHESIS_PATTERN = re.compile(r'\((.*?)\)')
CLEAN_PATTERN = re.compile(r'^[^\w\-]+|[^\w\-]+$')
FT_PATTERN = re.compile(r"(?:ft'?|featuring)\s+([^\s\)]+)", re.IGNORECASE)
SPRING2020_PATTERN = re.compile(r'\b([ST])(\d{2})\b', re.IGNORECASE)
SECTION_JOINED_PATTERN = re.compile(r'section\s+\d+\s+joined', re.IGNORECASE)
FALL_YEAR_PATTERN = re.compile(r'^(spring|fall|winter|summer|training)\s+(\d{4})\s*-\s*(\d{2})\s*-\s*(\d{2})$', re.IGNORECASE)
EMBEDDED_YEAR_PATTERN = re.compile(r'\b(spring|fall|winter|summer|training)(20\d{2})\s*(\w+)\b', re.IGNORECASE)
VALID_YEARS = {str(year) for year in range(2020, 2031)}

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
    return SANITIZE_PATTERN.sub('', name)

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
    return {entry["uid"]: entry for entry in special_uids_list if "uid" in entry}

def build_aho_automaton(totd_maps):
    automaton = ahocorasick.Automaton()
    for idx, totd_map in enumerate(totd_maps):
        automaton.add_word(totd_map.lower(), (idx, totd_map.lower()))
    automaton.make_automaton()
    return automaton

def format_campaign_flag_name(campaign_name):
    parts = campaign_name.split('_')
    capitalized = ''.join(part.capitalize() for part in parts)
    return f"is{capitalized}"

def parse_map_name(name, seasons, valid_years):
    match = FALL_YEAR_PATTERN.match(name)
    missing_fields = {}
    if match:
        season = match.group(1).lower()
        year = match.group(2)
        map_number = match.group(3)
        additional_info = [match.group(4)]
        return {
            "season": season,
            "year": year,
            "mapNumber": map_number,
            "additionalInfo": additional_info,
            "missing_fields": {}
        }
    embedded_match = EMBEDDED_YEAR_PATTERN.search(name)
    if embedded_match:
        season = embedded_match.group(1).lower()
        year = embedded_match.group(2)
        suffix = embedded_match.group(3)
        name = name.replace(f"{embedded_match.group(1)}{embedded_match.group(2)}", f"{embedded_match.group(1)} {embedded_match.group(2)}")
        name = re.sub(r'(\d{4})(\w+)', r'\1 \2', name)
    season = next((s for s in seasons if s.lower() in name.lower()), None)
    if SECTION_JOINED_PATTERN.search(name):
        if not (season in ['training', 'spring'] and '2020' in name):
            missing_fields['mapNumber'] = None
        season = season.lower() if season else None
        year_match = re.findall(r'\b(\d{2})\b', name)
        if year_match:
            year = '20' + year_match[0]
        else:
            year = None
            missing_fields['year'] = None
        additional_info = extract_additional_info(name)
        return {
            "season": season,
            "year": year,
            "mapNumber": None,
            "additionalInfo": additional_info,
            "missing_fields": missing_fields
        }
    match = re.search(r'\b([ST])(\d{2})\b', name, re.IGNORECASE)
    if match:
        prefix = match.group(1).upper()
        number = match.group(2)
        season = 'spring'
        year = '2020'
        if prefix == 'S':
            map_number = number
        elif prefix == 'T':
            map_number = str(int(number) + 10).zfill(2)
        else:
            map_number = None
        name_without_prefix = name[:match.start()] + name[match.end():]
        name_without_prefix = name_without_prefix.strip(' -')
        additional_info = extract_additional_info(name_without_prefix)
        extra_numbers = re.findall(r'\b(\d{2})\b', name_without_prefix)
        excluded_numbers = re.findall(r'\(-(\d{2})\)', name_without_prefix)
        if extra_numbers:
            for excl_num in excluded_numbers:
                if excl_num in additional_info:
                    additional_info.remove(excl_num)
            if len(extra_numbers) > 1:
                missing_fields['mapNumber'] = map_number
        return {
            "season": season.lower(),
            "year": year,
            "mapNumber": map_number,
            "additionalInfo": additional_info,
            "missing_fields": missing_fields
        }
    numbers = re.findall(r'\b(\d{2})\b', name)
    numbers_reversed = list(reversed(numbers))
    map_number = None
    year = None
    excluded_numbers = re.findall(r'\(-(\d{2})\)', name)
    filtered_numbers = [num for num in numbers_reversed if num not in excluded_numbers]
    missing_fields = {}
    for num in filtered_numbers:
        if not map_number and '01' <= num <= '25':
            map_number = num
        elif not year and num in valid_years:
            year = num
    if not year:
        four_digit_year = re.search(r'\b(20\d{2})\b', name)
        if four_digit_year:
            year = four_digit_year.group(1)
    if season == "training" and not year:
        year = "2020"
    additional_info = extract_additional_info(name)
    for excl_num in excluded_numbers:
        if excl_num in additional_info:
            additional_info.remove(excl_num)
    if len(filtered_numbers) > 1:
        missing_fields['mapNumber'] = map_number
    if not season and not (season in ['training', 'spring'] and '2020' in name):
        missing_fields['season'] = None
    if not year and not (season in ['training', 'spring'] and '2020' in name):
        missing_fields['year'] = None
    if not map_number:
        missing_fields['mapNumber'] = None
    return {
        "season": season.lower() if season else None,
        "year": year,
        "mapNumber": map_number,
        "additionalInfo": additional_info,
        "missing_fields": missing_fields
    }

def extract_additional_info(name):
    additional_info = []
    extracted_words = set()
    ft_names = set()
    ft_matches = re.findall(r"ft'?s?\s+([^\s\)]+)", name, re.IGNORECASE)
    for ft_name in ft_matches:
        ft_content = f"ft' {ft_name}"
        if ft_content.lower() not in extracted_words:
            additional_info.append(ft_content)
            extracted_words.add(ft_content.lower())
            ft_names.add(ft_name.lower())
    parentheses_matches = PARENTHESIS_PATTERN.findall(name)
    for match in parentheses_matches:
        ft_inside_match = FT_PATTERN.match(match.strip())
        if ft_inside_match:
            ft_content = f"ft' {ft_inside_match.group(1)}"
            if ft_content.lower() not in extracted_words:
                additional_info.append(ft_content)
                extracted_words.add(ft_content.lower())
                ft_names.add(ft_inside_match.group(1).lower())
        else:
            cleaned = CLEAN_PATTERN.sub('', match)
            if cleaned:
                words = cleaned.split()
                for word in words:
                    word_lower = word.lower()
                    if len(word) > 1 and not word.isdigit() and not word_lower.startswith("ft'"):
                        additional_info.append(word)
                        extracted_words.add(word_lower)
    for word in name.split():
        word_clean = CLEAN_PATTERN.sub('', word)
        if not word_clean:
            continue
        if re.match(r'^\d', word_clean):
            continue
        word_lower = word_clean.lower()
        if word_lower in ["spring", "fall", "winter", "summer", "training"]:
            continue
        if word_clean.isdigit() and len(word_clean) == 2 and '01' <= word_clean <= '25':
            continue
        if word_lower in extracted_words:
            continue
        if word_lower in ft_names:
            continue
        if len(word_clean) > 1 and not word_clean.isdigit():
            if word_clean.lower().startswith("ft'") or word_clean.lower() == "ft":
                continue
            additional_info.append(word_clean)
    additional_info = [info for info in additional_info if len(info) > 1]
    return additional_info

def add_special_flags(map_info, sanitized_name, discovery_campaigns, automaton):
    flags = {}
    lower_name = sanitized_name.lower()
    main_seasons = ['spring', 'fall', 'winter', 'summer', 'training']
    season = map_info.get("season", "").lower() if map_info.get("season") else ""
    if season not in main_seasons:
        matches = list(automaton.iter(lower_name))
        if matches:
            flags["isTOTD"] = True
    for campaign in discovery_campaigns:
        maps = campaign['maps']
        if isinstance(maps, dict):
            map_keywords = maps.keys()
        else:
            map_keywords = maps
        for map_keyword in map_keywords:
            if re.search(r'\b' + re.escape(map_keyword.lower()) + r'\b', lower_name):
                flag_name = format_campaign_flag_name(campaign['name'])
                flags[flag_name] = True
                break
    map_info.update(flags)

def process_discovery_campaign(map_info, map_name, campaign_map_dict, season, year):
    for base_map_name, map_number in campaign_map_dict.items():
        pattern = r'^' + re.escape(base_map_name.lower()) + r'(?=\s|$|[\[\(])'
        if re.match(pattern, map_name.lower()):
            map_info["season"] = season
            map_info["year"] = year
            map_info["mapNumber"] = map_number
            remaining_name = map_name[len(base_map_name):].strip()
            if SECTION_JOINED_PATTERN.search(remaining_name):
                if not (season in ['training', 'spring'] and '2020' in remaining_name):
                    map_info["mapNumber"] = None
            additional_info = extract_additional_info(remaining_name)
            map_info["additionalInfo"] = additional_info
            return True
    return False

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
            map_uid = map_info.get("mapUid", "")
            map_name = map_info.get("name", "")
            filename = map_info.get("filename", "")
            sanitized_name = sanitize_name(map_name)
            sanitized_name = normalize_apostrophes(sanitized_name)
            sanitized_name = replace_featuring(sanitized_name)
            processed = False
            if map_uid in special_uids_dict:
                entry = special_uids_dict[map_uid]
                map_info["season"] = entry.get("season").lower() if entry.get("season") else None
                map_info["year"] = entry.get("year") or None
                if entry.get("alteration") == "XX-But":
                    map_info["mapNumber"] = None
                    parsed = parse_map_name(sanitized_name, seasons, valid_years)
                    map_info["season"] = parsed["season"] or map_info["season"]
                    map_info["year"] = parsed["year"] or map_info["year"]
                    if parsed["mapNumber"]:
                        map_info["mapNumber"] = parsed["mapNumber"]
                    map_info["additionalInfo"] = map_info.get("additionalInfo", []) + parsed["additionalInfo"]
                else:
                    map_info["mapNumber"] = entry.get("mapNumber") or None
                    if not map_info["mapNumber"]:
                        parsed = parse_map_name(sanitized_name, seasons, valid_years)
                        map_info["mapNumber"] = parsed["mapNumber"]
                        map_info["season"] = parsed["season"] or map_info["season"]
                        map_info["year"] = parsed["year"] or map_info["year"]
                        map_info["additionalInfo"] = map_info.get("additionalInfo", []) + parsed["additionalInfo"]
                if entry.get("alteration"):
                    map_info["additionalInfo"] = map_info.get("additionalInfo", []) + [entry.get("alteration")]
                processed = True
            else:
                for campaign in discovery_campaigns:
                    if process_discovery_campaign(
                        map_info,
                        sanitized_name,
                        campaign['maps'],
                        campaign['season'],
                        campaign['year']
                    ):
                        flag_name = format_campaign_flag_name(campaign['name'])
                        map_info[flag_name] = True
                        processed = True
                        break
            if not processed and not map_info.get("isTOTD"):
                sanitized_filename = sanitize_name(filename.replace(".Map.Gbx", ""))
                sanitized_filename = normalize_apostrophes(sanitized_filename)
                sanitized_filename = replace_featuring(sanitized_filename)
                for campaign in discovery_campaigns:
                    if process_discovery_campaign(
                        map_info,
                        sanitized_filename,
                        campaign['maps'],
                        campaign['season'],
                        campaign['year']
                    ):
                        flag_name = format_campaign_flag_name(campaign['name'])
                        map_info[flag_name] = True
                        processed = True
                        break
            if not processed and not map_info.get("isTOTD"):
                parsed = parse_map_name(sanitized_name, seasons, valid_years)
                map_info.update({
                    "season": parsed["season"],
                    "year": parsed["year"],
                    "mapNumber": parsed["mapNumber"],
                    "additionalInfo": parsed["additionalInfo"]
                })
            add_special_flags(map_info, sanitized_name, discovery_campaigns, automaton)
            is_totd = map_info.get("isTOTD", False)
            is_discovery = any(
                map_info.get(format_campaign_flag_name(campaign['name']), False) 
                for campaign in discovery_campaigns
            )
            if not is_totd and not is_discovery:
                parsed = parse_map_name(sanitized_name, seasons, valid_years)
                missing_fields = parsed.get("missing_fields", {})
                if 'season' in missing_fields and missing_fields['season'] is None:
                    logging.warning(f"No season found in name: '{map_name}'")
                if 'year' in missing_fields and missing_fields['year'] is None:
                    logging.warning(f"No valid year found in name: '{map_name}' (season: {map_info.get('season')})")
                if 'mapNumber' in missing_fields and missing_fields['mapNumber'] is None:
                    logging.warning(f"No valid map number found in name: '{map_name}'")
            excluded_numbers = re.findall(r'\(-(\d{2})\)', sanitize_name(map_name))
            for excl_num in excluded_numbers:
                if excl_num in map_info.get("additionalInfo", []):
                    map_info["additionalInfo"].remove(excl_num)
                    logging.warning(f"Excluded map number '{excl_num}' from 'additionalInfo' for map '{map_name}' due to CPfull minus exception.")
            if sanitized_name.lower() in official_competition_maps_set:
                map_info["additionalInfo"] = map_info.get("additionalInfo", [])
                if "!AllOfficialCompetitions" not in map_info["additionalInfo"]:
                    map_info["additionalInfo"].append("!AllOfficialCompetitions")
            if map_info.get("season") == "training" and not map_info.get("year"):
                map_info["year"] = "2020"
            author_uid = map_info.get("author", "").lower()
            if author_uid == OFFICIAL_NADEO_AUTHOR_UID.lower():
                map_info["additionalInfo"] = map_info.get("additionalInfo", [])
                if not any(info.lower() == OFFICIAL_NADEO_TAG.lower() for info in map_info["additionalInfo"]):
                    map_info["additionalInfo"].append(OFFICIAL_NADEO_TAG)
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

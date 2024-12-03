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

OFFICIAL_NADEO_AUTHOR_UIDS = {
    "d2372a08-a8a1-46cb-97fb-23a161d85ad0",
    "afe7e1c1-7086-48f7-bde9-a7e320647510",
    "aa02b90e-0652-4a1c-b705-4677e2983003"
}
OFFICIAL_NADEO_TAG = "official nadeo map"

CHINESE_SEASON_MAPPING = {
    "\u8bad\u7ec3": "training",
    "\u590f\u5b63\u8d5b": "summer",
    "\u79cb\u5b63": "fall"
}

SANITIZE_PATTERN = re.compile(r'\$([0-9a-fA-F]{1,3}|[iIoOnNmMwWsSzZtTgG<>]|[lLhHpP](\[[^\]]+\])?)')
SEASON_PATTERN = re.compile(r'\b(spring|fall|winter|summer|training|\u8bad\u7ec3|\u590f\u5b63\u8d5b|\u79cb\u5b63)\b', re.IGNORECASE)
YEAR_PATTERN = re.compile(r'\b(2020|2021|2022|2023|2024|2025|2026)\b')
MAPNUMBER_PATTERN = re.compile(r'\b([0-2][0-9])\b')
SPRING2020_PATTERN = re.compile(r'\b([TS][0-1][0-9])\b', re.IGNORECASE)
FT_PATTERN = re.compile(r"(ft'?\s\w+)", re.IGNORECASE)

DISCOVERY_CAMPAIGNS = [
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

for campaign in DISCOVERY_CAMPAIGNS:
    if isinstance(campaign['maps'], dict):
        campaign['maps'] = {k.lower(): v for k, v in campaign['maps'].items()}

def setup_logging(log_file):
    logging.basicConfig(
        filename=log_file,
        filemode='w',
        level=logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )

def sanitize_name(name):
    name = SANITIZE_PATTERN.sub('', name)
    return re.sub(r"[^\w\s'&%#]", ' ', name).strip()

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
    for totd_map in totd_maps:
        automaton.add_word(totd_map.lower(), totd_map.lower())
    automaton.make_automaton()
    return automaton

def extract_season_year_mapnumber(name):
    season = None
    year = None
    map_number = None
    chinese = False
    spring2020_match = SPRING2020_PATTERN.search(name)
    spring2020_matched = None
    if spring2020_match:
        prefix = spring2020_match.group(1)[0].upper()
        number = int(spring2020_match.group(1)[1:])
        if prefix == 'S':
            map_number = str(number + 10).zfill(2)
        else:
            map_number = str(number).zfill(2)
        season = 'spring'
        year = '2020'
        spring2020_matched = spring2020_match.group(1)
    else:
        season_match = SEASON_PATTERN.search(name)
        if season_match:
            season_str = season_match.group(1)
            if season_str in CHINESE_SEASON_MAPPING:
                season = CHINESE_SEASON_MAPPING[season_str]
                chinese = True
            else:
                season = season_str.lower()
        year_match = YEAR_PATTERN.search(name)
        if year_match:
            year = year_match.group(1)
        mapnumber_match = MAPNUMBER_PATTERN.search(name)
        if mapnumber_match:
            map_number = mapnumber_match.group(1).zfill(2)
    return season, year, map_number, chinese, spring2020_matched

def extract_additional_info(name, chinese, excluded_words):
    additional_info = []
    ft_matches = FT_PATTERN.findall(name)
    additional_info.extend(ft_matches)
    words = re.findall(r'\b[\w&%#]+\b', name)
    exclude = {"spring", "fall", "winter", "summer", "training", "2020", "2021", "2022", "2023", "2024", "2025", "2026", 
              "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", 
              "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29"}
    for word in words:
        word_lower = word.lower()
        if word_lower not in exclude and not FT_PATTERN.match(word):
            if word_lower not in excluded_words:
                additional_info.append(word)
    if chinese:
        additional_info.append("Chinese")
    return list(set(additional_info))

def add_special_flags(map_info, sanitized_name, discovery_campaigns, automaton):
    matched_map_names = []
    for campaign in discovery_campaigns:
        maps = campaign['maps']
        if isinstance(maps, dict):
            for map_name, map_number in maps.items():
                if map_name.lower() in sanitized_name.lower():
                    map_info["season"] = campaign['season']
                    map_info["year"] = campaign['year']
                    map_info["mapNumber"] = map_number.zfill(2) if map_number else None
                    map_info["isType"] = campaign['name'].replace('_', ' ').lower()
                    matched_map_names.append(map_name)
        elif isinstance(maps, list):
            for map_name in maps:
                if map_name.lower() in sanitized_name.lower():
                    map_info["season"] = campaign['season']
                    map_info["year"] = campaign['year']
                    map_info["mapNumber"] = None
                    map_info["isType"] = campaign['name'].replace('_', ' ').lower()
                    matched_map_names.append(map_name)
    totd_matched_map_names = [value for _, value in automaton.iter(sanitized_name.lower())]
    if totd_matched_map_names:
        map_info['isType'] = 'totd'
        matched_map_names.extend(totd_matched_map_names)
    map_info['matched_map_names'] = matched_map_names

def process_maps(map_data, special_uids_dict, discovery_campaigns, automaton, official_competition_maps_set):
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
            map_name = map_info.get("name", "")
            sanitized_name = sanitize_name(map_name)
            add_special_flags(map_info, sanitized_name, discovery_campaigns, automaton)
            matched_map_names = map_info.get('matched_map_names', [])
            season, year, map_number, chinese, spring2020_matched = extract_season_year_mapnumber(sanitized_name)
            map_info["season"] = season or map_info.get("season")
            map_info["year"] = year or map_info.get("year")
            map_info["mapNumber"] = map_number or map_info.get("mapNumber")
            excluded_words = [word.lower() for name in matched_map_names for word in re.findall(r'\b[\w&%#]+\b', name) if isinstance(name, str)]
            if spring2020_matched:
                excluded_words.extend([spring2020_matched.lower()])
            additional_info = extract_additional_info(sanitized_name, chinese, excluded_words)
            if map_info.get("isType") == "totd":
                additional_info = extract_additional_info(sanitized_name, chinese, excluded_words)
                map_info["additionalInfo"] = additional_info
            else:
                map_info["additionalInfo"] = additional_info
            if sanitized_name.lower() in official_competition_maps_set:
                map_info["additionalInfo"].append("!AllOfficialCompetitions")
            if map_info.get("season") == "training" and not map_info.get("year"):
                map_info["year"] = "2020"
            author_uid = map_info.get("author", "").lower()
            if author_uid in OFFICIAL_NADEO_AUTHOR_UIDS:
                map_info["additionalInfo"].append(OFFICIAL_NADEO_TAG)
            map_info["additionalInfo"] = list(set(map_info["additionalInfo"]))
    finally:
        spinner_running = False
        t.join()
        print('\rDone!   ')
    return map_data

def main():
    setup_logging(LOG_FILE)
    map_data = load_map_data(MAP_DATA_FILE)
    if not map_data:
        print(f"Failed to load map data. Check '{LOG_FILE}' for details.")
        return
    special_uids_dict = build_special_uids_dict(special_uids)
    automaton = build_aho_automaton(all_TOTD_maps)
    official_competition_maps_set = {map_name.lower() for map_name in official_competition_maps}
    updated_map_data = process_maps(map_data, special_uids_dict, DISCOVERY_CAMPAIGNS, automaton, official_competition_maps_set)
    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(updated_map_data, f, indent=4)
    except Exception as e:
        logging.error(f"Failed to write output file: {e}")
        print(f"Failed to write output file. Check '{LOG_FILE}' for details.")

if __name__ == "__main__":
    main()

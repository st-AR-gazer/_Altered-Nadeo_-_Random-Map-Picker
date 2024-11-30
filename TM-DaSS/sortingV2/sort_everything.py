import json
import os
import logging
import re
from special_uids import (
    special_uids,
    official_competition_maps,
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

SANITIZE_PATTERN = re.compile(r'\$([0-9a-fA-F]{1,3}|[iIoOnNmMwWsSzZtTgG<>]|[lLhHpP](\[[^\]]+\])?)')     # To strip TM text formatting codes
PARENTHESIS_PATTERN = re.compile(r'\((.*?)\)')                                                          # To extract content within parentheses
CLEAN_PATTERN = re.compile(r'^[^\w\-]+|[^\w\-]+$')                                                      # To strip surrounding punctuation
FT_PATTERN = re.compile(r"ft'\s+([^\s\)]+)", re.IGNORECASE)                                             # To detect patterns like "ft' [NAME]"
SPRING2020_PATTERN = re.compile(r'\b([ST])([01][0-9])\b', re.IGNORECASE)                                # Matches S01-T19

SECTION_JOINED_PATTERN = re.compile(r'section\s+\d+\s+joined', re.IGNORECASE)

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
    return re.sub(r'\bFeaturing\s+([^\s].*?)(?=\s|$)', r"ft' \1", name, flags=re.IGNORECASE)

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

def parse_map_name(name, seasons, valid_years):
    season = next((s for s in seasons if s.lower() in name.lower()), None)
    
    if SECTION_JOINED_PATTERN.search(name):
        if not (season in ['training', 'spring'] and '2020' in name):
            logging.warning(f"Map '{name}' contains a section join pattern. Skipping mapNumber assignment.")
        season = season.lower() if season else None
        year_match = re.findall(r'\b(\d{2})\b', name)
        if year_match:
            year = '20' + year_match[0]
        else:
            year = None
        additional_info = extract_additional_info(name)
        return {
            "season": season,
            "year": year,
            "mapNumber": None,
            "additionalInfo": additional_info
        }
    
    numbers = re.findall(r'\b(\d{2})\b', name)
    numbers_reversed = list(reversed(numbers))
    
    map_number = None
    year = None
    
    for num in numbers_reversed:
        if not map_number and '01' <= num <= '25':
            map_number = num
        elif not year:
            year = '20' + num
    
    if not year:
        four_digit_year = re.search(r'\b(20\d{2})\b', name)
        if four_digit_year:
            year = four_digit_year.group(1)
    
    additional_info = extract_additional_info(name)
    
    if not season and not (season in ['training', 'spring'] and '2020' in name):
        logging.warning(f"No season found in name: '{name}'")
    if not year and not (season in ['training', 'spring'] and '2020' in name):
        logging.warning(f"No valid year found in name: '{name}'")
    if not map_number:
        logging.warning(f"No valid map number found in name: '{name}'")
    
    return {
        "season": season.lower() if season else None,
        "year": year,
        "mapNumber": map_number,
        "additionalInfo": additional_info
    }

def extract_additional_info(name):
    additional_info = []
    extracted_words = set()
    ft_names = set()
    
    ft_matches = re.findall(r"ft'\s+([^\s\)]+)", name, re.IGNORECASE)
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
        word_lower = word_clean.lower()
        if word_lower in ["spring", "fall", "winter", "summer", "training"]:
            continue
        if word_clean.isdigit() and len(word_clean) == 2 and '01' <= word_clean <= '25':
            continue
        if word_clean.lower() in extracted_words:
            continue
        if word_clean.lower() in ft_names:
            continue
        if len(word_clean) > 1 and not word_clean.isdigit():
            if word_clean.lower().startswith("ft'") or word_clean.lower() == "ft":
                continue
            additional_info.append(word_clean)
    
    additional_info = [info for info in additional_info if len(info) > 1]
    
    return additional_info

def add_special_flags(map_info, name):
    flags = {}
    lower_name = name.lower()
    
    if any(map_keyword.lower() in lower_name for map_keyword in official_competition_maps):
        flags["isTOTD"] = True
    if any(map_keyword.lower() in lower_name for map_keyword in stunt_discovery_maps):
        flags["isStuntDiscovery"] = True
    if any(map_keyword.lower() in lower_name for map_keyword in desert_discovery_maps.keys()):
        flags["isDesertDiscovery"] = True
    if any(map_keyword.lower() in lower_name for map_keyword in snow_discovery_maps.keys()):
        flags["isSnowDiscovery"] = True
    if any(map_keyword.lower() in lower_name for map_keyword in rally_discovery_maps.keys()):
        flags["isRallyDiscovery"] = True
    if any(map_keyword.lower() in lower_name for map_keyword in platform_discovery_maps.keys()):
        flags["isPlatformDiscovery"] = True
    
    map_info.update(flags)

def process_discovery_campaign(map_info, map_name, campaign_map_dict, season, year):
    for base_map_name, map_number in campaign_map_dict.items():
        if map_name.lower().startswith(base_map_name.lower()):
            map_info["season"] = season
            map_info["year"] = year
            map_info["mapNumber"] = map_number
            
            remaining_name = map_name[len(base_map_name):].strip()
            
            if SECTION_JOINED_PATTERN.search(remaining_name):
                if not (season in ['training', 'spring'] and '2020' in remaining_name):
                    logging.warning(f"Map '{map_name}' contains a section join pattern. Skipping mapNumber assignment.")
                map_info["mapNumber"] = None
                additional_info = extract_additional_info(remaining_name)
                map_info["additionalInfo"] = additional_info
                add_special_flags(map_info, map_name)
                return True
            
            additional_info = extract_additional_info(remaining_name)
            map_info["additionalInfo"] = additional_info
            add_special_flags(map_info, map_name)
            return True
    
    return False

def process_maps(map_data, special_uids_dict, seasons, valid_years):
    for map_key, map_info in map_data.items():
        map_uid = map_info.get("mapUid", "")
        map_name = map_info.get("name", "")
        
        map_name = normalize_apostrophes(map_name)
        
        map_name = replace_featuring(map_name)
        
        sanitized_name = sanitize_name(map_name)
        
        if map_uid in special_uids_dict:
            entry = special_uids_dict[map_uid]
            map_info.update({
                "season": entry.get("season").lower() if entry.get("season") else None,
                "year": entry.get("year") or None,
                "mapNumber": None,
                "additionalInfo": [entry.get("alteration")] if entry.get("alteration") else []
            })
            add_special_flags(map_info, entry.get("name", ""))
        else:
            processed = False
            for campaign in discovery_campaigns:
                if process_discovery_campaign(
                    map_info, 
                    map_name, 
                    campaign['maps'], 
                    campaign['season'], 
                    campaign['year']
                ):
                    processed = True
                    break
            if not processed:
                parsed = parse_map_name(sanitized_name, seasons, valid_years)
                map_number = None if map_info.get("isTOTD") else parsed["mapNumber"]
                map_info.update({
                    "season": parsed["season"],
                    "year": parsed["year"],
                    "mapNumber": map_number,
                    "additionalInfo": parsed["additionalInfo"]
                })
                add_special_flags(map_info, sanitized_name)
        
        author_uid = map_info.get("author", "").lower()
        if author_uid == OFFICIAL_NADEO_AUTHOR_UID.lower():
            if "additionalInfo" not in map_info or not isinstance(map_info["additionalInfo"], list):
                map_info["additionalInfo"] = []
            if not any(info.lower() == OFFICIAL_NADEO_TAG.lower() for info in map_info["additionalInfo"]):
                map_info["additionalInfo"].append(OFFICIAL_NADEO_TAG)
    
    return map_data

def main():
    setup_logging(LOG_FILE)
    
    seasons = ["spring", "fall", "winter", "summer", "training"]
    valid_years = set(str(year) for year in range(2020, 2031))
    
    map_data = load_map_data(MAP_DATA_FILE)
    if not map_data:
        print(f"Failed to load map data. Check '{LOG_FILE}' for details.")
        return
    
    special_uids_dict = build_special_uids_dict(special_uids)
    
    updated_map_data = process_maps(map_data, special_uids_dict, seasons, valid_years)
    
    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(updated_map_data, f, indent=4)
        print(f"Successfully consolidated data into '{OUTPUT_FILE}'.")
    except Exception as e:
        logging.error(f"Failed to write output file: {e}")
        print(f"Failed to write output file. Check '{LOG_FILE}' for details.")

if __name__ == "__main__":
    main()

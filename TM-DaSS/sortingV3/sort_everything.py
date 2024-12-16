import json
import re
import logging
import os
from concurrent.futures import ThreadPoolExecutor
from uids import (
    DISCOVERY_CAMPAIGNS,
    OFFICIAL_NADEO_AUTHOR_AND_SUBMITTOR_UIDS,
    special_uids,
    ALL_TOTD_MAP_NAMES,
    ALL_COMPETITION_MAP_NAMES
)

INPUT_FILE = 'map_data.json'
OUTPUT_FILE = 'parsed_map_data.json'
LOG_FILE = 'unmatched_maps.log'
if os.path.exists(LOG_FILE):
    os.remove(LOG_FILE)
    
from regex_pattern import *

OFFICIAL_NADEO_TAG = "official nadeo map"

logging.basicConfig(
    filename=LOG_FILE,
    filemode='a',
    format='%(asctime)s %(levelname)s: %(message)s',
    datefmt='%Y-%m-%dT%H:%M:%S%z',
    level=logging.DEBUG # set to "WARNING" when done with debugging...
)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)
formatter = logging.Formatter('%(asctime)s %(levelname)s: %(message)s', '%Y-%m-%dT%H:%M:%S%z')
console_handler.setFormatter(formatter)
logging.getLogger().addHandler(console_handler)

logger = logging.getLogger(__name__)

VALID_SEASONS = ["winter", "spring", "summer", "fall", "training"]
SEASON_REGEX = '|'.join(VALID_SEASONS)

SANITIZE_PATTERN = re.compile(
    r'\$([0-9a-fA-F]{1,3}|[iIoOnNmMwWsSzZtTgG<>]|[lLhHpP](\[[^\]]+\])?)'
)

def sanitize_name(name: str) -> str:
    return SANITIZE_PATTERN.sub('', name).strip()

def validate_year(year: int) -> int:
    if year < 100:
        if 20 <= year <= 26:
            return 2000 + year
        else:
            logger.warning(f"Year {year} out of allowed range for short year (20-26).")
            return None
    else:
        if 2020 <= year <= 2026:
            return year
        else:
            logger.warning(f"Year {year} out of allowed range (2020-2026).")
            return None

def validate_mapnumber(map_nums: list) -> list:
    valid = []
    for num in map_nums:
        if 1 <= num <= 25:
            valid.append(num)
        else:
            logger.warning(f"Map number {num} out of allowed range (1-25).")
    return valid

# ------------------------------------------------------------
# REGEX PATTERNS (defined here for centralized attribute assignment)
# ------------------------------------------------------------
# see "regex_pattern.py"
    


ft_pattern = re.compile(
    r"(?:ft' |ft |featuring |AT by |Feat )(\w+)",
    re.IGNORECASE
)

def check_discovery_map_name(map_name: str) -> dict:
    match = discovery_full_pattern.match(map_name)
    if match:
        discovery_name = match.group()
        for campaign in DISCOVERY_CAMPAIGNS:
            for dmap_name, dmap_number in campaign['maps'].items():
                if dmap_name.lower() == discovery_name.lower():
                    year = validate_year(int(campaign['year']))
                    mapnumber = validate_mapnumber([int(dmap_number)])
                    return {
                        'discoveryname': discovery_name,
                        'season': campaign['season'].capitalize(),
                        'year': year,
                        'mapnumber': mapnumber,
                        'type': campaign['name']
                    }
    return {}


def check_totd_map_name(map_name: str) -> bool:
    return bool(totd_full_pattern.match(map_name))

def try_special_uids(map_uid: str):
    for entry in special_uids:
        if entry['uid'].lower() == map_uid.lower():
            year = int(entry['year']) if 'year' in entry and entry['year'] else None
            year = validate_year(year) if year else None

            map_nums = []
            if 'mapNumber' in entry and entry['mapNumber']:
                valid_map_nums = validate_mapnumber([int(m) for m in entry['mapNumber']])
                if valid_map_nums:
                    map_nums = valid_map_nums

            attributes = {
                'season': entry['season'].capitalize() if 'season' in entry and entry['season'] else None,
                'year': year,
                'mapnumber': map_nums,
                'alteration': entry['alteration'] if 'alteration' in entry and entry['alteration'] else ''
            }

            attributes['pass_special'] = entry.get('pass', False)
            return attributes
    return None


def extract_and_remove_ft(map_name: str):
    match = ft_pattern.search(map_name)
    if match:
        username = match.group(1)
        start, end = match.span()
        map_name = map_name[:start] + map_name[end:]

    map_name = map_name.strip()
    if map_name.endswith('()'):
        map_name = map_name[:-2].strip()

    if map_name.startswith('(') and map_name.endswith(')'):
        map_name = map_name[1:-1].strip()

    return map_name, username if match else None


def normalize_whitespace(map_name: str):
    return re.sub(r'\s+', ' ', map_name).strip()

def match_known_patterns(map_name: str):
    for pattern in ALL_PATTERNS:
        match = pattern.match(map_name)
        if match:
            attrs = match.groupdict()

            if totd_full_pattern.match(map_name):
                attrs['season'] = None
                attrs['year'] = None
                attrs['mapnumber'] = []
                attrs['type'] = 'totd'
                if 'alteration' not in attrs:
                    attrs['alteration'] = ''
                return attrs
            
            if 'competitionname' in attrs and attrs['competitionname']:
                competition_name = attrs['competitionname']
                for competition in ALL_COMPETITION_MAP_NAMES:
                    if competition_name in competition["maps"]:
                        attrs['season'] = competition['season'] if competition['season'] != '_' else None
                        attrs['year'] = validate_year(int(competition['year']))
                        attrs['type'] = competition['competition']
                        attrs['mapnumber'] = []
                        
                        if 'alteration' not in attrs or not attrs['alteration']:
                            attrs['alteration'] = ''
                        
                        return attrs
                
            if 'discoveryname' in attrs and attrs['discoveryname']:
                discovery_name = attrs['discoveryname']
                for campaign in DISCOVERY_CAMPAIGNS:
                    for dmap_name, dmap_number in campaign['maps'].items():
                        if dmap_name.lower() == discovery_name.lower():
                            year = validate_year(int(campaign['year']))
                            mapnumber = validate_mapnumber([int(dmap_number)])
                            attrs['year'] = year
                            attrs['mapnumber'] = mapnumber
                            attrs['season'] = campaign['season'].capitalize()
                            attrs['type'] = campaign['name']
                            if 'alteration' not in attrs:
                                attrs['alteration'] = ''
                            return attrs
                        
            if 'spring2020' in attrs and attrs['spring2020']:
                code = attrs['spring2020'].upper()
                season = 'Spring'
                year = 2020
                map_num = int(code[1:])
                # If starts with 'S': season='Spring', year=2020, mapnumber=mapnumber=mapnumber
                # If starts with 'T': season='Spring', year=2020, mapnumber=mapnumber+10=mapnumber
                if code.startswith('T'):
                    map_num += 10
                valid_mapnums = validate_mapnumber([map_num])
                if not valid_mapnums:
                    return None
                return {
                    'season': season,
                    'year': year,
                    'mapnumber': valid_mapnums,
                    'alteration': '',
                    'type': None
                }

            if 'year' in attrs and attrs['year']:
                y = validate_year(int(attrs['year']))
                if y is None:
                    return None
                attrs['year'] = y
            else:
                attrs['year'] = None
            
            if 'mapnumber' in attrs and attrs['mapnumber']:
                m = validate_mapnumber([int(attrs['mapnumber'])])
                if not m:
                    return None
                attrs['mapnumber'] = m
            else:
                attrs['mapnumber'] = []

            if 'season' in attrs and attrs['season']:
                attrs['season'] = attrs['season'].capitalize()
            else:
                attrs['season'] = None

            alteration = attrs.get('alteration', '').strip()
            alteration_suffix = attrs.get('alteration_suffix', '').strip() if 'alteration_suffix' in attrs else ''
            alteration_prefix = attrs.get('alteration_prefix', '').strip() if 'alteration_prefix' in attrs else ''
            combined_alteration = ' '.join(filter(None, [alteration_prefix, alteration, alteration_suffix])).strip()
            
            attrs['alteration'] = combined_alteration
            
            if 'alteration_suffix' in attrs:
                del attrs['alteration_suffix']
            if 'alteration_prefix' in attrs:
                del attrs['alteration_prefix']

            if 'type' not in attrs:
                attrs['type'] = None
            
            if 'alteration_additional_info' in attrs:
                attrs['alterationinfo'] = attrs['alteration_additional_info']

            return attrs
    return None

def assign_attributes(item_data: dict) -> dict:
    raw_name = item_data['name']
    sanitized_name = sanitize_name(raw_name)
    filename = sanitize_name(item_data['filename'].replace('.Map.Gbx', ''))
    map_uid = item_data.get('mapUid', '')

    sanitized_name, ft_username = extract_and_remove_ft(sanitized_name)
    sanitized_name = normalize_whitespace(sanitized_name)
    filename = normalize_whitespace(filename)

    attributes = match_known_patterns(sanitized_name)
    
    if not attributes:
        special_attrs = try_special_uids(map_uid)
        if special_attrs:
            if not special_attrs.pop('pass_special', False):
                attributes = special_attrs
            else:
                attributes = {**special_attrs}
        else:
            pass

    if not attributes and sanitized_name != filename:
        filename_attrs = match_known_patterns(filename)
        if filename_attrs:
            if 'attributes' in locals() and attributes:
                attributes = {**attributes, **filename_attrs}
            else:
                attributes = filename_attrs

    if not attributes:
        attributes = {
            'season': None,
            'year': None,
            'mapnumber': [],
            'alteration': '',
            'type': None
        }
        logger.warning(f"Unmatched map name: {raw_name} (sanitized: {sanitized_name}), totd: {check_totd_map_name(sanitized_name)}, discovery: {check_discovery_map_name(sanitized_name)}")
    else:
        pass

    if attributes.get('alteration', '').lower() == 'super':
        attributes['alteration'] = 'Supersized'

    if ft_username:
        attributes['ft'] = ft_username

    if (
        item_data.get('author') in OFFICIAL_NADEO_AUTHOR_AND_SUBMITTOR_UIDS or
        item_data.get('submitter') in OFFICIAL_NADEO_AUTHOR_AND_SUBMITTOR_UIDS
    ):
        attributes['alteration'] = OFFICIAL_NADEO_TAG

    return {**item_data, **attributes}


def process_item(item: tuple) -> tuple:
    key, data = item
    parsed_attrs = assign_attributes(data)
    combined_data = {**data, **parsed_attrs}
    return key, combined_data

def main():
    try:
        with open(INPUT_FILE, 'r', encoding='utf-8') as f:
            map_data = json.load(f)
    except FileNotFoundError:
        logger.error(f"Input file {INPUT_FILE} not found.")
        return
    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON from {INPUT_FILE}: {e}")
        return

    items = list(map_data.items())

    results = {}


    # Write totd pattern groups to files
    try:
        with open('totd_pattern_group.txt', 'w', encoding='utf-8') as f:
            f.write(totd_pattern_group)
        logger.info("totd_pattern_group written to pattern_dings.txt")
    except Exception as e:
        logger.error(f"Error writing to pattern_dings.txt: {e}")
    
    # Write discovery pattern groups to files
    try:
        discovery_map_names = []
        for campaign in DISCOVERY_CAMPAIGNS:
            discovery_map_names.extend(campaign['maps'].keys())
        discovery_pattern_group = "(?:" + "|".join([re.escape(name) for name in discovery_map_names]) + ")"
        with open('discovery_pattern_group.txt', 'w', encoding='utf-8') as f:
            f.write(discovery_pattern_group)
        logger.info("discovery_pattern_group written to discovery_pattern_group.txt")
    except Exception as e:
        logger.error(f"Error writing discovery_pattern_group.txt: {e}")
        
    # Write competition pattern groups to files
    try:
        with open('competition_pattern_group.txt', 'w', encoding='utf-8') as f:
            f.write(competition_pattern_group)
        logger.info("competition_pattern_group written to competition_pattern_group.txt")
    except Exception as e:
        logger.error(f"Error writing competition_pattern_group.txt: {e}")


    with ThreadPoolExecutor(max_workers=16) as executor:
        futures = [executor.submit(process_item, item) for item in items]
        for future in futures:
            try:
                key, value = future.result()
                results[key] = value
            except Exception as e:
                pass
                #logger.error(f"Error processing item: {e}")

    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=4)
        logger.info(f"Parsed data written to {OUTPUT_FILE}")
    except Exception as e:
        logger.error(f"Error writing to output file {OUTPUT_FILE}: {e}")

if __name__ == "__main__":
    main()
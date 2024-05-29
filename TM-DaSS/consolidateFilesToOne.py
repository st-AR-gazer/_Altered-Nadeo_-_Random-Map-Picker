import json
import os
import re
import argparse

parser = argparse.ArgumentParser(description="Process map files with season, year, and alterations.")
parser.add_argument('-v', '--verbose', action='store_true', help='Enable verbose output.')
args = parser.parse_args()

def add_season_and_year_to_maps(maps, season, year):
    for map_obj in maps:
        map_obj["season"] = season
        map_obj["year"] = year
    return maps

def add_alteration_to_maps(maps, alteration, alteration_maps, error_log):
    uid_to_map = {map_obj["mapUid"]: map_obj for map_obj in maps}
    for alt_map in alteration_maps:
        if alt_map["mapUid"] in uid_to_map:
            uid_to_map[alt_map["mapUid"]]["alteration"] = alteration
        else:
            error_log.write(f"UID mismatch for alteration {alteration}: {alt_map['mapUid']}\n")

def read_json_file(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            return json.load(file)
    except json.JSONDecodeError as e:
        if args.verbose:
            print(f"Error reading {file_path}: {e}")
        return []
    except UnicodeDecodeError as e:
        if args.verbose:
            print(f"Unicode decode error reading {file_path} at position {e.start}: {e}")
            try:
                with open(file_path, 'r', encoding='utf-8') as file:
                    lines = file.readlines()
                    for i, line in enumerate(lines):
                        try:
                            line.encode('utf-8')
                        except UnicodeDecodeError as ue:
                            print(f"Unicode decode error at line {i+1}: {ue}")
                            break
            except Exception as ex:
                print(f"Failed to read lines from {file_path}: {ex}")
        return []

def write_to_json_file(content, file_path):
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(content, file, indent=4)

season_dir = "bySeason"
alteration_dir = "byAlteration"
consolidated_maps = []
error_log_dir = "ConsolidatedMaps"
error_log_path = os.path.join(error_log_dir, "mapUidNameMatchErrors.txt")
output_file_dir = error_log_dir
output_file_path = os.path.join(output_file_dir, "consolidated_maps.json")

os.makedirs(error_log_dir, exist_ok=True)

# bySeason files
if args.verbose:
    print("Processing bySeason files...")
for filename in os.listdir(season_dir):
    if filename.endswith(".json"):
        season_year_match = re.match(r"(\D+)(\d{4})\.json", filename)
        if season_year_match:
            season, year = season_year_match.groups()
        else:
            season = filename.replace('.json', '')
            year = ""

        file_path = os.path.join(season_dir, filename)
        maps = read_json_file(file_path)
        if maps and args.verbose:
            print(f"Adding season and year to maps from {filename}")
        consolidated_maps.extend(add_season_and_year_to_maps(maps, season, year))

# byAlteration files 
if args.verbose:
    print("Processing byAlteration files...")
with open(error_log_path, 'w') as error_log:
    for filename in os.listdir(alteration_dir):
        if filename.endswith(".json"):
            alteration = filename.replace('.json', '')
            file_path = os.path.join(alteration_dir, filename)
            alteration_maps = read_json_file(file_path)
            if alteration_maps and args.verbose:
                print(f"Adding alteration {alteration} to maps")
            add_alteration_to_maps(consolidated_maps, alteration, alteration_maps, error_log)

write_to_json_file(consolidated_maps, output_file_path)

if args.verbose:
    print(f"Consolidation complete. Output file is at {output_file_path}. Any errors are logged in {error_log_path}.")

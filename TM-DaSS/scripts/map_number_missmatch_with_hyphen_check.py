import json
import csv
import re
import sys
from pathlib import Path

def extract_number_from_filename(filename):
    match = re.search(r'-\s*(\d{1,2})', filename)
    if match:
        return int(match.group(1))
    else:
        return None

def has_discovery_flags(details):
    discovery_fields = [
        'isTOTD',
        'isDesertDiscovery',
        'isSnowDiscovery',
        'isRallyDiscovery',
        'isStuntDiscovery',
        'isPlatformDiscovery',
        'isPuzzleDiscovery'
    ]
    for field in discovery_fields:
        if details.get(field, False):
            return True
    return False

def process_json(input_json_path, output_csv_path):
    if not Path(input_json_path).is_file():
        print(f"Error: The file {input_json_path} does not exist.")
        return

    print("Loading JSON data...")
    try:
        with open(input_json_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"Error decoding JSON: {e}")
        return

    print(f"Writing discrepancies to {output_csv_path}...")
    with open(output_csv_path, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['Map Name', 'Map UID', 'Filename Number', 'Map Number Field', 'Issue']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

        writer.writeheader()

        for filename, details in data.items():
            filename_number = extract_number_from_filename(filename)

            if filename_number is None:
                if has_discovery_flags(details):
                    print(f"Info: Could not extract number from filename '{filename}' but discovery flags are set. Skipping.")
                    continue
                else:
                    map_name = details.get('name', 'N/A')
                    map_uid = details.get('mapUid', 'N/A')
                    issue = "Number not found in filename"

                    writer.writerow({
                        'Map Name': map_name,
                        'Map UID': map_uid,
                        'Filename Number': 'N/A',
                        'Map Number Field': details.get('mapNumber', 'N/A'),
                        'Issue': issue
                    })
                    print(f"Flagged: '{filename}' as mismatch due to missing number.")
                    continue

            map_number_field = details.get('mapNumber')
            if map_number_field is None:
                print(f"Warning: 'mapNumber' field missing for '{filename}'. Skipping.")
                continue

            try:
                map_number_field = int(map_number_field)
            except ValueError:
                print(f"Warning: 'mapNumber' field is not an integer for '{filename}'. Skipping.")
                continue

            if filename_number != map_number_field:
                map_name = details.get('name', 'N/A')
                map_uid = details.get('mapUid', 'N/A')
                issue = "Filename number does not match mapNumber field"

                writer.writerow({
                    'Map Name': map_name,
                    'Map UID': map_uid,
                    'Filename Number': filename_number,
                    'Map Number Field': map_number_field,
                    'Issue': issue
                })
                print(f"Flagged: '{filename}' as mismatch (Filename: {filename_number} vs Map Number: {map_number_field}).")

    print("Processing complete.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_json_path> <output_csv_path>")
        sys.exit(1)

    input_json = sys.argv[1]
    output_csv = sys.argv[2]

    process_json(input_json, output_csv)


# ..\\sortingV2\\consolidated_maps.json
import json
import re

input_file = "..\\sortingV2\\consolidated_maps.json"
output_file = "mismatched_maps.txt"

def extract_map_number(name):
    match = re.search(r"- (\d+)", name)
    return int(match.group(1)) if match else None

def find_mismatched_maps(json_data):
    mismatched_maps = []
    for map_name, map_data in json_data.items():
        print(f"Processing map: {map_name}")
        name_number = extract_map_number(map_name)
        actual_number_str = map_data.get("mapNumber")
        actual_number = int(actual_number_str) if actual_number_str is not None else None

        print(f"Derived Number: {name_number}, Actual Number: {actual_number}")

        if name_number is not None and (actual_number is None or name_number != actual_number):
            mismatched_maps.append({
                "map_name": map_name,
                "map_uid": map_data["mapUid"],
                "derived_number": name_number,
                "actual_number": actual_number
            })
    return mismatched_maps

with open(input_file, "r") as file:
    json_data = json.load(file)

mismatched_maps = find_mismatched_maps(json_data)

with open(output_file, "w") as file:
    for map_info in mismatched_maps:
        file.write(
            f"Map Name: {map_info['map_name']}, UID: {map_info['map_uid']}, "
            f"Derived Number: {map_info['derived_number']}, Actual Number: {map_info['actual_number']}\n"
        )

print(f"Mismatched maps written to {output_file}")
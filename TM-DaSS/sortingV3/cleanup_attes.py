import json
import os
import re
from alteration_dictionary import alterations_dict

def invert_alteration_dictionary(alterations_dict):
    single_variant_map = {}
    combination_map = {}
    for normalized, variants in alterations_dict.items():
        for variant in variants:
            if isinstance(variant, list):
                key = tuple(sorted(v.lower() for v in variant))
                combination_map[key] = normalized
            else:
                single_variant_map[variant.lower()] = normalized
    return single_variant_map, combination_map

def extract_cpfull_info(alteration_mix):
    missing_cp = 0
    filtered_mix = []
    i = 0
    while i < len(alteration_mix):
        alt = alteration_mix[i].lower().strip()
        if 'cpfull' in alt:
            if i + 1 < len(alteration_mix):
                next_alt = alteration_mix[i + 1].strip()
                match = re.match(r'-?(\d+)', next_alt)
                if match:
                    missing_cp = int(match.group(1))
                    i += 2
                    continue
            missing_cp = 0
            i += 1
            continue
        filtered_mix.append(alteration_mix[i])
        i += 1
    return filtered_mix, missing_cp

def normalize_alteration_mix(alteration_mix, single_variant_map, combination_map):
    normalized = []
    i = 0
    n = len(alteration_mix)
    while i < n:
        matched = False
        for combo_len in range(min(3, n - i), 0, -1):
            combo = tuple(sorted(v.lower() for v in alteration_mix[i:i+combo_len]))
            if combo in combination_map:
                normalized.append(combination_map[combo])
                i += combo_len
                matched = True
                break
        if not matched:
            alt = alteration_mix[i].lower().strip()
            normalized.append(single_variant_map.get(alt, alteration_mix[i].capitalize()))
            i += 1
    normalized_unique = list(dict.fromkeys(normalized))
    return ' '.join(normalized_unique)

def cleanup_attributes(input_file, output_file):
    single_variant_map, combination_map = invert_alteration_dictionary(alterations_dict)
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for attributes in data.values():
        alteration_mix = attributes.pop('alteration_mix', [])
        if alteration_mix:
            filtered_mix, missing_cp = extract_cpfull_info(alteration_mix)
            normalized_alteration = normalize_alteration_mix(filtered_mix, single_variant_map, combination_map)
            if 'cpfull' in [alt.lower() for alt in alteration_mix]:
                normalized_alteration = "CPfull"
                attributes['missingCPs'] = missing_cp
            attributes['alteration'] = normalized_alteration
    
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
    print(f"Cleanup completed. Cleaned data saved to '{output_file}'.")

if __name__ == "__main__":
    input_file = 'parsed_map_data.json'
    output_file = 'consolidated_maps.json'
    if os.path.exists(input_file):
        cleanup_attributes(input_file, output_file)
    else:
        print(f"Error: Input file '{input_file}' does not exist.")

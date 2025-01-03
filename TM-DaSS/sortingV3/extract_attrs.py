import json
import sys

def extract_unique_alteration_mix(input_file, output_file):
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except FileNotFoundError:
        print(f"Error: The file '{input_file}' was not found.")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error: Failed to decode JSON. {e}")
        sys.exit(1)
    
    unique_alterations = set()
    
    for map_name, details in data.items():
        alteration_mix = details.get("alteration_mix", [])
        unique_alterations.add(tuple(alteration_mix))
    
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            for alteration in unique_alterations:
                f.write(', '.join(alteration) + '\n')
        print(f"Successfully wrote {len(unique_alterations)} unique alteration_mix variations to '{output_file}'.")
    except IOError as e:
        print(f"Error: Failed to write to '{output_file}'. {e}")
        sys.exit(1)

def main():
    input_file = './parsed_map_data.json'
    output_file = './unique_alteration_mix.txt'
    
    extract_unique_alteration_mix(input_file, output_file)

if __name__ == "__main__":
    main()

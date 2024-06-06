import json
import argparse
from termcolor import colored

def count_occurrences(json_data, search_string):
    count = 0
    for obj in json_data:
        if search_string in json.dumps(obj):
            count += 1
    return count

def main():
    parser = argparse.ArgumentParser(description="Count occurrences of a string in JSON objects.")
    parser.add_argument('file', type=str, help="Path to the JSON file")
    parser.add_argument('-o', '--overwrite', type=str, default="d10cdccd-31e7-491f-9504-d72ee3a70de6", help="String to search for")
    
    args = parser.parse_args()
    
    try:
        with open(args.file, 'r', encoding='utf-8') as file:
            json_data = json.load(file)
        
        count = count_occurrences(json_data, args.overwrite)
        
        print(colored("############################################", 'cyan'))
        print(colored("#                                          #", 'cyan'))
        print(colored("#       How Many Maps Have YOU Made!       #", 'cyan'))
        print(colored("#                                          #", 'cyan'))
        print(colored("############################################", 'cyan'))
        print(colored(f"\nTotal occurrences of '{args.overwrite}': {count}\n", 'green'))
    except FileNotFoundError:
        print(colored("File not found. Please check the file path.", 'red'))
    except json.JSONDecodeError as e:
        print(colored("Error decoding JSON. Please check the file format.", 'red'))
        print(colored(f"Details: {e}", 'yellow'))

if __name__ == "__main__":
    main()

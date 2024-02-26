import os
import json

folder_paths = ['./byAlteration', './bySeason']
individual_file_paths = ['./data.csv']

output_dir = './FileStateChecking/'
output_file = 'initial_file_state.json'
os.makedirs(output_dir, exist_ok=True)

def add_file_state(file_path, file_states_dict):
    try:
        mod_time = os.path.getmtime(file_path)
        relative_path = os.path.relpath(file_path)
        file_states_dict[relative_path] = mod_time
    except OSError as e:
        print(f"Error accessing {file_path}: {e}")

file_states = {}

for folder in folder_paths:
    folder_abs_path = os.path.abspath(folder)
    for root, dirs, files in os.walk(folder_abs_path):
        for file in files:
            file_path = os.path.join(root, file)
            add_file_state(file_path, file_states)

for file_path in individual_file_paths:
    abs_file_path = os.path.abspath(file_path)
    add_file_state(abs_file_path, file_states)

output_path = os.path.join(output_dir, output_file)
with open(output_path, 'w') as json_file:
    json.dump(file_states, json_file, indent=4)

print(f"File states recorded in {output_path}.")

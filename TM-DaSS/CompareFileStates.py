import json

def compare_states(initial_state_path, new_state_path, output_path):
    with open(initial_state_path, 'r') as file:
        initial_state = json.load(file)
    with open(new_state_path, 'r') as file:
        new_state = json.load(file)

    updated_files = {file: mod_time for file, mod_time in new_state.items() if file not in initial_state or initial_state[file] != mod_time}

    with open(output_path, 'w') as file:
        json.dump(updated_files, file, indent=4)

compare_states('./FileStateChecking/initial_file_state.json', './FileStateChecking/new_file_state.json', './FileStateChecking/updated_files.json')

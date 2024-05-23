import argparse
import os
import re

parser = argparse.ArgumentParser(description="Process log statements in code files.")
parser.add_argument('-v', '--verbose', action='store_true', help='Enable verbose output of all log modifications.')

args = parser.parse_args()

log_pattern = re.compile(r'log\((.*?)\);')

default_params = ['""', "LogLevel::Info", "-1", '""']

function_pattern = re.compile(
    r'(void|int|uint|int8|uint8|int16|uint16|int64|uint64|float|double|bool|string|wstring|'
    r'vec2|vec3|vec4|int2|int3|nat2|nat3|iso3|mat3|iso4|mat4|quat|RGBAColor|MemoryBuffer|'
    r'DataRef|CMwStack|MwId|MwSArray|MwStridedArray|MwFastArray|MwFastBuffer|MwFastBufferCat|'
    r'MwRefBuffer|MwNodPool|MwVirtualArray|array<[^>]*>|enum\w*|dictionaryValue|dictionary|ref)'
    r'\s+(\w+)\s*\(([^)]*)\)\s*\{')

def get_function_name(lines, index):
    for i in range(index, -1, -1):
        match = function_pattern.search(lines[i])
        if match:
            return match.group(2)
    return "UnknownFunction"

def parse_params(log_content):
    params = []
    temp = ''
    in_string = False
    for char in log_content:
        if char == '"':
            in_string = not in_string
        if char == ',' and not in_string:
            if temp:
                params.append(temp.strip())
                temp = ''
        else:
            temp += char

    if temp:
        params.append(temp.strip())

    if in_string:
        raise ValueError("Malformed statement detected in log parameters.")

    return params


def clean_and_update_params(params, index, lines):
    while len(params) < 4:
        params.append(default_params[len(params)])
    
    params[2] = str(index + 1)
    params[3] = f'"{get_function_name(lines, index)}"'
    
    if "LogLevel::" not in params[1]:
        params[1] = "LogLevel::Info"
    
    return params

def modify_log_statements(file_path, verbose):
    modified = False
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        for index, line in enumerate(lines):
            if 'log(' in line:
                try:
                    result = log_pattern.search(line)
                    if not result:
                        raise ValueError("Invalid log syntax.")

                    log_content = result.group(1)
                    params = parse_params(log_content)

                    updated_params = clean_and_update_params(params, index, lines)

                    new_log = f'log({", ".join(updated_params)});'
                    line = line.replace(result.group(0), new_log)
                    modified = True
                    if verbose:
                        print(f"Updated log call in {file_path}: {new_log}")
                except ValueError as e:
                    if 'Logging.as' not in file_path:
                        print(f"\033[31mError in {file_path} on line {index+1}: {str(e)}\033[0m")
            file.write(line)

    return modified

def process_directory(directory, verbose):
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            if modify_log_statements(file_path, verbose):
                if verbose:
                    print(f"Found and updated instances in: {file_path}")

if __name__ == '__main__':
    process_directory('./src', args.verbose)

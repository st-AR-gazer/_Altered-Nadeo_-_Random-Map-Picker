import json

with open('./FileStateChecking/updated_files.json', 'r') as json_file:
    updated_files = json.load(json_file)

updated_file_names = list(updated_files.keys())

data = {
    "latestVersion": 0,
    "url": "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv",
    "updatedFiles": {str(index+1): file_name for index, file_name in enumerate(updated_file_names)},
    "updateInstalledVersion": True,
    "id": 0
}

with open('latestInstalledVersion.json', 'w') as json_file:
    json.dump(data, json_file, indent=4)

print("latestInstalledVersion.json file has been updated with only the modified files.")

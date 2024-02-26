import os
import shutil
import json

with open('./FileStateChecking/updated_files.json', 'r') as file:
    updated_files = json.load(file)

source_root_dir = '.'
target_dir = './UpdatedFiles/'

os.makedirs(target_dir, exist_ok=True)

for rel_path in updated_files.keys():
    source_path = os.path.join(source_root_dir, rel_path)
    target_path = os.path.join(target_dir, rel_path)

    os.makedirs(os.path.dirname(target_path), exist_ok=True)
    
    shutil.copy2(source_path, target_path)

print("Updated files have been copied to the new directory.")

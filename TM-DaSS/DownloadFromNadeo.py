import requests
import time
import json
import os
import base64

def encode_credentials(username, password):
    credentials = f"{username}:{password}"
    credentials_bytes = credentials.encode('ascii')
    base64_bytes = base64.b64encode(credentials_bytes)
    return base64_bytes.decode('ascii')

def get_access_token(username, password):
    url = "https://prod.trackmania.core.nadeo.online/v2/authentication/token/basic"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Basic {encode_credentials(username, password)}",
        "User-Agent": "I'm downloading all the altered nadeo maps to keep a plugin project up to date, this should only happnen once a month or so",
        "From": "@ar___ on discord (or ar@xjk.yt through e-mail, though disocrd is preferred :D)",
    }
    body = {"audience": "NadeoServices"}
    response = requests.post(url, headers=headers, json=body)
    if response.status_code == 200:
        print("Token obtained " + response.json()['accessToken'])
        return response.json()['accessToken']
    else:
        print(f"Error obtaining token: {response.status_code}")
        return None

def fetch_map_info(uid_batch, access_token):
    url = f"https://prod.trackmania.core.nadeo.online/maps/?mapUidList={','.join(uid_batch)}"
    headers = {'Authorization': f'nadeo_v1 t={access_token}'}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Error fetching data for batch: {response.status_code}")
        return None

def read_uids(file_path):
    if not os.path.exists(file_path):
        return set()
    with open(file_path, 'r') as file:
        return set(line.strip() for line in file)

def write_processed_uids(file_path, uids):
    with open(file_path, 'a') as file:
        for uid in uids:
            file.write(uid + '\n')

def split_into_batches(uids, max_length):
    batch = []
    current_length = 0
    for uid in uids:
        added_length = len(uid) + 1
        if current_length + added_length > max_length:
            yield batch
            batch = []
            current_length = 0
        batch.append(uid)
        current_length += added_length
    if batch:
        yield batch

uids = read_uids("data.csv")
processed_uids = read_uids("processed_uids.txt")
failed_uids = set()

unprocessed_uids = uids - processed_uids

batches = split_into_batches(unprocessed_uids, 8000)

dedicated_username = 'AR..._ALT_MAPS_INFO_DOWNL'
dedicated_password = '#zW}fiA?i{RRFq&R'

access_token = get_access_token(dedicated_username, dedicated_password)
if not access_token:
    raise Exception("Failed to obtain access token")

map_data = {}
for batch in batches:
    response_data = fetch_map_info(batch, access_token)
    if response_data is None:
        failed_uids.update(batch)
        print(f"Failed to fetch data for {len(batch)} maps")
        continue
    for item in response_data:
        filename = item.get('filename', 'Unknown')
        map_data[filename] = item
    write_processed_uids("processed_uids.txt", batch)
    time.sleep(0.6)

if failed_uids:
    print(f"Failed to fetch data for {len(failed_uids)} maps. UID list saved to 'failed_uids.txt'")
    write_processed_uids("failed_uids.txt", failed_uids)

with open("map_data.json", 'w', encoding='utf-8') as json_file:
    json.dump(map_data, json_file, indent=4, ensure_ascii=False)

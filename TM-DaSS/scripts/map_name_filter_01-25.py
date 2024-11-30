import json
import re

all_TOTD_maps = [
    "Avalanche!", "Uphill", "Mars", "FS1", "BURIED IN SAND", "Howling Canyon", 
    "RGB-Road", "Road Made Of Bread", "Mango Tango", "The wormhole", "Symmetrixx", 
    "THERMALTECH", "Rainbow Road v2", "RainbowRoadv2", "Green City", "Hanami", 
    "NeonDrift", "Route 66", "Forced Slide", "Parking Lot", "Amethyst Castle", 
    "Paprika V2", "Sic Trackmanius Creatus Est", "Future Valley", "Airashi", 
    "Airashī", "Haunted forest", "Saffron", "SLAP_Like_NOW", "Paprika V2", "Sakura", 
    "NEO KYOTO MudaCup #1", "JoyRide", "Formule Gou1", "Juniper", "Lost Eden", 
    "Mighty Desert", "Mountain", "BAY", "Nascar Lakeside", "Desert Dunes", "Time Warp", 
    "Outsider", "Morocco", "Forced Slide", "Outlandish V2", "Polaris (MTC)", "FuN ", 
    "TuplaJ Desert Mountain", "Woodland Circuit", "Summer Frost", "Formule Gou1", 
    "VELP - Mini - 02", "Triforce", "cold hands", "20 - Poison", "Hillside Highway", 
    "Sand Drift", "Elements racing", "Moutain Pass", "Mountain Pass", "JoyRide", 
    "Hibiscus", "aYobi", "Valley Trail Turbo", "Night Slide", "The Jaunt", "The JauntFS", 
    "The Jaunt FS", "The Jaunt[FS]", "Drop THE CAVE", "Sztyeppe", "Junglehouse", 
    "Jungle House", "Melting Away", "Texas Angel", "All Terrain Vengeance", "The Descent II", 
    "handpan stadium", "The Speedster", "Future Valley", "Aardburn", "Green Day v2", 
    "EDGE TRANSIT", "E_D_G_E_T_R_A_N_S_IE_T", "BLIZZARD", "Avalanche", "Drop THE CAVE", 
    "U-Turn", "The Circuit De Monaco", "Nascar Vegas Earthquake", "SLAP Like NOW", 
    "Goldrush", "steampunk 1877", "Funnel", "FRZ #7 - Bridges", "Redwood Nascar", 
    "Wadi", "Tatooine", "Aqueduct", "Drift City", "NéonDrift", "Space Launch", 
    "Abrupt Decay", "Fury Road", "DAREDEVIL", "Islands", "Jumpy Jack", "Arches", "VALHALLA", 
    "Take a Break", "E D G E T R A N S IE T", "Landslide", "Light In The Dark", "Polaris MTC", 
    "A Land before Time", "Sriracha", "Lost Village", "Sunken Desert City", "Fairy Drift",
    "Nascar Trainyard", "NEO KYOTO MudaCup 1", "Nascar Phase 09", "Edinburgh", 
    "Sic Trackmanius Creatus Est", "Forced Slide", "Hibiscus", "Goldrush", "Hanging Gardens",
    "Outsider", "Summer Frost", "OriginalPark"
]

with open('../data/map_data.json', 'r', encoding='utf-8') as file:
    data = json.load(file)

pattern = r"- (0[1-9]|1[0-9]|2[0-5])\b"

filtered_data = {
    key: value
    for key, value in data.items()
    if not re.search(pattern, value.get("name", "")) and value.get("name", "") not in all_TOTD_maps
}

with open('filtered_maps_01-25.json', 'w') as file:
    json.dump(filtered_data, file, indent=4)

print("Filtered maps saved to 'filtered_maps.json'")

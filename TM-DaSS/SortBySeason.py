import json
import os
import re
import argparse
from collections import defaultdict

parser = argparse.ArgumentParser(description="Process map data and sort by category.")
parser.add_argument('-v', '--verbose', action='store_true', help="Enable verbose output of all log modifications.")
args = parser.parse_args()
verbose = args.verbose




def load_json_data(file_path):
    if verbose:
        print(f"Loading JSON data from {file_path}")
    with open(file_path, 'r', encoding='utf-8') as file:
        return json.load(file)




def is_exact_match(name, map_names, filename, should_normalize_map_names):
    if should_normalize_map_names:
        name = normalize_map_names(name)
        filename = normalize_map_names(filename)
    
    pattern = r"(" + "|".join(re.escape(map_name) for map_name in map_names) + r")"

    return re.search(pattern, name, re.IGNORECASE) is not None or \
           re.search(pattern, filename, re.IGNORECASE) is not None



def normalize_map_names(map_name):
    return map_name.replace("_", " ")



def get_special_uid_info(map_data):
    for special in special_uids:
        if map_data["mapUid"] == special["uid"]:
            return special
    return None



def sort_key(map_data):
    special_info = get_special_uid_info(map_data)
    if special_info:
        return (True, special_info["season"], special_info["year"], map_data["timestamp"])
    else:
        return (False, map_data["timestamp"])



def find_season_year(string):
    if re.search(r"\b(T|S)\d{2}\b", string):
        return "Spring2020"

    if "Training" in string:
        return "Training"

    season_patterns = "(Spring|Summer|Fall|Autumn|Winter)"
    full_year_pattern = fr"{season_patterns}\s?_?(\d{{4}})"
    shortened_year_pattern = fr"{season_patterns}['’]\s?(\d{{2}})"
    abbreviated_pattern = fr"(sp|su|fa|wi)(\d{{2}})(?=\s|$)"
    wordplay_season_pattern = fr"(SpriNgolo|FallN'golo)\s?(\d{{4}})"

    match = re.search(full_year_pattern, string, re.IGNORECASE)
    if match:
        season = normalize_season_name(match.group(1))
        return season + match.group(2)

    match = re.search(shortened_year_pattern, string, re.IGNORECASE)
    if match:
        season = normalize_season_name(match.group(1))
        year = "20" + match.group(2)
        return season + year

    match = re.search(abbreviated_pattern, string, re.IGNORECASE)
    if match:
        season = normalize_season_name(match.group(1))
        year = "20" + match.group(2)
        return fix_short_season_name(season) + year
    
    match = re.search(wordplay_season_pattern, string, re.IGNORECASE)
    if match:
        season = match.group(1)
        return fix_ngolo_season_name(season) + match.group(2)

    return None



def fix_short_season_name(season):
    if season == "Sp":
        return "Spring"
    elif season == "Su":
        return "Summer"
    elif season == "Fa":
        return "Fall"
    elif season == "Wi":
        return "Winter"
    return season



def fix_ngolo_season_name(season):
    if season == "SpriNgolo":
        return "Spring"
    elif season == "FallN'golo":
        return "Fall"
    return season



def normalize_season_name(season):
    season = season.capitalize()
    if season.lower() in ["springolo", "falln'golo"]:
        season = season[:-5]
    return season



def parse_map_category(filename, name, map_data):
    special_info = get_special_uid_info(map_data)
    if special_info:
        alteration = special_info["alteration"]

        year = special_info["year"]
        year = "20" + year if len(year) == 2 else year
        return special_info["season"].capitalize() + year
    
    season_year = find_season_year(filename) or find_season_year(name)
    if season_year:
        return season_year
    
    elif "royal" in filename.lower():
        if verbose:
            print(f"Royal map found: {name}")
        return "AllRoyal"
    
    elif is_exact_match(name, snow_discovery_maps, filename, False):
        if verbose:
            print(f"Snow Discovery map found: {name}")
        return "AllSnowDiscovery"
    
    elif is_exact_match(name, rally_discovery_maps, filename, False):
        if verbose:
            print(f"Rally Discovery map found: {name}")
        return "AllRallyDiscovery"
    
    elif is_exact_match(name, desert_discovery_maps, filename, False):
        if verbose:
            print(f"Desert Discovery map found: {name}")
        return "AllDesertDiscovery"

    elif is_exact_match(name, all_TOTD_maps, filename, True):
        if verbose:
            print(f"TOTD map found: {name}")
        return "AllTOTD"
    
    elif is_exact_match(name, official_competition_maps, filename, False):
        if verbose:
            print(f"Official Competition map found: {name}")
        return "AllOfficialCompetitions"
    
    return "_AllUnknownMaps"



def sort_maps_by_category(data):
    sorted_data = defaultdict(dict)
    for map_info in sorted(data.values(), key=sort_key, reverse=True):
        category = parse_map_category(map_info['filename'], map_info['name'], map_info)
        sorted_data[category][map_info['filename']] = map_info
    return sorted_data



def save_sorted_data(sorted_data, base_folder):
    if verbose:
        print(f"Saving sorted data to {base_folder}")
    if not os.path.exists(base_folder):
        os.makedirs(base_folder)
    for category, maps in sorted_data.items():
        maps_list = list(maps.values())
        with open(os.path.join(base_folder, f"{category}.json"), 'w', encoding='utf-8') as file:
            json.dump(maps_list, file, indent=4, ensure_ascii=False)




snow_discovery_maps = [
    "SnowIsBack", "IcyHills", "SnowGlider", "WoodForce", "WetWood",
    "BreakOrSlide", "IcySnow", "WoodySlalom", "Temple", "Hairpins",
    "IAmSpeed", "BobLover", "SummerSnow", "SlippySnow", "Rock&Revel"
]

rally_discovery_maps = [
    "RallyIsBack", "RallyB1 Reloaded", "BumpyRally", "CastleWall",
    "GrippyRally", "NightWatch", "NewSlopes", "GreenStage", 
    "RallyC1 Reloaded", "2laps2cars", "Ralleigh", "Dirt2024",
    "RallyOnRoad", "TransforMania", "DeepEase", "ClassicRally",
    "Radium", "WetRally", "FrostyMorning", "Rastic", "Offroad",
    "MixedStage", "Snolly", "IAmSpeed2", "PowerStage"
]

desert_discovery_maps = [
    "DesertIsBack", "PlatformJourney", "Wiggle", "DesertOnRoad", 
    "Originals", "NewLoops", "DesertC1Reloaded", "A08Lover",
    "DesertDirt", "2Cars2Laps", "GrassyDesert", "DesTech",
    "DesertCastle", "Plasert", "Dice", "WoodyDesert", "Narrow",
    "AmericanSpeed", "Halfpipes", "DesertCity", "WetDesert",
    "2Wheelers", "DesertLeague", "DeseRPG", "DesertMaster"
]

stunt_discovery_maps = [
    "StuntIsBack", "SimpleFlips", "Arena", "SuperPipe", "Stunt4Ever", 
    "Freedom", "OriginalPark", "A08Stunter", "Lasagna", "GiveMe5", 
    "AirMania", "BumpersParadise", "PlatformEdges", "Moustache", 
    "RedAlert", "Roundabout", "Hiking", "CibusFanaticus", 
    "SnowSpinning", "Frikandelbroodje", "HighSpeed", "DeserticStunts", 
    "Foundry", "StuntCity", "ScatterPark"
]

official_competition_maps = [
    "Gyroscope", "Flip of Faith", "Agility Dash", "Parkour", "Slowdown",
    "Aeropipes", "Freestyle", "Reps", "SlippySlides", "Back'N'Forth",
    "SideWave", "SwitchBridge", "TreeJump", "Eurostep", "Halfpipe",
    "FlyBack", "StarGlide", "Hoverboard", "Cyclone", "Paradice",
    "BumpyJumpy", "Circles", "Dune", "GlacierHiking", "SnowStep",
    "Semiramis", "Reversing", "Picicle", "Slalom", "Arctic Split",
    "Zazigzag", "TurboStairs", "AirBridge", "EuroSky", "Barrelistic",
    "OnTheEdge", "PoleParty", "Tubes", "Edge", "Cosmos", "Tempest",
    "Surf", "Twisted", "Valley", "G-Force", "Backflip", "Dive",
    "Sinuous", "Vortex", "Breaking", "Speed", "Offroad", "Airwalk",
    "Frosty", "Pool", "Grip", "Control", "Heart", "IcyJump", "TinyGap", 
    "WaterGlider", "IcySnake", "Throttling Act", "GrassHopper", "BoltHoles",
    "Vertigo", "LaunchPad", "Bowl", "Clock Tower", "TightRope", "Quicksand",
    "Grassline", "Touchdown", "Turnover"
]

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
    "Nascar Trainyard", "NEO KYOTO MudaCup 1", "Nascar Phase 09"
]

# this is a list of maps that either didn't fit into the standared naming scheme since they were 
# substantially different from the genereal map name pool, or the maps stored here are maps that 
# have a mistake of some sort, like a typo in the name or a wrong season/year.
special_uids = [
    # {"uid": "1", "name": "1", "season": "1", "year": "1", "alteration": "1"},
    # Maps that are too far from the general naming scheme
    ### SuperSized
    {"uid": "2SbX9YGOeEo9OVFErIZYzYGRjh5", "name": "Super01", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "MxE9k0C5TBiEzZ4q1ntEwCof3E8", "name": "Super02", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "3h8HjMcBWWMuRwN0aE8Wc4fVx2g", "name": "Super03", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "57pa9XDvv6o3tiAl7zO7CTULZW1", "name": "Super04", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "F0MlQkXovs8RBLWkM1AUYHc2i5m", "name": "Super05", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "vnzcAbi3LWvFZ5llKhUNdXNVZOf", "name": "Super06", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "6XcKLq30HjuG35W4_No52y3ZdQe", "name": "Super07", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "cOY6qJxrQjkcpg3cprceer82nke", "name": "Super08", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "om6BlqXF5Nqv90svkAOMbLnyjJd", "name": "Super09", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "MbckTeJQVtQD2cu4jV31l5SJ9Pk", "name": "Super10", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "wJQW6fMtlpBrJ0al6Ec0fH6kLBf", "name": "Super11", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "_wUuwESKTyQqgvzOT9oQCaTEIKe", "name": "Super12", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "GVsxXP0VjVRUVb2aYipMsU4PTyc", "name": "Super13", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "B3lkxDtwBvU_Q5xmCsqDAI1es1c", "name": "Super14", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "8rSPmt6cjT8YINW2qzPYdkTD6Og", "name": "Super15", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "esZ1ca79XE7hIYLviy7KnvGPSOd", "name": "Super16", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "h5hWa8bPmo6ngO0YQzNcNhnmzxh", "name": "Super17", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "EQVgrbtQnl6XEh9BM9d2bi7E5Jf", "name": "Super18", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "vPa_Onj7fswOaL7WdIajF1JKdJf", "name": "Super19", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "JrTT0xgcml25nw0qWkFcCJsrsF0", "name": "Super20", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "f1wKtCAAR6MJjmU4YwB3P0W8lJd", "name": "Super21", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "Xw38iuF1ZHk3iQsiYGPZAdDLIwb", "name": "Super22", "season": "summer", "year": "2023", "alteration": "SuperSized"},    
    {"uid": "Kp6EpmUMZxYkjpKD9ZGihoPl1A9", "name": "Super22", "season": "summer", "year": "2023", "alteration": "SuperSized"}, # :YEK: Why are there two of them xdd
    {"uid": "RTAhySbG71EA7VO_rQy38MjGID5", "name": "Super23", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "tbUB3ytvxSt0wf1jp09lZNsxa1h", "name": "Super24", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    {"uid": "QfVhvf2NisC80Sn44siqqSBCWBi", "name": "Super25", "season": "summer", "year": "2023", "alteration": "SuperSized"},
    
    ### Mirrored
    {"uid": "C2Zzj5ScSQTEcGF7MTjPQMlsC3e", "name": "Fall 01 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "MJZxfTWW49VEuuUOHTTUF44rMei", "name": "Fall 02 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "YQKnOVxC5hrUJ4rGFk7UcUe5Bf7", "name": "Fall 03 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "6hUHngLNOUuk4rKeuR7sFwjWGci", "name": "Fall 04 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "_T81qasxa3C4uOAyp9bbuPyk6K1", "name": "Fall 05 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "gPVuhX0jZptCHoA_SdBrpnf09ih", "name": "Fall 06 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "8JnIaktFRsk9mY1rTmOEE4nvu_6", "name": "Fall 07 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "puNpmVUJq9yjBfupSsxskW6m5Z1", "name": "Fall 08 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "OtDL27OZWHHSgtaEbNoxEmLRcG4", "name": "Fall 09 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "YSeSIWbHsmddyl_0TiLjvxbmfF",  "name": "Fall 10 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "1UK4Psa58XfpbqIi697sBFT6j5b", "name": "Fall 11 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "g2jyvz3tu3VYu5o3iyejTWdw_Z5", "name": "Fall 12 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "x6j2uaSk69NRnFGIXVdvhanJhAk", "name": "Fall 13 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "n66sqgaD_gGDQCGxQ4VoWtXLYCi", "name": "Fall 14 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "uV3DIhWMPaApKYa9XFSomZ6uFD5", "name": "Fall 15 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "6Tf72HnG0eHP49EBN5vNUn6Iza3", "name": "Fall 16 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "iXFHFlT373jSGADyrMwObWtW8l3", "name": "Fall 17 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "pjWGVTpDM7JdNWoBARE03V1Uick", "name": "Fall 18 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "URGIQW57Z3TzJy6azRJPCQUm6H6", "name": "Fall 19 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "9_pOMl_2ZrfBf2KjcTKo6J6uml5", "name": "Fall 20 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "esZrih9ocNT75b3caGg0DdjbJy7", "name": "Fall 21 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "kVNDGhfcsx24hQ48XCW7492khu4", "name": "Fall 22 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "1CgxaKhXjVhEU868GSRbyydeyn1", "name": "Fall 23 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "aEEHtHDpLdEd0VW9eeoVv6ZzsO2", "name": "Fall 24 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    {"uid": "XkeZfUrvsVgRaTza3cWbNUxU5ih", "name": "Fall 25 (Mirror)", "season": "Fall", "year": "2020", "alteration": "Mirrored"},
    
    ### Tilted
    {"uid": "IG3eqdb6_RL7f3UvVuvgSV_Qv3m", "name": "Spring 01 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "DWsp_e6UTLFjGvXPpruVQwjbMgf", "name": "Spring 02 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "S0tWJlaeRkyrvo9zSaKNaCQViQ1", "name": "Spring 03 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "PdLl6wLthT7EblIZvHmmy3v544e", "name": "Spring 04 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "SUljYCob4SOZGrC8PSX66d7GOZj", "name": "Spring 05 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "liEQ8PrqLsL0wnOVzoDdygIFxZ3", "name": "Spring 06 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "HV6cAGZFAPDAfknjmk9keZfZqgk", "name": "Spring 07 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "cBAfRHT5syqwGnJmL5r7eyRu8b0", "name": "Spring 08 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "Yk44ewnJsusntgXdeTOchLHIuDj", "name": "Spring 09 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "d89uJp4OjtCZdPcVP65TuX3EF1",  "name": "Spring 10 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "IhIjrm2icZHrhe9A93IKDnixQ5c", "name": "Spring 11 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "2Vsxn1fJaMTDPMlmIlWqP2lNN49", "name": "Spring 12 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "_TcdkEtp2U3nQDTTn7R0TvAvDom", "name": "Spring 13 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "UK9y1jYdCluNR4HYiWu872pvhn6", "name": "Spring 14 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "meW8WdBa5lVE_b1IqFQGuAMNpn4", "name": "Spring 15 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "ovshdDAvYs8h7KIQl2Avr7cdjt9", "name": "Spring 16 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "2ZlOWoLUJ_lr95ebNLIwlC0_Jo9", "name": "Spring 17 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "FiggQXKg3XETSWsf4G4BGQ40yGj", "name": "Spring 18 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "nfxfWVrX1cv0kg6xqW7K7Vg7Fe3", "name": "Spring 19 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "pekwzU_rtc3r9PlSMAZRvpp3qr8", "name": "Spring 20 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "iW23hl_XNJcmGnZcZsj2M3LDMy6", "name": "Spring 21 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "SZpsw2K4VVsjYaJcdGeBFQywuVk", "name": "Spring 22 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "k0Aus4UQzU8j3SKSBTCE6FcrlZ5", "name": "Spring 23 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "B0h89vgFxYJHKmZqKVbDMbGmU0f", "name": "Spring 24 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},
    {"uid": "Y2A7nfrlRj5rClQcsuIOpPO_J08", "name": "Spring 25 - Tilted", "season": "spring", "year": "2021", "alteration": "Tilted"},

    {"uid": "UX8fSIsIa7QQSjm77tLxTiImOXl", "name": "Fall 01 - Tilted", "season": "fall", "year": "2021", "alteration": "Tilted"},


    ### Bumper
    {"uid": "Z7ONQwC0w_0Z09aoGotsgFtGBi0", "name": "Summer 23 - 01 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "OrnwE_N4AAycjowAPnrb4JRvZv2", "name": "Summer 23 - 02 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "IVkVc0o_Um5EicUYnv2AgrC4bU3", "name": "Summer 23 - 03 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "u0LR7q6HiWK8ini57OxtB6YbRWg", "name": "Summer 23 - 04 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "GnMc1n1EdkmYmIRrQz8dIWHDN1d", "name": "Summer 23 - 05 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "KKz81Hsq8x2C1GcSTBYqHSZQta2", "name": "Summer 23 - 06 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "E4xvkaaKWJiwFW9ai8SibSnrX41", "name": "Summer 23 - 07 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "sEyGHGeq9JreMr0KyqhT8ot76Z7", "name": "Summer 23 - 08 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "z2cCddhwVGtBlyqJwV596tlqggi", "name": "Summer 23 - 09 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "8okMuidmbO1rT2Md6XOE8sdrdh1", "name": "Summer 23 - 10 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "9x2oOl5RBLviampR_YKIsAAiWxf", "name": "Summer 23 - 11 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "DpXbHIb4Lkv_9fb_K7mVWw8DBX5", "name": "Summer 23 - 12 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "wiSzAfZ_1XCEgn23yhVTcDBDUH2", "name": "Summer 23 - 13 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "Ymn0gRq4xpc_FYWQ7ZD5_9aOZwl", "name": "Summer 23 - 14 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "iaEK7KNoUZuQ5ZYHI4uucitiiDg", "name": "Summer 23 - 15 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "GA5N5uNfL1PvkOs4G84aB7uiL6a", "name": "Summer 23 - 16 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "nMRtmZsrNE_59lq2Mz7AImdiEbm", "name": "Summer 23 - 17 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "YmCbjjwJc_uy_H91OqJ__lcuPqd", "name": "Summer 23 - 18 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "hGePobP5bCyav0U0fndo0YKQtzl", "name": "Summer 23 - 19 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "YM24OXeUqNHgU2ZZoz0UJvCqlhl", "name": "Summer 23 - 20 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "Q7RIeYYPgCZLOVd44E9_4RncLJ8", "name": "Summer 23 - 21 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "W1SoCvYhBHMqwacyZfJsOcs5mD3", "name": "Summer 23 - 22 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "f9cscN6vUTPCztctYH1IYuV6a_i", "name": "Summer 23 - 23 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "fUWWXwVSsmqZ_mcuCQLrjzAvvah", "name": "Summer 23 - 24 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},
    {"uid": "lPokmH0iNWyaeETM5VHkDvcpy0i", "name": "Summer 23 - 25 - Bumper", "season": "summer", "year": "2023", "alteration": "Bumper"},

    ### Blind
    {"uid": "bH3djwuAhzBA4teqjyYYSvfjeye", "name": "Fall 01 (BLIND)", "season": "fall", "year": "2020", "alteration": "Blind"},
    {"uid": "u1sfTozBpraUoW335jYx4BgT6x8", "name": "Fall 02 (BLIND)", "season": "fall", "year": "2020", "alteration": "Blind"},
    {"uid": "bfYyFo87BxTUI43zPpiu6cmMIX0", "name": "Fall 03 (BLIND)", "season": "fall", "year": "2020", "alteration": "Blind"},


    # Maps that have a mistake of some sort
    {"uid": "FtDk7c3C5vkysl9MUXwdwGcd1B5", "name": "winter 2020 01 slowmo", "season": "winter", "year": "2021", "alteration": "Slowmo"},
    
    {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
    

    # xx but maps that cannot be propperly sorted. 

    {"uid": "TwPcOQqRllHY9ObbwPTGrU0geh1", "name": "Wntr 22 2 bt ony hlf te blks",              "season": "winter",   "year": "2022", "alteration": "", "isXX-But": True},
    {"uid": "SrvqZSubP00q4FNvSUCmgjdNRL",  "name": "Fall 10 But i miss 02",                     "season": "fall",     "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "2DakC9j3PstgGPKRuLpIldGRl53", "name": "Fall 10 but you're in a downward spiral",   "season": "fall",     "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "vdhc9NcrxcEbSkr2ScufFKB7Uxk", "name": "fall 02 Deja vu",                           "season": "fall",     "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "Rffmu2aFOPZk39D_rfkNW7luKTa", "name": "Wait a minute!?",                           "season": "fall",     "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "Rffmu2aFOPZk39D_rfkNW7luKTa", "name": "Wait a minute!?",                           "season": "summer",   "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "Rffmu2aFOPZk39D_rfkNW7luKTa", "name": "Wait a minute!?",                           "season": "spring",   "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "pwOTqVkNmf3_WR0EFDdjHM9ILab", "name": "Fall 01 But It's Rearranged",               "season": "fall",     "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "wIWz8ad60INLbxgqbupEXb_0KZl", "name": "Trash map",                                 "season": "fall",     "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "3yGF6Yif_2CUdHLajRY1Wqetv9e", "name": "Spring 01 But honey I shrunk the car",      "season": "spring",   "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "VjQaRN60zt6RfuX6bK_wqmlXDum", "name": "idk",                                       "season": "training", "year": "",     "alteration": "", "isXX-But": True},
    {"uid": "A9Cr1GNcEZMUUJ5_SjbWQtgeSTa", "name": "the fatal ending",                          "season": "summer",   "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "fCo_IRzs4wOlUoX3vX3cmbb2zef", "name": "Spring 01 but its a one lapper",            "season": "spring",   "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "3AMkzCsXb2IzOTWkeLwwPXs_AFa", "name": "Spring 01 But It's Sideways",               "season": "spring",   "year": "2021", "alteration": "", "isXX-But": True},

    {"uid": "IKBHYQdUcpmDdB7nNES29Tw93tf", "name": "Spring 01 But its combined with 02",        "season": "spring",   "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "yAKXyLdUmdPSK4jSjFZaFD0pCq9", "name": "Déjà vu",                                   "season": "summer",   "year": "2021", "alteration": "", "isXX-But": True},
    {"uid": "e_mTjgfxuHmKaMgQrQ9qvquhkCd", "name": "final boss",                                "season": "summer",   "year": "2021", "alteration": "", "isXX-But": True},

    {"uid": "", "name": "", "season": "", "year": "", "alteration": "", "isXX-But": True},
    
    
    # Other
    {"uid": "Vjhu6a1GXWJGJbNJydlZtC2MOtj", "name": "PLACEHOLDER 04", "season": "spring", "year": "2023", "alteration": "1-UP", "obtainable": False},












    #######################

    # Competitions

    # TMGL Fall 2020
    {"uid": "mYsC_SFD6cMK8vSX5Ev6sqnkqw8", "name": "BumpyJumpy",                  "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "U5J07hNmKEEOFvIzlZZp1RCXsz5", "name": "Circles",                     "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "H1QIG6oJLt7OU46My4pSSfD1Y0i", "name": "Dune",                        "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "m2d9V9SynsmhP9iEz1tv1mcFbn0", "name": "Eurostep",                    "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "LLM0xhyVVa2MciMNf2qVIT11TGc", "name": "FlyBack",                     "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "H45xb09fPznW83xa67sQS5TnHz6", "name": "GlacierHiking",               "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "TXukD6AzZ6dpIuZHqOJEFpiQmq7", "name": "Halfpipe",                    "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "hBwgI_K87mIFe8ARxUjGB1yOgZ9", "name": "Hoverboard",                  "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "JEzh_pvzYwjen_5t7eQNDIHvZ_2", "name": "Paradice",                    "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "3DiNydIBs3wK96LnxbGET5PRdAe", "name": "Semiramis (Feat Firestorrm)", "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "jGd9CAtaBsMGqDkeW0SZRBidqX6", "name": "SideWave",                    "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "qILevE59qeLZ2DH0tgh8dG6KJWk", "name": "SnowStep ft Tona",            "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "3Muz1cW6c_oo2CGonHY3sADcFkk", "name": "StarGlide",                   "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "IOmzzTEN3T1m5F_L_kToGJuhZ6f", "name": "SwitchBridge",                "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},
    {"uid": "1pwSzJrH4CYEGEd2fUJ0b9YuWKj", "name": "TreeJump",                    "season": "Fall", "year": "2020", "alteration": "AllOfficialCompetitions"},

    # TMGL Winter 2021
    {"uid": "8xZ16KN803bUYpiUQt7kFFxSPD1", "name": "Arctic Split",      "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "uYZnjYekW3Im4X7EmG7RIRWunql", "name": "Bookcase",          "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "4RDqVKTe90s6wpMYov1dhi2ZmB1", "name": "Frozen Fridges",    "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "6ZSmAqah7QPVs35hyrppYu8_32b", "name": "GapJumper",         "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "fiqr3BUDADXDanQtI8lMUWyuUl9", "name": "Leap of Faith",     "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "FPbro4SXJFKz4GL7k5jB4_OR4p5", "name": "Picicle",           "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "CEzFrFOIC9s5LM44KsWkmHTovjk", "name": "SkiJump",           "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "RMgK_3JRajCBDNrzZqHGn5y_gJj", "name": "Slalom",            "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "sNPikVMxMIjO568t8fosP5PcYug", "name": "SlowmoForest",      "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "4eY78dT3Slk841bh2hzalllos1e", "name": "Switcheroo",        "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "tse0JHHcr88uPUAEZ3AIajHTnt0", "name": "ToThePeak",         "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "AYQQ9n9FhR0QfnE4XoO3ayeHHId", "name": "VantaNeo",          "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "i_wnZ5MjQt4W7sWSOmqdI5EV5C1", "name": "WhirlPool",         "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "esTwzCWglmmCgZVy2t8arB2aZUd", "name": "Whoops",            "season": "Winter", "year": "2021", "alteration": "AllOfficialCompetitions"},

    # TMGL Fall 2021
    {"uid": "6CvzlH_5zZBHvjn6k3WWcTndaPf", "name": "Barrelistic",       "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "KGWHgZwVVCYkktj2sBBMEw6uNCg", "name": "BoltHoles",         "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "VTmAkIVTZl6a97e6TbJK78ZWKX5", "name": "EuroSky II",        "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "uBIzpWqqZLN4PIXHwchmevNY3O6", "name": "Grasshopper",       "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "TRFEKtObhuDn_1NRqfktrvKVvv2", "name": "IcySnake",          "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "bUbKj37BqcxSYA_Zo8mZupMa8j8", "name": "LaunchPad",         "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "E78tnjO1T0sPuwnNc0y9oFKNji1", "name": "OnTheEdge",         "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "7ddD_3LNrttIMHKyRqNcoSEZwEh", "name": "PoleParty",         "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "xbJ_jg2jvpooFRKuorULX6aQjtj", "name": "Poolside",          "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "5gor_0D3D4eyv4K4FjmJ3CPyfWe", "name": "Throttling Act",    "season": "Fall", "year": "2021", "alteration": "AllOfficialCompetitions"},

    # TMWC 2021
    {"uid": "0vkyGNrvPQ3PJegPlqt6_vwfT6a", "name": "Arctic Split",      "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "PbfEZhpGlX9NfQ16IyhhMiJX31",  "name": "Halfpipe",          "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "CB_LduTX2bKpqi5nAcfNkdbR4N7", "name": "Paradice",          "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "pXcDo8mc2i4RjytuJ56I1a3zYq8", "name": "Reversing",         "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "K6W8yxL2JbPPZtJTMPN3HYGLJd5", "name": "Semiramis",         "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "mluy6I5qASQgt0Xu5xY3m49Esei", "name": "Slalom",            "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "wq0RoFTNIoFlFZ95Ab33tBg0bsd", "name": "TurboStairs",       "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},
    {"uid": "EqLYWxoQbEHJnALrSTQ4mmVm8Mj", "name": "Zazigzag",          "season": "_", "year": "2021", "alteration": "AllOfficialCompetitions"},

    # TMGL Spring 2022
    {"uid": "4YMl2lfd7poyAyIJc4E8UeqMjO0", "name": "Bowl",              "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "cl7ccO_DQqz0fiYBwYvFWOg6314", "name": "Clock Tower",       "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "eK_xz7d9hv7mRxnTw6tEJTkvHQb", "name": "Grassline",         "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "PLy9b_0RwmZrWOPowsRER7DRBS3", "name": "Heart",             "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "z1W3VYg914_KbvQfMwx4_kg8tmj", "name": "IcyJump",           "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "pBofuyyhwJwIjWa_aoHwcYEVx5j", "name": "TightRope",         "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "Yfxig0UNwNRs4v_BqfqRwieYuvd", "name": "TinyGap",           "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "zwpoQsgpok5m0EQTSZZ5F6wEYNg", "name": "Turnover",          "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "WurdoMaM2GXzefXCE8sZxZWV7i5", "name": "WaterGlider",       "season": "Spring", "year": "2022", "alteration": "AllOfficialCompetitions"},

    # TMWC 2022
    {"uid": "vLyFqhTbwuEF4S3apZHJ0aqeX2j", "name": "BoltHoles",         "season": "_", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "c58bH4hukDBGLCABsLgekMottZ3", "name": "Heart",             "season": "_", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "bYhKboPS588ne1hQJhYivO2E2oj", "name": "Poolside",          "season": "_", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "U70vE5e7DbeUlL0kb8UyOsrZzD3", "name": "QuickSand",         "season": "_", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "9fQKjqrJotYk5S_V7o_VfpgUYi9", "name": "Slalom",            "season": "_", "year": "2022", "alteration": "AllOfficialCompetitions"},
    {"uid": "KFEQQRS6AAeK0dAda4Snk6C1JUc", "name": "TinyGap",           "season": "_", "year": "2022", "alteration": "AllOfficialCompetitions"},

    # TMWT Spring 2023 Stage 1
    {"uid": "079I2edcwtj8JRjEwf6hc1zBx78", "name": "Aeropipes",         "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "cXJvHzJdFZUkKh4wWFCzyAO8wm8", "name": "Agility Dash",      "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "c2RkJ23ONJMrXI_nkMjvkPfTrhg", "name": "Back'N'Forth",      "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "SxiMAPLufob852FoWQbtBPbGYM3", "name": "Flip of Faith",     "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "ufgYrFAYUyv2mfX52Bcm102GbC0", "name": "Freestyle",         "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "3wShwwx7cNnzF50Uu4LD6F7Icv0", "name": "Gyroscope",         "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "nwxMuUKvB5ZmvWX8Sqemnj8Qqk6", "name": "Parkour",           "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "MJSTbd3SHGcPNbS6bgbkDgGPdph", "name": "Reps",              "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "Bc1S750l6ROoX7EVq0ltji6fNC",  "name": "SlippySlides",      "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "X57aVa_wZq3zzYr3UUBfZIu2MMj", "name": "Slowdown",          "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},

    # TMWT [E] Spring 2023 Stage 1
    {"uid": "w6yZQCKiSkqWDLZNErw49qtbeG6", "name": "Aeropipes [E]",     "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "uOS8IXicSoHX_oo3rcpl81pwEAj", "name": "Agility Dash [E]",  "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "lgbphUU9UpJZSoKc8dTD3EjPmtj", "name": "Back'N'Forth [E]",  "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "4VxmHRGL5aQ9Ap_WAZicwKb1ohb", "name": "Flip of Faith [E]", "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "N7TWhYUiecAXf7wx_naPzpkaaUd", "name": "Freestyle [E]",     "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "Wa0FxXSM363CCYEh3uTwjxOTcLi", "name": "Gyroscope [E]",     "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "YI2kowTGtzFHqkPGZFyRG4SUha3", "name": "Parkour [E]",       "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "D6JgQlTA1Zm6ukVmdk_WECLW4Ki", "name": "Reps [E]",          "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "FgFXuAsWiZr7M9RUwWduKplLcf5", "name": "SlippySlides [E]",  "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "ZV2aWMY9SRgGkXR_ol8aiw7n37l", "name": "Slowdown [E]",      "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},

    # TMWT Spring 2023 Stage 2
    {"uid": "NqGzny1hTb4SQCe_tzznU4xmQvm", "name": "Airwalk",           "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "wGPWFgUg9wpJCTg1QRHPC90icm0", "name": "Breaking",          "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "wCrhYurL6H6oX2YYG9EBG5Q2lze", "name": "Control",           "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "Q9tzUk5lC0tXKLduCSftM8uOadc", "name": "Frosty",            "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "ypwxYrQx4am3Bu0y4eENMDHFPt3", "name": "Grip",              "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "u0bt42TkQV9bpF63quo5KI9uJNe", "name": "Offroad",           "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "6ojwfbRpy94C2r4874TualT5We2", "name": "Pool",              "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "p8XTL8gPJRl3c4Ls_8Dy7X5yJp0", "name": "Sinuous",           "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "l7VxtNSAP0FUAPKhD0fuhD2uGO3", "name": "Speed",             "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "5tKUYnlBZU_1TMeO9GemJL1ZeQf", "name": "Vortex",            "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},

    # TMWT [E] Spring 2023 Stage 2
    {"uid": "wDBXx7nnNDm1NVxIbWz4Tvc8mF9", "name": "Breaking E",        "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "m_gGU58UfUwULTidwfkiB_ry3zf", "name": "Control E",         "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "dvD9KDWyz5eTCbHvz0Pr1hjts21", "name": "Frosty E",          "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "1AHvHDL0ms_QSdiw9ygrwRgn7qd", "name": "Grip E",            "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "pZzQLqja8TtqcHDZ2XZO75oPWq3", "name": "Offroad E",         "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "jJijwXARb2qQglID5oLE0NAG60l", "name": "Pool E",            "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "YxeZw8hY62nBAqTC7KUrSlD_3Gi", "name": "Sinuous E",         "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "SxvhvVnlgQHyqmAZsBxQFkarfJj", "name": "Speed E",           "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},
    {"uid": "r3wmDiuHJS76_8VqCMlS3yX7iSh", "name": "Vortex E",          "season": "Spring", "year": "2023", "alteration": "AllOfficialCompetitions"},

]


map_data = load_json_data("data/map_data.json")
sorted_maps = sort_maps_by_category(map_data)
save_sorted_data(sorted_maps, "bySeason")
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



def normalize_map_names(name):
    if verbose:
        print(f"Normalizing map name: {name}")
    return name.lower().replace("_", " ")



def parse_map_category(map_info, alterations_dict, exclusion_lists, special_uids):
    filename = map_info.get('filename', '')
    map_name = map_info.get('name', '').lower()
    uid = map_info.get('mapUid', '')

    if verbose:
        print(f"Parsing map category for {filename}")

    name_to_use = filename if len(filename) <= 100 else map_name
    normalized_name = name_to_use.lower().replace("_", " ")

    # Handle special UIDs
    special_uid_result = handle_special_uids(uid, special_uids)
    if special_uid_result:
        return special_uid_result

    # Exclude maps that are not obtainable
    exclusion_list_result, modified_name = handle_exclusion_list(normalized_name, exclusion_lists)
    if exclusion_list_result:
        return exclusion_list_result
    normalized_name = modified_name

    # Handle regular alterations
    alteration_result = handle_regular_alterations(normalized_name, alterations_dict)
    if alteration_result and alteration_result != "!MapIsNotInAlterationsDict":
        return alteration_result

    # Retry with map name if filename failed
    if name_to_use != map_name:
        normalized_map_name = map_name.lower().replace("_", " ")
        return handle_regular_alterations(normalized_map_name, alterations_dict)

    return alteration_result



def handle_special_uids(uid, special_uids):
    if verbose:
        print(f"Handling special UIDs for {uid}")
    for special_map in special_uids:
        if uid == special_map.get('uid'):
            if special_map.get('obtainable') == False:
                return "!MapIsNotObtainable"
            return special_map.get('alteration')
    return None



def handle_exclusion_list(normalized_name, exclusion_lists):
    if verbose:
        print(f"Handling exclusion list for {normalized_name}")
    for exclusion_list in exclusion_lists:
        for excluded in exclusion_list:
            excluded_lower = excluded.lower()
            if excluded_lower in normalized_name:
                if verbose:
                    print(f"Excluding {excluded_lower} from {normalized_name}")
                if normalized_name != excluded_lower:
                    normalized_name = normalized_name.replace(excluded_lower, "").strip()
    return None, normalized_name



def handle_regular_alterations(name, alterations_dict):
    if verbose:
        print(f"Handling regular alterations for {name}")
    special_cases = special_cases_array
    
    normalized_name = name.lower()

    for alteration, keywords in alterations_dict.items():
        for keyword in keywords:
            if normalized_name == keyword.lower():
                return alteration

    for case in special_cases:
        if all(word.lower() in normalized_name for word in case.split()):
            return case

    longest_match = ""
    longest_match_key = ""

    for alteration, keywords in alterations_dict.items():
        for keyword in keywords:
            if keyword.lower() in normalized_name and len(keyword) > len(longest_match):
                longest_match = keyword
                longest_match_key = alteration

    return longest_match_key if longest_match else "!MapIsNotInAlterationsDict"



def sort_maps_by_category(map_data, alterations_dict, exclusion_lists, special_uids):
    if verbose:
        print("Sorting maps by category")
    sorted_maps = defaultdict(list)
    for map_info in map_data:
        categories = parse_map_category(map_info, alterations_dict, exclusion_lists, special_uids)
        for category in categories:
            sorted_maps[category].append(map_info)
    return sorted_maps



def save_sorted_data(sorted_data, base_folder):
    if verbose:
        print(f"Saving sorted data to {base_folder}")
    if not os.path.exists(base_folder):
        os.makedirs(base_folder)
    for category, maps in sorted_data.items():
        with open(os.path.join(base_folder, f"{category}.json"), 'w', encoding='utf-8') as file:
            json.dump(maps, file, indent=4, ensure_ascii=False)



special_cases_array = [
    "YEET Reverse", "[Snow] Wood", "[Snow] Checkpointless", "[Rally] CP1 is End", "[Stadium] Wet Wood", "[Snow] Wet-Plastic"
]

alterations_dict = {
    #"xx-But": "XX-But",

    "[Snow]": ["[Snow]", "SnowCar", "CarSnow"],
    "[Snow] Carswitch": ["Carswitch", "Snowcarswitch"],
    "[Snow] Checkpointless": ["Checkpointless snow", "[Snow] Checkpointless", "[Snow] cpless"],
    "[Snow] Icy": ["Icy [Snow]", "[Snow] Icy"],
    "[Snow] Underwater": ["(SnowCar UW)", "(Snow Car UW)"],
    "[Snow] Wet-Plastic": ["(Snow) Wet-Plastic"],
    "[Snow] Wood": ["[Snow] Wood"],

    "[Rally]": ["[Rally]", "RallyCar", "CarRally"],
    "[Rally] Carswitch": ["Rallycarswitch"],
    "[Rally] CP1 is End": ["[Rally] CP1 is End", "RallyCar CP1 is End", "Rally CP1-End", "Rally CP1End", "Rally CP1 Ends", "Rally Cp1 is End"],
    "[Rally] Underwater": ["[Rally] (UW)"],
    "[Rally] Icy": ["Icy [Rally]", "[Rally] Icy", "Ricy"],

    "[Desert]": ["[Desert]", "DesertCar", "CarDesert"],
    
    "[Stadium]": ["[Stadium]", "StadiumCar", "CarStadium", "CarSport"],
    "[Stadium] Wet Wood": ["Wet Wood Stadium Car", "[Stadium] Wet Wood", "Wet Wood CarSport"],
    
    "100% Wet Icy Wheels": ["100% Wet Icy Wheels", "100% Wet-Icy-Wheels", "100% WetIcyWheels", "100%WetIcyWheels"],

    "1 Down": ["1 Down", "1-Down", "1Down", ],
    # "1 Forward": ["1 Forward", "1-Forward", "1Forward"], # This is not included since it is the same as 1-back
    "1 Back": ["1 Back", "1-Back", "1Back", "1 Forward", "1-Forward", "1Forward"],
    "1 Left": ["1 Left", "1-Left", "1Left"],
    "1 Right": ["1 Right", "1-Right", "1Right"],
    "1 Up": ["1 Up", "1-Up", "1Up"],
    "2 Up": ["2 Up", "2-Up", "2Up"],
    "Flat_2D": ["2D", "Flat"],
    # "A08": ["A08", "A-08", "- 08"], # This is not included because of naming conflicts
    "Antibooster": ["Antibooster"],
    "Backwards": ["Backwards"],
    "Better Mixed": ["Better Mixed"],
    "Better Reverse": ["Better Reverse", "(BeVerse)"],
    "Blind": ["Blind"],
    "There and Back_Boomerang": ["There and Back", "There&Back", "Boomerang"],
    "BOSS": ["White BOSS", "Green BOSS", "Blue BOSS", "Red BOSS", "Black BOSS", "BOSS White", "BOSS Green", "BOSS Blue", "BOSS Red", "BOSS Black"],
    "Boosterless": ["Boosterless"],
    "Bobsleigh": ["Bobsleigh"],
    "Broken": ["Broken"],
    "Bumper": ["Bumper"],
    "Cacti": ["Cacti"], # N'golo?
    "Checkpoin't": ["Checkpoin't"],
    "Cleaned": ["Cleaned"],
    "Colours Combined": ["White Combined", "Green Combined", "Blue Combined", "Red Combined", "Black Combined"],
    "CP_Boost": ["CP-Boost Swap"],
    "CP1 is End": ["CP1 is End", "CP1isEnd", "CP1-End", "CP1End", "CP1 Ends", "Cp is End"],
    "CP1 Kept": ["CP1 Kept"],
    "CPfull": ["CPfull"],
    "Checkpointless": ["Checkpointless", "CPLess"],
    "Checkpointless Reverse": ["CPLess, Reverse", "Checkpointless Reverse"],
    "Chinese": ["训练", "\u590f\u5b63\u8d5b"],
    "CPLink": ["CPLink"],
    "Cruise": ["Cruise", "Cruise Control"],

    "Dirt": ["Dirt", "Dirty"],
    "Road Dirt": ["Road Dirt"],

    "Earthquake": ["Earthquake"],
    "Egocentrism": ["Egocentrism"],
    "Fast": ["Fast"],
    "Fast Magnet": ["FastMagnet"],
    "Flipped": ["Flipped", "UpsideDown"],
    "Flooded": ["Flooded"],
    "Floor Fin": ["Floor-Fin"],
    "Freewheel": ["Freewheel"],
    "Fragile": ["Fragile"],
    "Glider": ["Glider"],
    "Got Rotated_CPs Rotated 90°": ["Got Rotated", "CPs Rotated 90°", "CPs Rotated 90"],
    "Grass": ["Grass", "Grassy"],
    "Ground Clippers": ["Ground Clippers"],
    "Holes": ["Holes"],
    "Ice": ["Ice", "Icy"],
    "Ice Reverse": ["Ice Reverse", "Ice-Reverse", "IceReverse", "Icy Reverse", "Icy-Reverse", "IcyReverse", "IR", "IceRev", "Ice-Rev", "IceRev", "IcyRev", "Icy-Rev", "IcyRev"],
    "Ice Reverse Reactor": ["Icy RR", "Ice Reverse Reactor", "Ice-Reverse Reactor", "IceReverseReactor", "Icy Reverse Reactor", "Icy-Reverse Reactor", "IcyReverseReactor"],
    "Ice Short": ["Ice Short", "short - Icy", "short-Icy", "shortIcy", "Icy Short", "Icy-Short", "IcyShort", "Ice-Short", "IceShort"],
    "Icy Reactor": ["Icy Reactor", "Icy-Reactor", "IcyReactor"],
    "Inclined": ["Inclined"],
    "Lunatic": ["Lunatic", "Hard", "Harder"],
    "Magnet": ["Magnet"],
    "Magnet Reverse": ["Magnet Reverse", "Magnet-Reverse", "MagnetReverse"],
    "Manslaughter": ["Manslaughter"],
    "Mini RPG": ["Mini RPG", "MiniRPG", "Mini-RPG", "RPG "],
    "Mirrored": ["Mirrored", "Mirror"],
    "Mixed": ["Mixed"],
    "Ngolo_Cacti": ["springolo", "falln'golo"],
    "No Effects": ["Effectless"],
    "No Cut": ["No-cut", "NoCut", "No Cut"],
    "No Steer": ["No-Steer", "NoSteer", "No Steering", "NoSteering"],
    "No Brakes": ["No-brakes", "NoBrakes", "No Brakes"],
    "No Grip": ["No Grip", "No-grip", "NoGrip"],
    "No Gear 5": ["No gear 5", "NoGear5", "No-Gear5", "No-Gear 5", "No Gear5", "No-Gear-5"],
    "Penalty": ["Penalty"],
    "Podium": ["Podium"],
    "Pipe": ["Pipe"],
    "Plastic": ["Plastic"],
    "Plastic Reverse": ["Plastic Reverse", "Plastic-Reverse", "PlasticReverse", " PR"],
    "Platform": ["Platform"],
    "Pool Hunters": ["Pool Hunters", "PoolHunters", "Pool-Hunters", "Poolhunter", "Pool-Hunter", " Hunter"], # Hunter added because of Pool special case
    "Puzzle": ["Puzzle"],
    "Random": ["Random"],
    "Random Dankness": ["Random Dankness", "RandomDankness", "Random-Dankness"],
    "Random Effects": ["Random Effects", "RandomEffects", "Random-Effects"],
    "Reactor": ["Reactor"],
    "Reactor Down": ["ReactorDown", "Reactor Down", "Reactor-Down"],
    "Reverse": ["Reverse", "reverse"],
    "Ring CP": ["Ring CP", "RingCP", "Ring-CP", "RingCP%", "Ring CP%", "Ring-CP%"],
    "Road": ["Road", "Asphalt", "Tarmac", "(Tech)"],
    "Roofing": ["Roofing"],
    "RNG Booster": ["RNG Booster"],
    "Sausage": ["Sausage"],
    "Sections Joined": ["Section 1 Joined", "Section 2 Joined", "Section 3 Joined", "Section 4 Joined", "Section 5 Joined", "Section 6 Joined", "Section 7 Joined", "Section 8 Joined", "Section 9 Joined", "Section 10 Joined", "Section 11 Joined", "Section 12 Joined", "Section 13 Joined", "Section 14 Joined", "Section 15 Joined", "Section 16 Joined", "Section 17 Joined", "Section 18 Joined", "Section 19 Joined", "Section 20 Joined", "Section 21 Joined", "Section 22 Joined", "Section 23 Joined", "Section 24 Joined", "Section 25 Joined", "Section 26 Joined", "Section 27 Joined", "Section 28 Joined", "Section 29 Joined", "Section 30 Joined", "Last Section Joined"],
    "Select DEL": ["Select DEL", "Select-DEL", "SelectDEL"],
    "Scuba Diving": ["Scuba Diving", "ScubaDiving", "Scuba-Diving"],
    "Short": ["Short"],
    "Sky is the Finish": ["Sky is the Finish", "skyfinish", "SITF", "skyfin"],
    "Sky is the Finish Reverse": ["Rev Sky Finish", "Rev Sky Fin", "Sky is the Finish Reverse", "SkyFinish Reverse", "SITF Reverse", "SkyistheFinishReverse","Rev Sky is Finish", "Sky is the Finish - Reverse", "Sky-is-the-Finish-Reverse", "Rev  Sky is Finish"],
    "Slowmo": ["Slowmo", "Slow-Mo", "Slow Mo"],

    "Speedlimit": ["Speedlimit", "Speed-Limit", "Speed Limit"],
    "Staircase": ["Staircase"],
    "Start 1-Down": ["Start 1 Down", "Start1Down", "Start-1-Down", "Start1-Down", "Start 1-Down"],
    "sw2u1l-cpu-f2d1r": ["sw2u1l-cpu-f2d1r", "Start water 2 up 1 left - Checkpoints unlinked - Finish 2 down 1 right"],
    "Supersized": ["Supersized", "SuperSized", "Super-Sized", "Big", "Super01", "Super02", "Super03", "Super04", "Super05", "Super06", "Super07", "Super08", "Super09", "Super10", "Super11", "Super12", "Super13", "Super14", "Super15", "Super16", "Super17", "Super18", "Super19", "Super20", "Super21", "Super22", "Super23", "Super24", "Super25"],
    "Surfaceless": ["Surfaceless"],
    "Straight to the Finish": ["Straight to the Finish", "STTF", "StraighttotheFinish", "Straight-to-the-Finish", "Straighttothe-Finish", "Straight to the-Finish"],
    "Stunt": ["Stunt"],
    "Symmetrical": ["Symmetrical"],
    "TMGL Easy": ["TMGL Easy", "TMGLEasy", "TMGL-Easy", "[EASY MODE]"],
    "Tilted": ["Tilted"],
    "Underwater": ["Underwater", "UNW"],
    "Underwater Reverse": ["Underwater Reverse", "Underwater-Reverse", "UnderwaterReverse", "UNW Reverse", "UNW-Reverse", "UNWReverse", "UNWR", "UW Reverse", "UW-Reverse", "UWReverse", "UWR"],
    "Walmart Mini": ["Walmart Mini", "WalmartMini", "Walmart-Mini"],
    "Wet Plastic": ["Wet Plastic", "WetPlastic", "Wet-Plastic"],
    "Wet Wheels": ["Wet Wheels", "WetWheels", "Wet-Wheels"],
    "Wet Wood": ["Wet Wood", "WetWood", "Wet-Wood"],
    "Wet Icy Wood": ["Wet Icy Wood", "WetIcyWood", "Wet-Icy-Wood"],
    "Worn Tires": ["Worn Tires", "WornTires", "Worn-Tires"],
    "Wood": ["Wood"],
    "YEET": ["YEET"],
    "YEET Max-Up": ["Yeet Max-Up", "Yeet-Max-Up", "Yeet Max Up", "YeetMaxUp", "Max-up"],
    "YEET Down": ["YEET Down", "YEET-Down", "YEETDown", "DEET"],
    "YEET Puzzle": ["(YEET Puzzle)"],
    "YEET Random Puzzle": ["(YEET Random Puzzle)"],
    "YEET Reverse": ["YEET Reverse", "YEET-Reverse", "YEETReverse"],
    "YEP Tree Puzzle": ["YEP Tree Puzzle", "YEPTreePuzzle", "YEP-Tree-Puzzle"],
}

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
    # 
    
    # Other maps
    
        {"uid": "7QzByRVA_7pLuA_aFJgJR_Z0wOk", "name": "Spring 2022 - 11 - one back", "season": "spring", "year": "2022", "alteration": "1 Back"},
    
    
    
    
    
    
    
    
    

    # xx but maps that cannot be propperly sorted. 
    #{
        {"uid": "TwPcOQqRllHY9ObbwPTGrU0geh1", "name": "Wntr 22 2 bt ony hlf te blks",                      "season": "winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "SrvqZSubP00q4FNvSUCmgjdNRL",  "name": "Fall 10 But i miss 02",                             "season": "fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "2DakC9j3PstgGPKRuLpIldGRl53", "name": "Fall 10 but you're in a downward spiral",           "season": "fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "vdhc9NcrxcEbSkr2ScufFKB7Uxk", "name": "fall 02 Deja vu",                                   "season": "fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "Rffmu2aFOPZk39D_rfkNW7luKTa", "name": "Wait a minute!?",                                   "season": "fall",       "year": "2021", "alteration": "XX-But"}, 
        {"uid": "Rffmu2aFOPZk39D_rfkNW7luKTa", "name": "Wait a minute!?",                                   "season": "summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "Rffmu2aFOPZk39D_rfkNW7luKTa", "name": "Wait a minute!?",                                   "season": "spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "pwOTqVkNmf3_WR0EFDdjHM9ILab", "name": "Fall 01 But It's Rearranged",                       "season": "fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "wIWz8ad60INLbxgqbupEXb_0KZl", "name": "Trash map",                                         "season": "fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "3yGF6Yif_2CUdHLajRY1Wqetv9e", "name": "Spring 01 But honey I shrunk the car",              "season": "spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "VjQaRN60zt6RfuX6bK_wqmlXDum", "name": "idk",                                               "season": "training",   "year": "",     "alteration": "XX-But"},
        {"uid": "A9Cr1GNcEZMUUJ5_SjbWQtgeSTa", "name": "the fatal ending",                                  "season": "summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "fCo_IRzs4wOlUoX3vX3cmbb2zef", "name": "Spring 01 but its a one lapper",                    "season": "spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "3AMkzCsXb2IzOTWkeLwwPXs_AFa", "name": "Spring 01 But It's Sideways",                       "season": "spring",     "year": "2021", "alteration": "XX-But"},

        {"uid": "IKBHYQdUcpmDdB7nNES29Tw93tf", "name": "Spring 01 But its combined with 02",                "season": "spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "yAKXyLdUmdPSK4jSjFZaFD0pCq9", "name": "Déjà vu",                                           "season": "summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "e_mTjgfxuHmKaMgQrQ9qvquhkCd", "name": "final boss",                                        "season": "summer",     "year": "2021", "alteration": "XX-But"},

        {"uid": "OnBMo_TQAKs87qcFbuNC196jcDh", "name": "YEET Fall 2023 - 10 with snow car",                 "season": "Fall",       "year": "2023", "alteration": "XX-But"},

        {"uid": "atsuGRcSLksxrEFv0dbbyl33Nx8", "name": "Summer 2023 - 01 (But fuck water)",                 "season": "summer",     "year": "2023", "alteration": "XX-But"},
        {"uid": "OEwlVhJ1rVHrm70JAigLiQvmqi",  "name": "Fall 2022 - 14 True One Lap",                       "season": "Fall",       "year": "2022", "alteration": "XX-But"},
        {"uid": "7SGIJPDk33sXVL2u4HguQYUSPu1", "name": "Fall 2021 - 01 but it's on the same elevation",     "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "BLsvoAwUlKOihYGOHqvEyjcrFqm", "name": "Summer 2023 - 04 But you are surfing",              "season": "Summer",     "year": "2023", "alteration": "XX-But"},
        {"uid": "CgMaq87wxhiMRVS_o9aV71UBKJ8", "name": "Training - 05 But You Love Loops",                  "season": "Training",   "year": "",     "alteration": "XX-But"},
        {"uid": "Dp38fk6dVjud1wmXz1ZlmIKG4O9", "name": "Spring 2021 - 01 but boosters",                     "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "OB50q1Qt3NMUf1VgEK2yVSsHP1k", "name": "Spring 2021 - 01 But its A01",                      "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "TkSn3dObQeCwRXWqQHJX0p5aFs3", "name": "Winter 2023 - 16 High Jump",                        "season": "Winter",     "year": "2023", "alteration": "XX-But"},
        {"uid": "Vjer2l15pmDoktdM05oBgeGMp0j", "name": "Spring 2021- 01 but is narrow",                     "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "bObfp2rToiR5a9e9cxOL7W2RvC8", "name": "Training - 03 4 effects",                           "season": "Training",   "year": "",     "alteration": "XX-But"},
        {"uid": "FVtSzsoyF4e7Iyqou83qgkqYik5", "name": "Winter 2022 - 01 blurry",                           "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "4Ja4R1vdXfrmXbFXUsaSdfFpTHd", "name": "Winter 2022 - 01 But It's More Water",              "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "AVgW30_SiQrL4J_GofCiGnzOnB3", "name": "Spring 2021 - 01 But its a looping dream",          "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "HmD_43zOh9MkQknkulSyIx92Ba1", "name": "Fall 2021 - 01 But It's x10",                       "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "hVbLjjmKM468F7aF_qeaFgmVp3k", "name": "Winter 2023 - 09 Multilap",                         "season": "Winter",     "year": "2023", "alteration": "XX-But"},
        {"uid": "wS8DCmMp3et1gnS3TtV1nwzvCif", "name": "Fall 2021 - 01 But it's Red Boosters",              "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "lvqeByTb7bHUJ3UkJwpreUXZnzj", "name": "Winter 2022 - 25 Dry",                              "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "hSj9KBylYFQWorqe4DRbnRK9mqi", "name": "Better Spring 2023 - 22",                           "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "rGJXxhEgPJ0tAwFBLzux0mxpVl8", "name": "Summer 2022 - 01 - Custom Camera",                  "season": "Summer",     "year": "2022", "alteration": "XX-But"},
        {"uid": "uObBX86_931S65tq_Gqi2ZQBt1j", "name": "Winter 2023 - 17 True One Lap",                     "season": "Winter",     "year": "2023", "alteration": "XX-But"},
        {"uid": "YrHVk5XZ8syqAJnn5ZVmUZT5MG5", "name": "Fall 2023 - 08 U-Turn",                             "season": "Fall",       "year": "2023", "alteration": "XX-But"},
        {"uid": "ihljWTsrX2_OuwhkPAR5YPouzlg", "name": "Winter 2022 - 25 But It's More Water",              "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "z0sz5SqulR5aawxbFSR5b7uUmFl", "name": "Fall 2021 - 01 But You Walk",                       "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "8tdiAsrRCJHy97Q7bx2wKXWppXm", "name": "Winter 2022 - 17 with better jumps",                "season": "Winter",     "year": "2021", "alteration": "XX-But"},
        {"uid": "IWBdoSZnYKqBEVcG2RWo7mEXGd2", "name": "Spring 2023 - 24 But only the colored blocks",      "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "wqOun00a8U_88Xm8FgNGu3LnOk2", "name": "Spring 2023 - 01 Better End",                       "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "ktZANe5mSb_ntk72Yz6a0y99vSf", "name": "Summer 2021 - 01 but smog is an issue",             "season": "Summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "QlztQh0eLarVuVHjKspZQcwfac3", "name": "Fall 2021 - 01 (Underground)",                      "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "_WOsZZgiUuOUpzo1uQWSD3N41p3", "name": "Summer 2023 - 09 (Scenery DEL)",                    "season": "Summer",     "year": "2023", "alteration": "Select DEL"},
        {"uid": "pNntqoipsieb8mv75xwQ7cswZ8",  "name": "Better Spring 2023 - 18",                           "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "yEKD0Ni53vP48bvUgo65gWlY0a1", "name": "Summer 2021 - 01 But its glass",                    "season": "Summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "8i5RpJHkAKUBVjnKE4EV74n3ZBb", "name": "Summer 2021 - 01 But It's More Water",              "season": "Summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "ID9hLjxZCLicNa0FjTLCKpSj2jl", "name": "Winter 2023 - 01 but its A01",                      "season": "Winter",     "year": "2023", "alteration": "XX-But"},
        {"uid": "0Qbp1w6aVStWUpFaRcP8p_PoHzd", "name": "Fall 2021 - 01 but it's different",                 "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "k943SKNVIJ9hPw6HXFOe5R6100k", "name": "Summer 2023 - 06 Better Multilap",                  "season": "Summer",     "year": "2023", "alteration": "XX-But"},
        {"uid": "VL03IttQlArs83lOD6kQsl9AG2",  "name": "Winter 2023 - 10 but no quarter",                   "season": "Winter",     "year": "2023", "alteration": "XX-But"},
        {"uid": "FoAq51mwYLD2WqYgMikiMuGaK7b", "name": "Spring 2023 - 01 but you can't see over 340 Speed", "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "Gk51Xm2MvLsBmf3f182wiDPPKY0", "name": "Summer 2023 - 17 (But fuck water)",                 "season": "Summer",     "year": "2023", "alteration": "XX-But"},
        {"uid": "q5rA4lUZ7Ly3x9qvzwFAUaHJd4i", "name": "Fall 2021 - 01 halfies",                            "season": "Fall",       "year": "2021", "alteration": "XX-But"},

        {"uid": "sMBqPPHboh9f37QPhc1izI6nM9e", "name": "Fall 2022 - 15 - all_up-1",                         "season": "Fall",       "year": "2022", "alteration": "XX-But"},
        {"uid": "sTSD0LDNins2V_YOIqxlKXnGS12", "name": "Spring 2021 - 01 Troll",                            "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "Ew12X_lbZTOEAN4NaoecKmL_ct0", "name": "Training - 02 4 effects",                           "season": "Training",   "year": "", "alteration": "XX-But"},
        {"uid": "EY2vlddsIuALf_5aUKlp90p3CLe", "name": "Fall 2023 - 10 but with bad parkour",               "season": "Fall",       "year": "2023", "alteration": "XX-But"},
        {"uid": "PCAIwyQo1dhyR2iYyrE9aZAkXug", "name": "Better Spring 2023 - 05",                           "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "pPym4VzkAFcWUinNkWcrwPzPsSj", "name": "Spring 2021 - 01 but its straight!",                "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "Gw8NeV7IRtgRHip6KFMDRVaCuri", "name": "Summer 2021 - 01 But its a bumpy ride",             "season": "Summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "MCK0JIzVIHHq28p1Brz6mIfnrpf", "name": "Better Spring 2023 - 04",                           "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "luqqnOQeA_raadhsrrZnVDUMVX8", "name": "Spring 2022 - 03 But It's More Water",              "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "BRswv8HZh7kQi8Lv8OzBgIyxSJa", "name": "Spring 2022 - 03 but no water wiggles",             "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "Q9nNs2ehza4unM1_Dv2GPGgQ_cl", "name": "Fall 2021 - 01 but pf !",                           "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "wAooUsQ3rLQ8SyK83df0elTANRi", "name": "Winter 2022 - 01 But it's Bumpy",                   "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "0jBlTMZZIT3G07i1VIZgaI_tQPd", "name": "Spring 2022 - 01 Wet",                              "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "PbJbKv0IF6ltDCRaSzpP7lmJiA4", "name": "Fall 2021 - 01 but it's RPG",                       "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "pBxCMP8RZ3GKv59sxBHlOjSuLyh", "name": "Spring 2023 - 04 Amogus",                           "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "udC5DwdMBgTbsLc5odUQskrNXnm", "name": "Summer 2023 - 06 Multilap",                         "season": "Summer",     "year": "2023", "alteration": "XX-But"},
        {"uid": "JXPUBtzB8NIKqJMg9vMkHyygUI4", "name": "Fall 2021 - 01 Booster",                            "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "knf5rHw_VijWVGuS5m4GJCHp_08", "name": "Spring 2022 - 01 but epilepsy",                     "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "s5cxMz2uFrdWPBfEsMOaNbHXhkk", "name": "Fall 2021 - 11 might be fixed KEKW",                "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        
        {"uid": "faLLzEZ46UQOiJYxkVBRSGXoVga", "name": "Spring 2021 - 01 But i was once a bobsled champion", "season": "Spring",    "year": "2021", "alteration": "XX-But"},
        {"uid": "_SdU5BlwMuvcR2_7ZAqCUQi1tB4", "name": "Fall 2022 - 01 but you take finishes instead of checkpoints", "season": "Fall", "year": "2022", "alteration": "XX-But"},

        {"uid": "6tYGxxpsQFyqSULaDZIP1nHaLG8", "name": "Spring 2022 - 15 Endurance",                        "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "7QzByRVA_7pLuA_aFJgJR_Z0wOk", "name": "Spring 2022 - 11 - one back",                       "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "iNovMY7spLbfzoUSiFo5g9Dfey4", "name": "Training - 01 4 effects",                           "season": "Training",   "year": "",     "alteration": "XX-But"},
        {"uid": "JSa9qlCCu44BvZP9z_d5Rbf9bp7", "name": "Spring 2021 - 01 But It's Global warmings fault?",  "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "X4yHWGvdvpYj5xBEr5AhQ9RI4M6", "name": "Summer 2022 - 08 - Extreme Tilt",                   "season": "Summer",     "year": "2022", "alteration": "XX-But"},
        {"uid": "CwfGwSiyOLdlT5Kq2dmEvvyip27", "name": "Winter 2022 - 20 but more poles",                   "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "XVgxBdyuwWhxhsV45IWgqE62Zu0", "name": "Fall 2021 - 01 But It's 4 times larger",            "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "aMALNvhlyB8Y98U1xv6j2v0WXMh", "name": "Fall 2022 - 04 but BAGUETTE",                       "season": "Fall",       "year": "2022", "alteration": "XX-But"},
        {"uid": "nQDqPJ8B2q_Eok5vSIwTtkgJoQb", "name": "Winter 2023 - 08 True One Lap",                     "season": "Winter",     "year": "2023", "alteration": "XX-But"},
        {"uid": "OUT66Df5dRtezPUvq7Lwu0ek_l6", "name": "Fall 2022 - 09 but BAGUETTE",                       "season": "Fall",       "year": "2022", "alteration": "XX-But"},
        {"uid": "UPmFclLvcPk0gmpfEMqLrx2XwD2", "name": "Training - 01 But You're Drunk",                    "season": "Training",   "year": "",     "alteration": "XX-But"},
        {"uid": "lzrJD23IwcBXL4a77Y3h5QjhLX4", "name": "Fall 2022 - 01 Orbit",                              "season": "Fall",       "year": "2022", "alteration": "XX-But"},
        {"uid": "OqefMgsstfPtu7tNTMyEAN8uTUl", "name": "Training - 14 X10",                                 "season": "Training",   "year": "",     "alteration": "XX-But"},
        {"uid": "Z2N8Gt_e6fWNNGJH76nR1LW2hha", "name": "Spring 2021 - 01 But It's on the same elevation",   "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "Rb1QU1cwUPl_mlsCsCawJ6euuvb", "name": "Spring 2023 - 24 - Easter Egg (ft AR_-_)",          "season": "Spring",     "year": "2023", "alteration": "XX-But"},
        {"uid": "O5S6bhBMExXSGc9yGxxees4T9pm", "name": "RORSCHACH Spring 2022 - 01",                        "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "wtJtT6prSNybTHBlmcC1XID_nv",  "name": "Fall 2022 - 14 But 69 laps",                        "season": "Fall",       "year": "2022", "alteration": "XX-But"},
        {"uid": "VH_A9MiEO2_4UcDNRFUj2eaFTfc", "name": "Training - Rainbow Combined",                       "season": "Training",   "year": "",     "alteration": "XX-But"},
        {"uid": "0pEAjzsNl4EINl72eUSVAt6AQXj", "name": "Spring 2022 - 15 but you cant break KEK",           "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "yLLPiH2piFkwfhu0_zNaAEdqfEb", "name": "Winter 2023 - 21, but",                             "season": "Winter",     "year": "2023", "alteration": "XX-But"}, # The actual name is "Winter_2023_-_21_but..._The_Author_Time_Is_Easy.Map.Gbx"
        {"uid": "5SjgF6WLCXAm0kTV9_tMMKqnGd9", "name": "Summer 2022 - 01 - Downhill",                       "season": "Summer",     "year": "2022", "alteration": "XX-But"},
        {"uid": "fcHKf5LT6MnsGSzAF6RxXWe9256", "name": "Fall 2021 - 01 But Its Tiny",                       "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "trp2xzHsAyKilge58I8tEsY7kXe", "name": "Fall 2021 check",                                   "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "h0kJym6CV6e8Pa9HFzXQodnMMM",  "name": "Fall 2023 - 01 Driving on the scenery",             "season": "Fall",       "year": "2023", "alteration": "XX-But"},
        {"uid": "WWUuhyqLKhWpGN1oCqmi0VV5uCb", "name": "Fall 2021 - 01 But It's More Water",                "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "_6iGaKk3aCQ1m_trarWMSJm8FS4", "name": "Spring 2021 - 01 but its a waterpark",              "season": "Spring",     "year": "2021", "alteration": "XX-But"},
        {"uid": "JJgkeHHlagnUT6wkG1Rly4gb8Gg", "name": "Fall 2021 01 Straight",                             "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "Uapf_ani8FZU3NyDef0UpLfJAIl", "name": "Summer 2021 - 01 But It's a trip down memory lane", "season": "Summer",     "year": "2021", "alteration": "XX-But"},
        {"uid": "DtTDPp2o_a1xMQIailzWAlpHPgm", "name": "Fall 2021 - 02 [PF] Fixed",                         "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "bBkj9f01uRQxA_PGIz7w4Go3cD3", "name": "Fall 2021 - 01 (Way down)",                         "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "eNjUKz0MERM_fipExjBcEo1mYo5", "name": "Fall 2021 - 01 But It's x36",                       "season": "Fall",       "year": "2021", "alteration": "XX-But"},
        {"uid": "lcfv4p6XupngHQgUKVWqb6BZ9Mj", "name": "Winter 2023 - 17 but tm² memory",                   "season": "Winter",     "year": "2023", "alteration": "XX-But"},
        {"uid": "MKToZ9toLzTDBcBWRcU9yqqKj_d", "name": "Spring 2022 - 01 But Under Construction",           "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "CoPq29ahGeSNtPwxq9Gw6Ah_Rxk", "name": "Winter 2022 - 01 But it's Red Boosters",            "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "n8Oc5csvzpXHIPpPwXTBPPjQg62", "name": "Winter 2022 - 01 but WICKED",                       "season": "Winter",     "year": "2022", "alteration": "XX-But"},
        {"uid": "99r_OJwLnP3CW9ojREcjdiMdOri", "name": "Spring 2022 - 03 Flying Finish",                    "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "Pb0ncSiGMlLe0hBLe9hyUb3Irh1", "name": "Training 12 but the jump is harder",                "season": "Training",   "year": "2020", "alteration": "XX-But"},
        {"uid": "6bVv4KhilzFHCFk3PClocolZ73m", "name": "Winter 2024 - 02 Sky Route (ft QuentinTM15)",       "season": "Winter",     "year": "2024", "alteration": "XX-But"},
        {"uid": "xJ5VEftIKJarxzgO_BegtM_33q2", "name": "Winter 2024 - 12 Waterblockless",                   "season": "Winter",     "year": "2024", "alteration": "XX-But"},
        {"uid": "wnOFvy3EvZo1MscWfJN6IPyH4qi", "name": "Snowy Spring 2022 - 01",                            "season": "Spring",     "year": "2022", "alteration": "XX-But"},
        {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
        {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
        {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
        {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
        {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
        {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},

    #},

    # Placeholder Maps
    {"uid": "Vjhu6a1GXWJGJbNJydlZtC2MOtj", "name": "PLACEHOLDER 04", "season": "spring", "year": "2023", "alteration": "1-UP", "obtainable": False},




    # Unlabled maps...
    {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},

    {"uid": "kGuxoCzx2m7qtpbisp808bSG_Ll", "name": "Fall 2021 - 01",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "KcGk8teSDpK1zN08rgRd17D0Kic", "name": "Fall 2021 - 02",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "vYZn1X2_ser5jLs84QtslPPt3R9", "name": "Fall 2021 - 03",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "Fb9CNvbcYzAmHCPVTdzZQl1AbW3", "name": "Fall 2021 - 05",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "lqmnWVBR01cZrMIwuXnQ3s0OTCf", "name": "Fall 2021 - 06",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "1fAJTCPxlMBbyZkU_LwZPCOt7Hf", "name": "Fall 2021 - 07",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "eHC5ISXvgtuXkfqTIuo_7SPEkGa", "name": "Fall 2021 - 08",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "eKJGBx5y69qnhnlCiWx4fzIvzdl", "name": "Fall 2021 - 09",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "CKIw7Esq_twQW4_aqxZokhv3_Ed", "name": "Fall 2021 - 12",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "DPKE59_e_1bo2l0lDfIyfZcQW7h", "name": "Fall 2021 - 13",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "toPQhv5EHBv3bzMYgQ6usZXTYu",  "name": "Fall 2021 - 14",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "4aY76oCReLnzSEzn8Z9eqRQLzEc", "name": "Fall 2021 - 15",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "NsxnC2rYUzbXu6dmyhrVoo74hd8", "name": "Fall 2021 - 16",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "p6FCRONczbDSfKOizt3Z3ImUDk1", "name": "Fall 2021 - 17",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "PGqb39RgSsDek2oZOHytdNZNSJ1", "name": "Fall 2021 - 18",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "MTPMOlln7Q1pslnJ1KkPuGlmfL0", "name": "Fall 2021 - 20",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "R_FDzCd5dU86mkk7bpkY4PzrNFe", "name": "Fall 2021 - 21",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "xZoZx4u5uGqXg0hDUwvZRUV3atb", "name": "Fall 2021 - 22",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "t0DqO4AQTaHZsxpsNRgRgcOn45d", "name": "Fall 2021 - 23",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "BXgsnWOz7UI0mxCaf10T4AvJRUe", "name": "Fall 2021 - 24",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "gd6gvjmr5gIKMCQY25jinh30bzi", "name": "Fall 2021 - 25",     "season": "Fall",      "year": "2021", "alteration": "Backwards"},
    {"uid": "sH1AyugzgU7RnrgE7USb11nLZxb", "name": "Summer 2021 - 01",   "season": "Summer",    "year": "2021", "alteration": "Backwards"},
    
    
    {"uid": "kf3ZUiaYI8kv_L5sbtgdq1meHx2", "name": "Summer 2021 - 02",   "season": "Summer",    "year": "2021", "alteration": "Glider"},  # 
    {"uid": "GfE32ssQZQNYwcvmqOFLvZgV6t",  "name": "Summer 2021 - 03",   "season": "Summer",    "year": "2021", "alteration": "Glider"},  # Check if these are glider or engine off
    {"uid": "ydT2UJI8qoRZDWx3mKM5kmY_G7d", "name": "Summer 2021 - 05",   "season": "Summer",    "year": "2021", "alteration": "Cruise"},
    {"uid": "ZKhHU0i38ePcVzpHnSFDXyYdIa8", "name": "Summer 2021 - 07",   "season": "Summer",    "year": "2021", "alteration": "Cruise"},
    {"uid": "biiKGPRLiKF00yL1qr3OSQh1VKj", "name": "Summer 2021 - 20",   "season": "Summer",    "year": "2021", "alteration": "Cruise"},
    {"uid": "q2AowFttoWs7y8chHg1iCv0ay_1", "name": "Summer 2021 - 21",   "season": "Summer",    "year": "2021", "alteration": "Cruise"},
    {"uid": "Fq5KiEolTkKxQc8htbLTr5cuQ3b", "name": "Summer 2021 - 23",   "season": "Summer",    "year": "2021", "alteration": "Cruise"},
    {"uid": "IL109lMYdQtZ26EuDwKQOv0ubrg", "name": "Summer 2021 - 25",   "season": "Summer",    "year": "2021", "alteration": "Cruise"},
    {"uid": "wnZHUwI9vus_MfKaEiiD3WX9YKf", "name": "Fall 2021 - 03",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "K61LtKMHmqEwX3A6UbozVmBUxMi", "name": "Fall 2021 - 04",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "_kXZ9TjmqpDRwsBSdUKLGOrz8C1", "name": "Fall 2021 - 08",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "WmHYnA_LJcNt8cRI9_MHLGqs9m8", "name": "Fall 2021 - 12",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "GgkMikTT3BVskzWjhQc5_lXocI2", "name": "Fall 2021 - 15",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "EI4T2NWJFuXfAJ7bNcqQZPUJ8Ig", "name": "Fall 2021 - 17",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "1TrJdeUVNchGMD4n1I0ZFTTwAwi", "name": "Fall 2021 - 18",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "eyJeUxjXbAK03Un_VkeeIBrUBE6", "name": "Fall 2021 - 20",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "rdtf7SZ1r0qO1yvI5QqwYuU1Wmj", "name": "Fall 2021 - 22",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "Hl3aela5O8qypKOcesfSslKMS07", "name": "Fall 2021 - 23",     "season": "Fall",      "year": "2021", "alteration": "Reactor"},
    {"uid": "R70h3wSZiNV4hkqnIcv40aze9v6", "name": "Summer 2021 - 06",   "season": "Summer",    "year": "2021", "alteration": "Reactor"},
    {"uid": "t_5RKg79sSCq0pjAESBmlPNHK50", "name": "Summer 2021 - 08",   "season": "Summer",    "year": "2021", "alteration": "Reactor"},
    {"uid": "kL9X7wt0A4cwHAdb65m3eo5tC16", "name": "Summer 2021 - 10",   "season": "Summer",    "year": "2021", "alteration": "Reactor"},
    {"uid": "W1szxxi7_6Z3CXmKcoxcOpzSTUg", "name": "Summer 2021 - 13",   "season": "Summer",    "year": "2021", "alteration": "Reactor"},
    {"uid": "Wyr_1aiaLGTIkq40OkrE6jM_EG6", "name": "S02",                "season": "Spring",    "year": "2020", "alteration": "Reverse"},
    {"uid": "cb6_tj7DrZYggF0E0FFUhD5In43", "name": "S09",                "season": "Spring",    "year": "2020", "alteration": "Reverse"},
    {"uid": "9oETDv0100zczyh6Gpoo1aLQur8", "name": "S11",                "season": "Spring",    "year": "2020", "alteration": "Reverse"},
    {"uid": "FdENeCj78h53OqkJRMUUigPtGrm", "name": "S14",                "season": "Spring",    "year": "2020", "alteration": "Reverse"},
    {"uid": "kSnYW7q3QmwKQ9QNW7vt_xy5MJh", "name": "T04",                "season": "Spring",    "year": "2020", "alteration": "Reverse"},
    {"uid": "XG08sh2k3DDYerpnNSpMMKZ4fyi", "name": "T07",                "season": "Spring",    "year": "2020", "alteration": "Reverse"},
    {"uid": "QuXoCxvNJUuKFAcDMIPT_BKjRBa", "name": "T08",                "season": "Spring",    "year": "2020", "alteration": "Reverse"},
    {"uid": "Ha7xvAhC3TLd46ooa8KOO9kfYG9", "name": "Summer 2021 - 04",   "season": "Summer",    "year": "2021", "alteration": "Freewheel"},
    {"uid": "XA3Y7pShG4zJzrB1Ry4j0JptcX7", "name": "Summer 2021 - 09",   "season": "Summer",    "year": "2021", "alteration": "Reactor Down"},
    {"uid": "8_oqt_DOfNCPfzOMme8385gwBy0", "name": "Summer 2021 - 11",   "season": "Summer",    "year": "2021", "alteration": "Reactor Down"},
    {"uid": "AWNc4GvRr9LhmLdM5JUMiKrLdCh", "name": "Summer 2021 - 14",   "season": "Summer",    "year": "2021", "alteration": "Freewheel"},
    {"uid": "z42mb1Ne9c3mQ3lYOyCSSzmEhnj", "name": "Summer 2021 - 16",   "season": "Summer",    "year": "2021", "alteration": "Reactor Down"},
    {"uid": "gBzdmxJGEByYOmcbbDHIrJES5i4", "name": "Summer 2021 - 19",   "season": "Summer",    "year": "2021", "alteration": "Reactor Down"},
    {"uid": "1sfY5xfuPCt9pRUg5Z9_n70tl0g", "name": "Summer 2021 - 22",   "season": "Summer",    "year": "2021", "alteration": "Reactor Down"},
    {"uid": "L8eko452MXxnjPVvwNEUdyILnyk", "name": "Fall 2021 - 01",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "vz0nkLwmuCjUBbMfNvUFQVqkNO8", "name": "Fall 2021 - 02",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "5f9CrTRN5GuQFvOkKfa3UcHxFOf", "name": "Fall 2021 - 03",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "qqWHgocIwJmkzm9daQ8umCQXqJm", "name": "Fall 2021 - 05",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "UtpSUR99sMAC_d1zQWuPeLeeCfb", "name": "Fall 2021 - 06",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "qkh8_5A_Y2WBiRQVKzjrvV0pjFc", "name": "Fall 2021 - 09",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "1kHWRxSUjIru0zAaQBB1wz_xUOe", "name": "Fall 2021 - 10",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "UtEetwBp3t5PxK2tlc59WXzj8Cf", "name": "Fall 2021 - 11",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "ru99q3ft_HMZMZo8bio5bGI6uTe", "name": "Fall 2021 - 13",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "YjsLl7gR2_dvCebFUCW67Mdb3al", "name": "Fall 2021 - 16",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "n0xktqGhqmAfqCfqV_8hidDjHLk", "name": "Fall 2021 - 24",     "season": "Fall",      "year": "2021", "alteration": "No-Steer"},
    {"uid": "fEgu6l1d5fQIzQfcQssdei4jbKk", "name": "Summer 2021 - 02",   "season": "Summer",    "year": "2021", "alteration": "No-Steer"},
    {"uid": "9JgjIyoEOi1yIjWc1qNoIThgI2g", "name": "Summer 2021 - 06",   "season": "Summer",    "year": "2021", "alteration": "No-Steer"},
    {"uid": "I8e1sLVP9Y8H7sK6C4tCeEtFYjh", "name": "Summer 2021 - 15",   "season": "Summer",    "year": "2021", "alteration": "No-Steer"},
    {"uid": "wdvC29q8lDaIeIBPj2AyOwuFNAl", "name": "Summer 2021 - 17",   "season": "Summer",    "year": "2021", "alteration": "No-Steer"},
    {"uid": "v0dp0xtQaxrxjKexTFuGWRp6Oh8", "name": "Summer 2021 - 18",   "season": "Summer",    "year": "2021", "alteration": "No-Steer"},
    {"uid": "ZQppf58f_mD3ZZQTyJ_1MEs_sti", "name": "Training - 21 & 24", "season": "Training",  "year": "",     "alteration": "Wood"},
    
    {"uid": "RzynDC0FdpMgumqZNP8_tZGSrD4", "name": "Summer 2021 - 02",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "ohl627uspI_HpN6myP_B4adTrQ3", "name": "Summer 2021 - 03",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "u1Gzq1xplh2YTfrgA8Ql37k4x05", "name": "Summer 2021 - 04",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "VqH9d5BgNgr1xbgXWgJFGm0Ao6",  "name": "Summer 2021 - 05",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "fpFUrsnIq19q_pn6X9Q7xPpdDz2", "name": "Summer 2021 - 06",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "cFuOEGWpGOXzzEjOD5udrn6ptoh", "name": "Summer 2021 - 07",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "Qsf95I486Yhg44MwGGWUANpJY9",  "name": "Summer 2021 - 08",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "9oSkU0RxRQNaQahOF_8S5k6jrXk", "name": "Summer 2021 - 09",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "gtXhdo7EKZWeln6fIs4__CTXh3",  "name": "Summer 2021 - 10",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "KvZndCYN3VROJ6i488MF9wHneN8", "name": "Summer 2021 - 11",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "MH4paxWYfbx43ZnapXsACcoIoBk", "name": "Summer 2021 - 12",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "eJB512IoI4COWkvXpGindli9rMf", "name": "Summer 2021 - 13",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "XoLKAMibquG1sO8k9nYp_ARzOcj", "name": "Summer 2021 - 14",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "qB4K4phNrPHZT0fh_UpsCSjd9D4", "name": "Summer 2021 - 15",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "4VAswDATd3QFhG0maH8lavYwSXm", "name": "Summer 2021 - 16",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "0kGKtXh1yKfe00v4WqEyzqvXA1",  "name": "Summer 2021 - 17",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "6rjtjoZZs9P56vUsYJ8rVritrp",  "name": "Summer 2021 - 18",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "XRqdpiaA3bBjI22tP1sExITcyRh", "name": "Summer 2021 - 19",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "UbQBvLsVMyGxRt6G1B1zgEoMYKj", "name": "Summer 2021 - 20",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "0Up7VugfEFCY9syEa0_M4SyawFj", "name": "Summer 2021 - 21",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "6S4IN68jS8QtKLg0O9pd6ub01Q0", "name": "Summer 2021 - 22",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "VPcloJMWR7zWrk8vMHe11AlvhGk", "name": "Summer 2021 - 24",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "WB70M64gjgRoOaFpSur690_buq9", "name": "Summer 2021 - 23",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    {"uid": "YtHBV98BcNGOqszdD0DpPC8B2Ib", "name": "Summer 2021 - 25",   "season": "Summer",    "year": "2021", "alteration": "YEET Down"},
    
    {"uid": "T_Y6pFuH9b9feIbjknbwfpGr_Nf", "name": "Fall 2021 - 10",     "season": "Fall",      "year": "2021", "alteration": "XX-But"},
    {"uid": "oPaAGeGMtb7DrD3HWVHA7e973je", "name": "Training - 13",      "season": "Training",  "year": "",     "alteration": "XX-But"}, # Might not be xx-but; I think I remember someone at some point talking about a cut only campiagn...
    {"uid": "YHrZQ3KCo8YQv1JMdo9OK0nSJc1", "name": "Training - 11",      "season": "Training",  "year": "",     "alteration": "XX-But"},
    
    {"uid": "WBPEcJuFH711c1ULo0qRaTXQKz5", "name": "Training - 07", "season": "Training", "year": "", "alteration": "XX-But"},
    {"uid": "Fs_gH2dNGkjXIz48raNkuO3znGf", "name": "Training - 19", "season": "Training", "year": "", "alteration": "XX-But"},
    {"uid": "LRpvHLSZaJJIYnMZNuRsiXIybGk", "name": "Training - 20", "season": "Training", "year": "", "alteration": "XX-But"},
    {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
    {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
    {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},







    # Maps that are unsortable...
    {"uid": "CkfEfVakPo2LqnTY3Th5Je9ErU0", "name": "Roady Summer 2022 - 02", "season": "Summer", "year": "2022", "alteration": "Road"}, # Actual name: "$s$666R$777oa$777d$888y $FFFSummer 2022 - 02" Filename is also broken...

    # Misspelled maps
    {"uid": "lUCieW880_2TNphWqoaKd19LQLi", "name": "Training Puzzzle - 16", "season": "Training", "year": "", "alteration": "Puzzle"},
    
    
    
    
    
    
    
    
    
    
    # a08 maps
    {"uid": "eikAwfT7vpgUzX0kgeOqwoJIGv3", "name": "Fall 2021 - 01 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "cukWZwilgZiOUiHeQSQLdV28PWi", "name": "Fall 2021 - 02 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "YTIEtoH8aWDKN8uHTGgAIDGlhGm", "name": "Fall 2021 - 03 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "ZDj7xlDzuc15ceuUWN7ltFcqtHk", "name": "Fall 2021 - 04 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "qOlXJR2ygmTA_QRkFHr7r_kMvUl", "name": "Fall 2021 - 05 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "8BoReoYKVnWmleQvgJk3hEUspVm", "name": "Fall 2021 - 06 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "lsWIhqYKxgrukSSeqU1QMSz7_Od", "name": "Fall 2021 - 07 - 08", "season": "Fall", "year": "2022", "alteration": "A08"},
    {"uid": "qvJprmphpt3sB7Wl1gzJMz_CXZ7", "name": "Fall 2021 - 08 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "MRwhsMh12Ta5dkDqgKj0VjxDeri", "name": "Fall 2021 - 09 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "sVdcYuMl28djgS5e1wE_a9QgUg",  "name": "Fall 2021 - 10 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "5ya1fHXLeGLcfhecc2gNjmlichm", "name": "Fall 2021 - 11 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "6fde3j0zJnzphTkyFh5u2bU2ps5", "name": "Fall 2021 - 12 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "diVv9fhQoXigOZHwePFeHLfWHKe", "name": "Fall 2021 - 13 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "VyPA74i1WTMye_jS1kuZWFtw0fi", "name": "Fall 2021 - 14 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "4CmlEmygT4Usg4ddmjfJ1fMhn09", "name": "Fall 2021 - 15 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "uO9ULiqhFvcT57bWgX82RhDVqLj", "name": "Fall 2021 - 16 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "PE9SPRmme9HQHP7Bg6XQmzOczT5", "name": "Fall 2021 - 17 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "ANUMFzFHggIIjedCl3n5ClI3Ff5", "name": "Fall 2021 - 18 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "yG42cnlXzlR8sdGdH7xlj5_i1H7", "name": "Fall 2021 - 19 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "yy2AUofLUaoC2Ixt9Z1qt2UcXSi", "name": "Fall 2021 - 20 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "8VwiX0YuDq5yk7Z30hOmXtyTK09", "name": "Fall 2021 - 21 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "RxKeTtWUf6G90HR2KtCTUvCEre0", "name": "Fall 2021 - 22 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "AiUvtTn7Yf8YS2X_jpn4roP6Kb5", "name": "Fall 2021 - 23 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "gU06zzSIiMGiVDCSrUHKztZ9qKj", "name": "Fall 2021 - 24 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},
    {"uid": "jVF04wEIULCDgMBs0kjDBQBfSL",  "name": "Fall 2021 - 25 - 08", "season": "Fall", "year": "2021", "alteration": "A08"},

    # Official Nadeo maps
    {"uid": "", "name": "", "season": "", "year": "", "alteration": ""},
    #{ 
        # Competitions

        # TMGL Fall 2020
        {"uid": "mYsC_SFD6cMK8vSX5Ev6sqnkqw8", "name": "BumpyJumpy",                  "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "U5J07hNmKEEOFvIzlZZp1RCXsz5", "name": "Circles",                     "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "H1QIG6oJLt7OU46My4pSSfD1Y0i", "name": "Dune",                        "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "m2d9V9SynsmhP9iEz1tv1mcFbn0", "name": "Eurostep",                    "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "LLM0xhyVVa2MciMNf2qVIT11TGc", "name": "FlyBack",                     "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "H45xb09fPznW83xa67sQS5TnHz6", "name": "GlacierHiking",               "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "TXukD6AzZ6dpIuZHqOJEFpiQmq7", "name": "Halfpipe",                    "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "hBwgI_K87mIFe8ARxUjGB1yOgZ9", "name": "Hoverboard",                  "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "JEzh_pvzYwjen_5t7eQNDIHvZ_2", "name": "Paradice",                    "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "3DiNydIBs3wK96LnxbGET5PRdAe", "name": "Semiramis (Feat Firestorrm)", "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "jGd9CAtaBsMGqDkeW0SZRBidqX6", "name": "SideWave",                    "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "qILevE59qeLZ2DH0tgh8dG6KJWk", "name": "SnowStep ft Tona",            "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "3Muz1cW6c_oo2CGonHY3sADcFkk", "name": "StarGlide",                   "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "IOmzzTEN3T1m5F_L_kToGJuhZ6f", "name": "SwitchBridge",                "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},
        {"uid": "1pwSzJrH4CYEGEd2fUJ0b9YuWKj", "name": "TreeJump",                    "season": "Fall", "year": "2020", "alteration": "!AllOfficialCompetitions"},

        # TMGL Winter 2021
        {"uid": "8xZ16KN803bUYpiUQt7kFFxSPD1", "name": "Arctic Split",      "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "uYZnjYekW3Im4X7EmG7RIRWunql", "name": "Bookcase",          "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "4RDqVKTe90s6wpMYov1dhi2ZmB1", "name": "Frozen Fridges",    "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "6ZSmAqah7QPVs35hyrppYu8_32b", "name": "GapJumper",         "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "fiqr3BUDADXDanQtI8lMUWyuUl9", "name": "Leap of Faith",     "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "FPbro4SXJFKz4GL7k5jB4_OR4p5", "name": "Picicle",           "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "CEzFrFOIC9s5LM44KsWkmHTovjk", "name": "SkiJump",           "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "RMgK_3JRajCBDNrzZqHGn5y_gJj", "name": "Slalom",            "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "sNPikVMxMIjO568t8fosP5PcYug", "name": "SlowmoForest",      "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "4eY78dT3Slk841bh2hzalllos1e", "name": "Switcheroo",        "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "tse0JHHcr88uPUAEZ3AIajHTnt0", "name": "ToThePeak",         "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "AYQQ9n9FhR0QfnE4XoO3ayeHHId", "name": "VantaNeo",          "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "i_wnZ5MjQt4W7sWSOmqdI5EV5C1", "name": "WhirlPool",         "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "esTwzCWglmmCgZVy2t8arB2aZUd", "name": "Whoops",            "season": "Winter", "year": "2021", "alteration": "!AllOfficialCompetitions"},

        # TMGL Fall 2021
        {"uid": "6CvzlH_5zZBHvjn6k3WWcTndaPf", "name": "Barrelistic",       "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "KGWHgZwVVCYkktj2sBBMEw6uNCg", "name": "BoltHoles",         "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "VTmAkIVTZl6a97e6TbJK78ZWKX5", "name": "EuroSky II",        "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "uBIzpWqqZLN4PIXHwchmevNY3O6", "name": "Grasshopper",       "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "TRFEKtObhuDn_1NRqfktrvKVvv2", "name": "IcySnake",          "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "bUbKj37BqcxSYA_Zo8mZupMa8j8", "name": "LaunchPad",         "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "E78tnjO1T0sPuwnNc0y9oFKNji1", "name": "OnTheEdge",         "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "7ddD_3LNrttIMHKyRqNcoSEZwEh", "name": "PoleParty",         "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "xbJ_jg2jvpooFRKuorULX6aQjtj", "name": "Poolside",          "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "5gor_0D3D4eyv4K4FjmJ3CPyfWe", "name": "Throttling Act",    "season": "Fall", "year": "2021", "alteration": "!AllOfficialCompetitions"},

        # TMWC 2021
        {"uid": "0vkyGNrvPQ3PJegPlqt6_vwfT6a", "name": "Arctic Split",      "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "PbfEZhpGlX9NfQ16IyhhMiJX31",  "name": "Halfpipe",          "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "CB_LduTX2bKpqi5nAcfNkdbR4N7", "name": "Paradice",          "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "pXcDo8mc2i4RjytuJ56I1a3zYq8", "name": "Reversing",         "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "K6W8yxL2JbPPZtJTMPN3HYGLJd5", "name": "Semiramis",         "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "mluy6I5qASQgt0Xu5xY3m49Esei", "name": "Slalom",            "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "wq0RoFTNIoFlFZ95Ab33tBg0bsd", "name": "TurboStairs",       "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},
        {"uid": "EqLYWxoQbEHJnALrSTQ4mmVm8Mj", "name": "Zazigzag",          "season": "_", "year": "2021", "alteration": "!AllOfficialCompetitions"},

        # TMGL Spring 2022
        {"uid": "4YMl2lfd7poyAyIJc4E8UeqMjO0", "name": "Bowl",              "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "cl7ccO_DQqz0fiYBwYvFWOg6314", "name": "Clock Tower",       "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "eK_xz7d9hv7mRxnTw6tEJTkvHQb", "name": "Grassline",         "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "PLy9b_0RwmZrWOPowsRER7DRBS3", "name": "Heart",             "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "z1W3VYg914_KbvQfMwx4_kg8tmj", "name": "IcyJump",           "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "pBofuyyhwJwIjWa_aoHwcYEVx5j", "name": "TightRope",         "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "Yfxig0UNwNRs4v_BqfqRwieYuvd", "name": "TinyGap",           "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "zwpoQsgpok5m0EQTSZZ5F6wEYNg", "name": "Turnover",          "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "WurdoMaM2GXzefXCE8sZxZWV7i5", "name": "WaterGlider",       "season": "Spring", "year": "2022", "alteration": "!AllOfficialCompetitions"},

        # TMWC 2022
        {"uid": "vLyFqhTbwuEF4S3apZHJ0aqeX2j", "name": "BoltHoles",         "season": "_", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "c58bH4hukDBGLCABsLgekMottZ3", "name": "Heart",             "season": "_", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "bYhKboPS588ne1hQJhYivO2E2oj", "name": "Poolside",          "season": "_", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "U70vE5e7DbeUlL0kb8UyOsrZzD3", "name": "QuickSand",         "season": "_", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "9fQKjqrJotYk5S_V7o_VfpgUYi9", "name": "Slalom",            "season": "_", "year": "2022", "alteration": "!AllOfficialCompetitions"},
        {"uid": "KFEQQRS6AAeK0dAda4Snk6C1JUc", "name": "TinyGap",           "season": "_", "year": "2022", "alteration": "!AllOfficialCompetitions"},

        # TMWT Spring 2023 Stage 1
        {"uid": "079I2edcwtj8JRjEwf6hc1zBx78", "name": "Aeropipes",         "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "cXJvHzJdFZUkKh4wWFCzyAO8wm8", "name": "Agility Dash",      "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "c2RkJ23ONJMrXI_nkMjvkPfTrhg", "name": "Back'N'Forth",      "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "SxiMAPLufob852FoWQbtBPbGYM3", "name": "Flip of Faith",     "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "ufgYrFAYUyv2mfX52Bcm102GbC0", "name": "Freestyle",         "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "3wShwwx7cNnzF50Uu4LD6F7Icv0", "name": "Gyroscope",         "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "nwxMuUKvB5ZmvWX8Sqemnj8Qqk6", "name": "Parkour",           "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "MJSTbd3SHGcPNbS6bgbkDgGPdph", "name": "Reps",              "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "Bc1S750l6ROoX7EVq0ltji6fNC",  "name": "SlippySlides",      "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "X57aVa_wZq3zzYr3UUBfZIu2MMj", "name": "Slowdown",          "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},

        # TMWT [E] Spring 2023 Stage 1
        {"uid": "w6yZQCKiSkqWDLZNErw49qtbeG6", "name": "Aeropipes [E]",     "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "uOS8IXicSoHX_oo3rcpl81pwEAj", "name": "Agility Dash [E]",  "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "lgbphUU9UpJZSoKc8dTD3EjPmtj", "name": "Back'N'Forth [E]",  "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "4VxmHRGL5aQ9Ap_WAZicwKb1ohb", "name": "Flip of Faith [E]", "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "N7TWhYUiecAXf7wx_naPzpkaaUd", "name": "Freestyle [E]",     "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "Wa0FxXSM363CCYEh3uTwjxOTcLi", "name": "Gyroscope [E]",     "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "YI2kowTGtzFHqkPGZFyRG4SUha3", "name": "Parkour [E]",       "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "D6JgQlTA1Zm6ukVmdk_WECLW4Ki", "name": "Reps [E]",          "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "FgFXuAsWiZr7M9RUwWduKplLcf5", "name": "SlippySlides [E]",  "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "ZV2aWMY9SRgGkXR_ol8aiw7n37l", "name": "Slowdown [E]",      "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},

        # TMWT Spring 2023 Stage 2
        {"uid": "NqGzny1hTb4SQCe_tzznU4xmQvm", "name": "Airwalk",           "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "wGPWFgUg9wpJCTg1QRHPC90icm0", "name": "Breaking",          "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "wCrhYurL6H6oX2YYG9EBG5Q2lze", "name": "Control",           "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "Q9tzUk5lC0tXKLduCSftM8uOadc", "name": "Frosty",            "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "ypwxYrQx4am3Bu0y4eENMDHFPt3", "name": "Grip",              "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "u0bt42TkQV9bpF63quo5KI9uJNe", "name": "Offroad",           "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "6ojwfbRpy94C2r4874TualT5We2", "name": "Pool",              "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "p8XTL8gPJRl3c4Ls_8Dy7X5yJp0", "name": "Sinuous",           "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "l7VxtNSAP0FUAPKhD0fuhD2uGO3", "name": "Speed",             "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "5tKUYnlBZU_1TMeO9GemJL1ZeQf", "name": "Vortex",            "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},

        # TMWT [E] Spring 2023 Stage 2
        {"uid": "wDBXx7nnNDm1NVxIbWz4Tvc8mF9", "name": "Breaking E",        "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "m_gGU58UfUwULTidwfkiB_ry3zf", "name": "Control E",         "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "dvD9KDWyz5eTCbHvz0Pr1hjts21", "name": "Frosty E",          "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "1AHvHDL0ms_QSdiw9ygrwRgn7qd", "name": "Grip E",            "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "pZzQLqja8TtqcHDZ2XZO75oPWq3", "name": "Offroad E",         "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "jJijwXARb2qQglID5oLE0NAG60l", "name": "Pool E",            "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "YxeZw8hY62nBAqTC7KUrSlD_3Gi", "name": "Sinuous E",         "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "SxvhvVnlgQHyqmAZsBxQFkarfJj", "name": "Speed E",           "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "r3wmDiuHJS76_8VqCMlS3yX7iSh", "name": "Vortex E",          "season": "Spring", "year": "2023", "alteration": "!AllOfficialCompetitions"},

        
        # TMWC 2023
        {"uid": "p7FiZ1V4Qi2gdKrNCfox0F_GDWb", "name": "Backflip",          "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "g_gZcD6P4v3pHsj2Cm66RMgnj2h", "name": "Cosmos",            "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "tnOwyJZI4ziMlsyzTVtVQ3qnopc", "name": "Dive",              "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "FaNV9CGBOiOgAoFYVs2b7mwMO78", "name": "Edge",              "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "oJnpTxGNYlmy63G3ibMA7TaZ8im", "name": "G-Force",           "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "C7cMMAs6zOFqsovkG7_UhRN8DNd", "name": "Surf",              "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "fhe9XF1YBDhF6FjekJJzFTul2ub", "name": "Tempest",           "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "XrasR_8v_fxPdgY_5GOvZ7V3lsc", "name": "Tubes",             "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "fPPVCqQYXxTTszie3CyPXUbWrIa", "name": "Twisted",           "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        {"uid": "Hho1s07kfdvrCXbaz7vahMGOLs7", "name": "Valley",            "season": "Summer", "year": "2023", "alteration": "!AllOfficialCompetitions"},
        
        
        
        


        # Snow
        {"uid": "k45jQI6Y7XrPfe1T0hZhj4pKzY2", "name": "SnowIsBack",   "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "2tqbr2sszmxpZkVweUY5ybPH20b", "name": "IcyHills",     "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "EpaM6deJ3kkRZxD7WWQPrN286qf", "name": "SnowGlider",   "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "Yttz45gxVMc6onGBAz5g_6AheCm", "name": "WoodForce",    "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "GXGM_CSzlbeNBNQwyWyxaPdDr4j", "name": "WetWood",      "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "FIxt7IbWZMzv7IY0AATOiodmiCg", "name": "BreakOrSlide", "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "pOQOHcjOpsenUrFJeamePYpcP_k", "name": "IcySnow",      "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "x74fKWApIvUvsb5BGnXcb07jjQ2", "name": "WoodySlalom",  "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "GpZh6L4ZPDB7m9Vae8vV37ki7Rl", "name": "Temple",       "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "8lN2wVauP0XdPissI52l5wfvLP6", "name": "SlippySnow",   "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "VIbsBvVrlzF0axbJ2cQpkWQQYBb", "name": "Hairpins",     "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "kacFH41kE5QyUFKzWAkcAB1b4L0", "name": "Rock&Revel",   "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "u5pSmmhKinv4Vh2SUrY5BtvFDK",  "name": "IAmSpeed",     "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "F5iyN8ApuZf9U_Z1PMqLcJrExye", "name": "BobLover",     "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "GXY3_DkrkGSceiut44HOz8LJP52", "name": "SummerSnow",   "season": "[Snow] Discovery", "year": "", "alteration": "!OfficialNadeo"},


        # Desert


        # Rally



        # TM2020 Campaigns
        
        # Training
        {"uid": "olsKnq_qAghcVAnEkoeUnVHFZei", "name": "Training - 01", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "btmbJWADQOS20ginP9DJ0i8sh3f", "name": "Training - 02", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "lNP8O0sqatiHqecUXrhH65rpQ8a", "name": "Training - 03", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "ga3zTKvSo7yJca60Ry_Z003L031", "name": "Training - 04", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "xSOA3Fs8k3bGNHFQhwskyAjN3Nh", "name": "Training - 05", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "LcBa4OZLeElnJksgbBEpQggitsh", "name": "Training - 06", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "vTqUpE1iiXupNABp5Mfx0YOf33j", "name": "Training - 07", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "OeJCW8sHENIcYscK8o5zVHAxADd", "name": "Training - 08", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "us4gaCDQSxmjVMtp5nYfReezTqh", "name": "Training - 09", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "DyNBxhQ6006991FwvVOaBX9Gcv1", "name": "Training - 10", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "PhJGvGjkCaw299rBhVsEhNJKX1",  "name": "Training - 11", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "AJFJd6yABuSMfgJGc8UpWRwUVa0", "name": "Training - 12", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "Nw8BZ8CtZZcFO547WnqdPzp8ydi", "name": "Training - 13", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "eOA1X_xnvKbdDSuyymweOZzSrQ3", "name": "Training - 14", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "0hI2P3y8sENgIkruI_X7s3efES",  "name": "Training - 15", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "RlZ2HVhAwN5nD7I1lLciKhPsbb7", "name": "Training - 16", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "EnMnBg3D4Uvb5bz8VLod73z6n47", "name": "Training - 17", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "TVUF91YlnL78BFJwG5ADkNlymqe", "name": "Training - 18", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "SsCdL6nGC__n8UrYnsX8xaqnjCh", "name": "Training - 19", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "Yakz8xDlVWDfVCfXxW2_paCaHil", "name": "Training - 20", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "f1tlOzXvdELVhwrhPpoJDsg9xs8", "name": "Training - 21", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "OHRxJCE_cKxEGOGmhF9z6Hf0YZb", "name": "Training - 22", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "qQEgNKxDhXtTsxWYRW0V4pvpER7", "name": "Training - 23", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "1rwAkLrbqhN47zCsVvJJFJimlcf", "name": "Training - 24", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},
        {"uid": "TkyKsOEG7gHqVqjjc3A1Qj5rPgi", "name": "Training - 25", "season": "Training", "year": "", "alteration": "!OfficialNadeo"},



        # TM2020 Spring 2020
        {"uid": "vRmotLWfPJjvqlWqUybhkRmOy95", "name": "T01", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "61llSQ5JlZSy7VmdC6kSknD5bfc", "name": "T02", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "7SOK1BmR1z7xyHuKWdW5456CBll", "name": "T03", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "UP_Gg9kq62b1QNERf4SmpBpYSE7", "name": "T04", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "XfLWmX5hriHYH6BfCmd9CZBwUm0", "name": "T05", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "gtcGN2eQv7MZGRRzh0f2EFS1erd", "name": "T06", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "EYrl5uKyBMIb1QYF8foncZog8Ih", "name": "T07", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "dTpbVvkFdBzCJtLmfTk6wcpCUG7", "name": "T08", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "_gqdWt54s9LYGVbZuuLfwZKyndl", "name": "T09", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "G9IhptfgxZ1GCrO4fYirW9sKQw8", "name": "T10", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "poje8Ki8VVZvYsT9CNzAXBOdxx1", "name": "S01", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "Vy5hhla1x34Y86UtsTnGvuq3bAd", "name": "S02", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "3Xh_2OdV20gfgqZ3WHJvhGzuI6a", "name": "S03", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "Y7hDz5EeFcL0yizHn3NTV4oXURm", "name": "S04", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "WMiX2P9UzIhbRQbLc87kWgqfAh1", "name": "S05", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "4B2UrTFqTsH_ugVWqGX1EPq4zWf", "name": "S06", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "yPwO3xovgk8MbHOpHj3ydndGSi8", "name": "S07", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "K7nhXeWHt8qY8xJsBz2RkOjUpg8", "name": "S08", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "qIVkpjFcBnkETRZAd78iDb3Eypb", "name": "S09", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "SmpgE2AjfPDeDIy0oNN1tz4r_yf", "name": "S10", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "OzvoomDwptrHfnmrKLMmJOX6tZ",  "name": "S11", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "O783pJwn7ZTTKRWaSQq70y0iPr4", "name": "S12", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "JfR2nmgEFjNQUcsZ_0gif3U9C4k", "name": "S13", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "FsaAocj28Yon0os_aauglPq2fi1", "name": "S14", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "jfVEZTOxGFyy29NusaGqg59Edjk", "name": "S15", "season": "Spring", "year": "2020", "alteration": "!OfficialNadeo"},


        {"uid": "XJ_JEjWGoAexDWe8qfaOjEcq5l8", "name": "Summer 2020 - 01", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "zFK9sy3nRLa6FGSpuk_gw0cHLv7", "name": "Summer 2020 - 02", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "xfRvyL9ByoJoPhlAvcNzbc4xD88", "name": "Summer 2020 - 03", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "8rWFH6JI2N1UuHeaS9dmMkTojS",  "name": "Summer 2020 - 04", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "eWR2OWAaiqQOISa_0roXlpsnQLl", "name": "Summer 2020 - 05", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "NlKBKke_lk9hwhoEMb6rBQrsWC5", "name": "Summer 2020 - 06", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "OG0yFZ4bA1iiybF7n4gaZkFO6m9", "name": "Summer 2020 - 07", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "iWUvrk1X45PaUmKv6HUDak4W6V2", "name": "Summer 2020 - 08", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "5weePaThiuxiK4mSHOCokBV6bTg", "name": "Summer 2020 - 09", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "oTGP3jwCiubHBM6KtuR_aCtGWZi", "name": "Summer 2020 - 10", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "gMsrsG59cdouiAoahyk7wOaPPC3", "name": "Summer 2020 - 11", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "EY3IfWHWGUtreJzWmAWp00ZT6z2", "name": "Summer 2020 - 12", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "1MPMjPNGKW_U2Aa1RGyfPDnJVhd", "name": "Summer 2020 - 13", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "uQrUHGT16AptHdxkUKL3MWuh0Gm", "name": "Summer 2020 - 14", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "159XBIpjid7Wh4mjIRQ6wazyme4", "name": "Summer 2020 - 15", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "8JfhDBlUSjG2qf9hqssAJupE0rc", "name": "Summer 2020 - 16", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "4dRIXY5T5CMh6LPcL88l0gEpBkl", "name": "Summer 2020 - 17", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "oSqyiU8CN8A4KnYRsqgcIOshYl2", "name": "Summer 2020 - 18", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "VjBmIAFe_vihp4dA6gXyxauMh_1", "name": "Summer 2020 - 19", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "bTxEqrds5pszV3PZTdK57AnYWfd", "name": "Summer 2020 - 20", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "tHdTCbauyKWB_ft2NVRznkCE4rk", "name": "Summer 2020 - 21", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "dAUOBz9H2iKzyo8HURb3Ce3cwT9", "name": "Summer 2020 - 22", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "FcNO1D7hn9nLuCrjqSA5_7slkR1", "name": "Summer 2020 - 23", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "0fJFNOS8ZzfDA6fJQrr5JU0JIom", "name": "Summer 2020 - 24", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "2katsDjZmPOeQYE94jkbnSoJA64", "name": "Summer 2020 - 25", "season": "Summer", "year": "2020", "alteration": "!OfficialNadeo"}, 

        {"uid": "T5815lg7ladHiNv1hsg0TwIpzIj", "name": "Fall 2020 - 01", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "7oYakB2GeK4TAfxf2Evx7sAyXeb", "name": "Fall 2020 - 02", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "6khX4VKuPxznYS9OU5ef8acGVz6", "name": "Fall 2020 - 03", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "PZubbxQwzSzZXPh3LMmwYi03mw0", "name": "Fall 2020 - 04", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "GC9lEFKF5Y9zMYlhO6dCpYs_tu3", "name": "Fall 2020 - 05", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "7wTClmn1Anj7Qim56c7UzCEvKIa", "name": "Fall 2020 - 06", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "jXA23jIM9TFn32kUJAvFab7iUti", "name": "Fall 2020 - 07", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "kpDBCDPHDIUXqq4_0wbSCjS9iqg", "name": "Fall 2020 - 08", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "I83DYk0WT51XLI2tMLpII5bxxj3", "name": "Fall 2020 - 09", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "2G0LgthomS9amsYHGSpbCE7V6Ak", "name": "Fall 2020 - 10", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "gKMuDXvv7MM_RNS2rvjhL711Ae3", "name": "Fall 2020 - 11", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "Hwuy_g6eKH4PddM8OvXF_kcNuc5", "name": "Fall 2020 - 12", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "nTAGkZf125hoNVujhWH6wc5rO80", "name": "Fall 2020 - 13", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "9IfUn6HE4ZFNjMWMLFlZq48Igqm", "name": "Fall 2020 - 14", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "me1MEYJHdlORMTTj2_yzNcmL5o5", "name": "Fall 2020 - 15", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "Pc6LHnHQfyrDd4hNCQQR6rTTlAm", "name": "Fall 2020 - 16", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "Ch_JYqg6tu2UDXUkcCko33Ys9Ac", "name": "Fall 2020 - 17", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "q4L2EGqoLWJlNLmxXMppe0EN2Dj", "name": "Fall 2020 - 18", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "XK0uTDKrrPNKTwWT7T4_gkRF7Sa", "name": "Fall 2020 - 19", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "KgbioVodMzbDJ12vxsiwzbBJl6g", "name": "Fall 2020 - 20", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "3SBSRxbUI6IMLHUBexzkMpXQHf9", "name": "Fall 2020 - 21", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "Xe1KGpKB83zdhBuKcJny4GYP1Oc", "name": "Fall 2020 - 22", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "u10Vf4sjmD8sTD2NJGWyES6BHvc", "name": "Fall 2020 - 23", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "ek4ENkRCk4pLFTc85XYQoq0jMG6", "name": "Fall 2020 - 24", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},
        {"uid": "1bSx8u78KZMKWYX_rHw6xRE9_Oc", "name": "Fall 2020 - 25", "season": "Fall", "year": "2020", "alteration": "!OfficialNadeo"},

        {"uid": "b9OPxDgnPnrTY1qUS73wX9aYVb8", "name": "Winter 2021 - 01", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "agXkylYyF2HL8GduTE6IdF0Ow6c", "name": "Winter 2021 - 02", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "uFFYXjB4srZnuKEENR6uxtd5Lde", "name": "Winter 2021 - 03", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "eAQbbL3Z2mekZMGaQhscjgWq0cj", "name": "Winter 2021 - 04", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "_zAvF9iktp9RKmDth7_OD8LriC5", "name": "Winter 2021 - 05", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "lfS8luUCaJs15O_ZmSZF_gkZUfb", "name": "Winter 2021 - 06", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "jC9YYcCbHpEuyIHDsCjIXuxWHdh", "name": "Winter 2021 - 07", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "BQT3M6YRqfaoW14Rs2q9qm_aAJd", "name": "Winter 2021 - 08", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "SUiGVC8zVC6jEKpk9U0XcidANH", "name": "Winter 2021 - 09", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "SqWGB1A792byk0qacCoTSYjwM1f", "name": "Winter 2021 - 10", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "LPzbiZ1cS6WtdzpbXqe3aquldYh", "name": "Winter 2021 - 11", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "NuDWGXtTQOkbRNI5cQZLJDsyazm", "name": "Winter 2021 - 12", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "k8ShMKAJciguME13hkzi5oNEDWi", "name": "Winter 2021 - 13", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "_56ShK3GhrFWZX6HABS9HQgnTAb", "name": "Winter 2021 - 14", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "fwoXPdq_QkzW4P9KiLDWJHYFzhc", "name": "Winter 2021 - 15", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "wXypu0soxQBVjcXeh9q5J_q_Ca7", "name": "Winter 2021 - 16", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "A3j_Wcr2EZV5pSFLzaO3JZQ0Z75", "name": "Winter 2021 - 17", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "um1osfP27kgqJHm_4pNVnnDYt1", "name": "Winter 2021 - 18", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "i9UPEGUH3FtqGmAdb7x3GLUAB1b", "name": "Winter 2021 - 19", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "I4HYJmM8Pit2Lg7x6JuCYE_jqLa", "name": "Winter 2021 - 20", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "ciMOK0OEvvYY_y4WVjqhnK3V2N3", "name": "Winter 2021 - 21", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "QDnINBOtfaUJ9ArTWITXlFJclS3", "name": "Winter 2021 - 22", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "We3dEN_W6PYuEnYY90G8ZBBjXLh", "name": "Winter 2021 - 23", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "tKYb1n8tV7OFnRIQzhQ2BEy9ME8", "name": "Winter 2021 - 24", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "egsJYROXRQwA4ZulXVL8GopX2aa", "name": "Winter 2021 - 25", "season": "Winter", "year": "2021", "alteration": "!OfficialNadeo"},


        {"uid": "h_1dfEJJ8m7eY0jB6Ka7XWof6w",  "name": "Spring 2021 - 01", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "uIuJd7r4scjvPB1MqKpPfyqFtKk", "name": "Spring 2021 - 02", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "2i0s54j_t5uv9RxFMwGWzoqsbY1", "name": "Spring 2021 - 03", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "re3M9OYBj4nCKpBCBuX6kVIHBzl", "name": "Spring 2021 - 04", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "jdxv8RrP789jqTrzguUHknEEC4j", "name": "Spring 2021 - 05", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "BRpQ4QsJr4JNAC6fEX15b5cpvp5", "name": "Spring 2021 - 06", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "GKdGvvze1WPDshVKAoCx9oPQck3", "name": "Spring 2021 - 07", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "e2bEfsfA7BSGxef_HbeaRFAVBZh", "name": "Spring 2021 - 08", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "jpE4mVIYyRDGXCMTszLhhdx6Fk0", "name": "Spring 2021 - 09", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "Drd7yJbj3PX7RlzOiYrvuDLC6lf", "name": "Spring 2021 - 10", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "X6vNH_tVjfgW4yNxG7ljjhUu5Vl", "name": "Spring 2021 - 11", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "rLTwvyWo32lwj81Dy1ibtzxoDRi", "name": "Spring 2021 - 12", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "u6T94a8ItpJy3OBn7cPD6FnLGu0", "name": "Spring 2021 - 13", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "ISxNpaHdl2pqyWtpGsckA05p68g", "name": "Spring 2021 - 14", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "OWZNYJ0kbNIvh9sFS38peGXK4E6", "name": "Spring 2021 - 15", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "LJL2noGvti1rPQglmrFH9HTj5Tj", "name": "Spring 2021 - 16", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "rdi5nurDalsxa9NNy3g2pCi9hE0", "name": "Spring 2021 - 17", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "vJ3M99ZioXr13JYaXVQuognn3y",  "name": "Spring 2021 - 18", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "_fYDJhx94QQ6JIxal0Tr6ixadDm", "name": "Spring 2021 - 19", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "jxUHfN1gqzjYIY9tGHlSp6EkMZ0", "name": "Spring 2021 - 20", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "5iux75Sv4outo8wZKB5r54SXn6k", "name": "Spring 2021 - 21", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "9W3JAhcJJu1xHU_cBbZg_jlyPNf", "name": "Spring 2021 - 22", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "VZFapde7rn23xlkMKDPdRxpPtp3", "name": "Spring 2021 - 23", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "sjQghi87UuEaU4ZBdoAxnODDXn6", "name": "Spring 2021 - 24", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "YJd0BGACMwlPUF7cWw25ZO4IKCi", "name": "Spring 2021 - 25", "season": "Spring", "year": "2021", "alteration": "!OfficialNadeo"},

        {"uid": "7fsfRSUCQ7YwfBEdRk_GivW6qzj", "name": "Summer 2021 - 01", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "KOylxZkny8RdOEFhchN1kG6Uoo1", "name": "Summer 2021 - 02", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "n8KeykdPYEsJM6RPEZcQHVRVRIb", "name": "Summer 2021 - 03", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "Y_HCdBUZJ4vw96dPq1rDFRrKHSk", "name": "Summer 2021 - 04", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "C_dty5lFSnVAz9wr4vgBvm8POHh", "name": "Summer 2021 - 05", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "gkpecE76zBRsih1hnStRmM0vR8f", "name": "Summer 2021 - 06", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "oVZNLcpxrXwCvJjR1Tgj3osVe3l", "name": "Summer 2021 - 07", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "S7u6uKnqqksBq8L9n5TldgtsX_5", "name": "Summer 2021 - 08", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "RfGQDoOnJ0FiswOBjpL3V7nkF0a", "name": "Summer 2021 - 09", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "tE676cqIw3LauV_Djvj5emlOS1i", "name": "Summer 2021 - 10", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "_FkM_QeMDkiuPpUijFXA5qoHdQi", "name": "Summer 2021 - 11", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "egqNxYpC7cohsH6NaQn2U1CpxPb", "name": "Summer 2021 - 12", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "0oumVlUqFYQ1E2hTWN9RFQzKcW0", "name": "Summer 2021 - 13", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "23YNxaqzWZUF29nGAJNjVxUAiw1", "name": "Summer 2021 - 14", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "Jfj1tBwQiG0BOmPYXb_Pt_0VeX8", "name": "Summer 2021 - 15", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "i9b7ek86_QZ0rp2RIWdSYxLSzBh", "name": "Summer 2021 - 16", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "9cRYe4_hi1vxVX2qrm5FVeo_V3j", "name": "Summer 2021 - 17", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "MS2QaoA7COLXxaf_7a14XXvHIq4", "name": "Summer 2021 - 18", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "3RLZTpGHlnPcNp7IEKURrtHIE31", "name": "Summer 2021 - 19", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "2ophIF0vwNu53QbQ_tUTiOuFGZ2", "name": "Summer 2021 - 20", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "B9bNWCov2ZG7EWNBxYc7kJQQrXg", "name": "Summer 2021 - 21", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "J159Rat1nAfwmm7H1pOc7Xp_xkd", "name": "Summer 2021 - 22", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "AEGsjIptx0xP0zfUjXoSFvutMpj", "name": "Summer 2021 - 23", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "V6jgITolMc5EN8i8eHGTU65peij", "name": "Summer 2021 - 24", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "Iwo4gO_0dQ3FVQ1xeYjho5ZmLrf", "name": "Summer 2021 - 25", "season": "Summer", "year": "2021", "alteration": "!OfficialNadeo"},

        {"uid": "Nhg8q0K47asKBYRVBCNC8OguB8",  "name": "Fall 2021 - 01", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "ePCBpRNwsdgu_A_HXGaP2ZJXCf6", "name": "Fall 2021 - 02", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "NvoMYOoUCYzHbPjTuUCdrGf3BDm", "name": "Fall 2021 - 03", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "XTbQevLMsSs1R_p9nQ_f7XlJIVi", "name": "Fall 2021 - 04", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "IPZK_gOfY3aR35jTDn9y2Ra5mri", "name": "Fall 2021 - 05", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "ityqTJHdtKJSaAipNRKDPRtbZQi", "name": "Fall 2021 - 06", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "zTT8MH4t2QhC3GEWe2bETl3ICH7", "name": "Fall 2021 - 07 ", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "BqpMPMnsTJtm8AFoVbw2VdQcGlm", "name": "Fall 2021 - 08", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "6k3cbM7TSjFMFvCPFMv7Czh32Ym", "name": "Fall 2021 - 09", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "BYodWRUlgmk70FGNcutC4Djv776", "name": "Fall 2021 - 10", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "C3yMfoT20SW2E0kxOTxWQIdwfH8", "name": "Fall 2021 - 11", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "NvXPWelYfpzF6YwfpMo_YZ2o6Pk", "name": "Fall 2021 - 12", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "aTJvjn3JXqzAr1XhwkChxaJqchd", "name": "Fall 2021 - 13", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "TEqfTFDKNvr5i8zSB1E2VrdaIK1", "name": "Fall 2021 - 14", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "98gvVpMP_fa0OU01lxl6V8Z7BPl", "name": "Fall 2021 - 15", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "XN6pcEo5VgcTS0t1ihroTvzumr6", "name": "Fall 2021 - 16", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "vaytOcnyvsE8oAvg75yF52oKww3", "name": "Fall 2021 - 17", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "aMWHzGkmB22R8tQ4yOzWs0Ybfsj", "name": "Fall 2021 - 18 ", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "ZigdCuCHXcGYCiJBhbt2ex7D2Kb", "name": "Fall 2021 - 19", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "t1wihC8__RmoSvVxJQQPk4dxuJb", "name": "Fall 2021 - 20", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "0SDjT5GYec55qaDImUp72R5cSac", "name": "Fall 2021 - 21", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "Wm4cLJ7BNk_mjZKHxWo2I1LKWRh", "name": "Fall 2021 - 22", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "uvGBpGFqnkUPXlGoy4I2Pj6QEwg", "name": "Fall 2021 - 23", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "SW6RwSsCs83BQNYJ2dcbBDgvL96", "name": "Fall 2021 - 24", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},
        {"uid": "bFW2sYWDICvrzaEK48jj_OA4hc1", "name": "Fall 2021 - 25", "season": "Fall", "year": "2021", "alteration": "!OfficialNadeo"},

        {"uid": "JlxlB7KbrCfhjAf5ld89ByXR987", "name": "Winter 2022 - 01", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "bFgLN1EKYVLg0Ll4ZT6jKLFGYo2", "name": "Winter 2022 - 02", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "eIxTMTzDnPxYvbkzVjrKVLJZbd2", "name": "Winter 2022 - 03", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "5TiCq55OkXkxXgEqP9HBBlX60_n", "name": "Winter 2022 - 04", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "aB67AQFN5n4kh140rxm95un652f", "name": "Winter 2022 - 05", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "9q2gYafm_XJVuUSaW7cllFflyx4", "name": "Winter 2022 - 06", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "V9VX8WQg_8IBlI5Hdu1ManH2Gs2", "name": "Winter 2022 - 07", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "8b9hF25TQea8M0uTpfiL0CiooTm", "name": "Winter 2022 - 08", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "AZlRsHNQYguKykyrAOKfgTzRyPm", "name": "Winter 2022 - 09", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Q3q_RPNuD3ulll872Fr5dsXD768", "name": "Winter 2022 - 10", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "kfmo19rqYZWXuWZ0IGMMUWsZZva", "name": "Winter 2022 - 11", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Pc3mLVzPE7Hqxee2SUG1rJFldc3", "name": "Winter 2022 - 12", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "dFFTkQQCarRlsUI_bWTeA2MugI0", "name": "Winter 2022 - 13", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "qxpsG9rRrCdGD8qgSdmVfQLi6Fj", "name": "Winter 2022 - 14", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Ym6425g4lKwhAqeS5zVr52A_tL3", "name": "Winter 2022 - 15", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "F6cN96fNQVx7vmCZsXiKM3aPSVf", "name": "Winter 2022 - 16", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "euTScdwetvdYiLJWjW2BCqprz7",  "name": "Winter 2022 - 17", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "7Y4AtPIKOVPMDUgrCm7o8LeLtS5", "name": "Winter 2022 - 18", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "v0cdefbP5p1tPD8S4Ztpjkoqgk1", "name": "Winter 2022 - 19", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "0EOGXaeBJqQo5R4VII_32Vi6vEc", "name": "Winter 2022 - 20", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "3JGMi1IsKX7Ej4rNxAUlsVwUTHm", "name": "Winter 2022 - 21", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Re4GzjSrOWdgIxtO_XMDdcUkFT9", "name": "Winter 2022 - 22", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "IvgxMjeHqbacLtBXSNeVfcuD783", "name": "Winter 2022 - 23", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "QH_k2sXb0q0f0vHL56R5ni7OrWg", "name": "Winter 2022 - 24", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "BeAHt5KaxZ9A3zvDqEwvMc_Jivl", "name": "Winter 2022 - 25", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},

        {"uid": "JlxlB7KbrCfhjAf5ld89ByXR987", "name": "Winter 2022 - 01", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "bFgLN1EKYVLg0Ll4ZT6jKLFGYo2", "name": "Winter 2022 - 02", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "eIxTMTzDnPxYvbkzVjrKVLJZbd2", "name": "Winter 2022 - 03", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "5TiCq55OkXkxXgEqP9HBBlX60_n", "name": "Winter 2022 - 04", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "aB67AQFN5n4kh140rxm95un652f", "name": "Winter 2022 - 05", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "9q2gYafm_XJVuUSaW7cllFflyx4", "name": "Winter 2022 - 06", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "V9VX8WQg_8IBlI5Hdu1ManH2Gs2", "name": "Winter 2022 - 07", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "8b9hF25TQea8M0uTpfiL0CiooTm", "name": "Winter 2022 - 08", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "AZlRsHNQYguKykyrAOKfgTzRyPm", "name": "Winter 2022 - 09", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Q3q_RPNuD3ulll872Fr5dsXD768", "name": "Winter 2022 - 10", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "kfmo19rqYZWXuWZ0IGMMUWsZZva", "name": "Winter 2022 - 11", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Pc3mLVzPE7Hqxee2SUG1rJFldc3", "name": "Winter 2022 - 12", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "dFFTkQQCarRlsUI_bWTeA2MugI0", "name": "Winter 2022 - 13", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "qxpsG9rRrCdGD8qgSdmVfQLi6Fj", "name": "Winter 2022 - 14", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Ym6425g4lKwhAqeS5zVr52A_tL3", "name": "Winter 2022 - 15", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "F6cN96fNQVx7vmCZsXiKM3aPSVf", "name": "Winter 2022 - 16", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "euTScdwetvdYiLJWjW2BCqprz7",  "name": "Winter 2022 - 17", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "7Y4AtPIKOVPMDUgrCm7o8LeLtS5", "name": "Winter 2022 - 18", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "v0cdefbP5p1tPD8S4Ztpjkoqgk1", "name": "Winter 2022 - 19", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "0EOGXaeBJqQo5R4VII_32Vi6vEc", "name": "Winter 2022 - 20", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "3JGMi1IsKX7Ej4rNxAUlsVwUTHm", "name": "Winter 2022 - 21", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Re4GzjSrOWdgIxtO_XMDdcUkFT9", "name": "Winter 2022 - 22", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "IvgxMjeHqbacLtBXSNeVfcuD783", "name": "Winter 2022 - 23", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "QH_k2sXb0q0f0vHL56R5ni7OrWg", "name": "Winter 2022 - 24", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "BeAHt5KaxZ9A3zvDqEwvMc_Jivl", "name": "Winter 2022 - 25", "season": "Winter", "year": "2022", "alteration": "!OfficialNadeo"},

        {"uid": "0liUTlKkh9dQ6ahhNXMvfeit5ia", "name": "Spring 2022 - 01", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "hQG6HJBR06Qb5ubCKKZ8E3fYvKe", "name": "Spring 2022 - 02", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "EkM6k5Gwc0seTqIhdCgv38wBkX0", "name": "Spring 2022 - 03", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "FOrI5Pop7uSxbvBUfvclUl3fNl7", "name": "Spring 2022 - 04", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "ht1cLdwwiRYethdtyMFcfaDBQ_g", "name": "Spring 2022 - 05", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "hMvW5zTDT8fTHh505JJqWvr0c8g", "name": "Spring 2022 - 06", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "QBN0QHqNAjxM5q1M7NOAKFlacv5", "name": "Spring 2022 - 07", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "Hz1D89pylgGSRRn9WDPDLUhfbkf", "name": "Spring 2022 - 08", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "l3aG1_qfJyaRHm4Oq2Io5uBtVqd", "name": "Spring 2022 - 09", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "EW2xXu4w25D1U4SkPcI_7nIQtcg", "name": "Spring 2022 - 10", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "GYegSkfy9xRsYCY56VIbBVbN9lc", "name": "Spring 2022 - 11", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "qTyT1tKnRKZvRDIve_ItnR54aZ3", "name": "Spring 2022 - 12", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "i420xKlU8N4BGb5Tt73b2_UsChl", "name": "Spring 2022 - 13", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "307RP8n4pQ7irKCQd20zGUvhl43", "name": "Spring 2022 - 14", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "PSskaX9qB357Gr7mN142twb8DUh", "name": "Spring 2022 - 15", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "MDqEBeQJd_WFim1g20hgWWkpOtc", "name": "Spring 2022 - 16", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "BTxZ3AonzBzEdi4irHSUrMzvQC8", "name": "Spring 2022 - 17", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "WhWHftoBbgpOm4ow0eXop5J0px3", "name": "Spring 2022 - 18", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "xYFca4PepWUno4i_6Xm12PLLLtb", "name": "Spring 2022 - 19", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "0XJGbRQL8A1PV51N9D4Uc6Dblh0", "name": "Spring 2022 - 20", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "e_gcjMXr65YATwNDFDQpN1Cbaa8", "name": "Spring 2022 - 21", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "SzUjxj_EIB8Q8VB_NwIqIEv1bri", "name": "Spring 2022 - 22", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "8hoZUgARlIgQ8KinsUgrKLLfBS9", "name": "Spring 2022 - 23", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "nPNAxzaFzu5HURpQa3LugeWC9mm", "name": "Spring 2022 - 24", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "VJXhTZMf22XxV8C0VXLbEmvCyy5", "name": "Spring 2022 - 25", "season": "Spring", "year": "2022", "alteration": "!OfficialNadeo"},

        {"uid": "gX4t_vf327VNALEK8yYDh66t60j", "name": "Summer 2022 - 01", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "WDOdgubY3FTn3pKE8enDMhaEs_3", "name": "Summer 2022 - 02", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "ft7q4iMciSU1dsG9Qxybq5WiDN7", "name": "Summer 2022 - 03", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "KzN_RlTa0vbd08AQddYcckDAIBk", "name": "Summer 2022 - 04", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "d170P65FoghDtmL_sUM8JS9Sryl", "name": "Summer 2022 - 05", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "GedTru7J38vNCLwadgHhNRzr1Bc", "name": "Summer 2022 - 06", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "kihmdmnhRalWcLoQwQzcVS68uvm", "name": "Summer 2022 - 07", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "QOvVmyHpEZAK2qrmhCFopu4da86", "name": "Summer 2022 - 08", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "ScaYbRsZTY7_Vn274jEMG9hUtL2", "name": "Summer 2022 - 09", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "hn_Dipe_CVlRpkfCDu3zUCDegw5", "name": "Summer 2022 - 10", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "ZZr3gzd1fVHpo35mt7RCtOoKkpd", "name": "Summer 2022 - 11", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "imrmTnCZ3mTJ3gA2D7GvSHiISHi", "name": "Summer 2022 - 12", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "MsxpFY0kryQloTIBPgtza0lYY5d", "name": "Summer 2022 - 13", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "WsVRYCA966Rbmb8JEOfEuVLEHK7", "name": "Summer 2022 - 14", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "1CzT78SFHhXZAfEq0UvFJHxVUj1", "name": "Summer 2022 - 15", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "ypQfnMEY70_0wqiMtPh5WQNOfg8", "name": "Summer 2022 - 16", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "zF9HPqkIzwi0aoklK3J1aDbiI5d", "name": "Summer 2022 - 17", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "YabBQ9oDUsTfs8NwvzVjUECVcR4", "name": "Summer 2022 - 18", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "w2vlZSIFZQrE9J8Ek3Ea1o21l84", "name": "Summer 2022 - 19", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "tatszcUviYmpTkWCw1OagDufHv6", "name": "Summer 2022 - 20", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "ntP_WEJ4NlFT8sjAYa2SSPfaWgb", "name": "Summer 2022 - 21", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "SryBDJG0FkSTY7xtZTPDUZONvrm", "name": "Summer 2022 - 22", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "E0gC8VuoZO8PvSI5JFNS4j7sLf5", "name": "Summer 2022 - 23", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "hP5467N8yleAfDrv6xJUifSVe9h", "name": "Summer 2022 - 24", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "FYDO3MDjNlus8T4D4k0Y8q4RQJf", "name": "Summer 2022 - 25", "season": "Summer", "year": "2022", "alteration": "!OfficialNadeo"},

        {"uid": "JpueTN_zMeVMOYWLUVV65yKAK1b", "name": "Fall 2022 - 01", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "9BLn5ETKGY6Uk7rdZumYFNnBRY6", "name": "Fall 2022 - 02", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "uxdN2iiUwIq2gbrgDLNSmbM9HC7", "name": "Fall 2022 - 03", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "PTUud4zLzT_ETqd_t5FEPMOTPnh", "name": "Fall 2022 - 04", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "2CScBRt4P5EwbcZPDplzIubCuIb", "name": "Fall 2022 - 05", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "xkclDOdeyrvFfR6xV9QetRpqdN4", "name": "Fall 2022 - 06", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "DyEztA4nzAugSMGxPBCHY9xNFF6", "name": "Fall 2022 - 07", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "8ccxafF_HhNsOvZPUs_ChPqWSHf", "name": "Fall 2022 - 08", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "u9rggrjoe4UW5xfZnl15bJU6Nya", "name": "Fall 2022 - 09", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "KLF9PEYypfZgGix_d0qhn8Vqhe6", "name": "Fall 2022 - 10", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "7AHkjCQLAAiqPBY4J1rb6vwUBPm", "name": "Fall 2022 - 11", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "VfaXmRR2WyX09ujc6YBrToRYJf6", "name": "Fall 2022 - 12", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "YspLMMNWY9r7umCnl_xNGpxpjib", "name": "Fall 2022 - 13", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "aSQrjd4HI8laHXSqgxCZx297C75", "name": "Fall 2022 - 14", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "LfUHUsHzwuAg5uBZRm7qFVxqLE7", "name": "Fall 2022 - 15", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "0oPgA4kTlsS7MB4eeil_LftoArm", "name": "Fall 2022 - 16", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "FNhdhneGrpAZs3NjU09SzKBPNB2", "name": "Fall 2022 - 17", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "3ansOME_A0xbfWOIjPXnk7IJiii", "name": "Fall 2022 - 18", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "8IPUjyPt9lFQfw61fO56UsKMFM0", "name": "Fall 2022 - 19", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "D9cJqvhRS45B1Vb4dZknf0vWtIa", "name": "Fall 2022 - 20", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "hZ_5vY1MpOdSaZ7lh0_gsz_X6Df", "name": "Fall 2022 - 21", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "7F3oexS1hhOkfs2bw8zCV3jSanc", "name": "Fall 2022 - 22", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "rhrfyPSYZ8EdCFx1OYycItPBE4",  "name": "Fall 2022 - 23", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "K4CeoyqzS1UXhd7GaiG0_dGrnLd", "name": "Fall 2022 - 24", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},
        {"uid": "FHeSpeBN3ktvyUQF2rDNPAU30Zk", "name": "Fall 2022 - 25", "season": "Fall", "year": "2022", "alteration": "!OfficialNadeo"},

        {"uid": "gjt2DWATrQ_NdrbrXG0G9oDpTfh", "name": "Winter 2023 - 01", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "XiGZvMOqIgT3_g0TdeFa0lxMp46", "name": "Winter 2023 - 02", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "gl1Gsl84T8nP7yRElzAzIj4TD8i", "name": "Winter 2023 - 03", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "SCwnQ2o2UbzCtQcvUUItc07IxD1", "name": "Winter 2023 - 04", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "fsPVO8In4tFAZcVND85MNFkdbbg", "name": "Winter 2023 - 05", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "co1nct7NzYypIVcAsFPCU7UanCb", "name": "Winter 2023 - 06", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "f3kmtq_M3Oi5XTIehocHkQDbTob", "name": "Winter 2023 - 07", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "FKTmB4XshJTjQhLC8gV3aPg48ke", "name": "Winter 2023 - 08", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Y_jBYYaLVsd2F7L9jYZLU0ISahc", "name": "Winter 2023 - 09", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "6qZTR5lT250qp6gQhWfGCPl08am", "name": "Winter 2023 - 10", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Q9bjuiAoBZYZBaktNtrQk2ibAda", "name": "Winter 2023 - 11", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "WeaJCyVl5kKZfmjXHZxItcEhNV0", "name": "Winter 2023 - 12", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "PVo1JtzLWFxztPtCodD4nzlkpKa", "name": "Winter 2023 - 13", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "WNc0aFG2P7TswituP3VEw41xtI0", "name": "Winter 2023 - 14", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "wJ9vGLCLpBOjpy2KompdetPMjEa", "name": "Winter 2023 - 15", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Au9Ucq7OHKrcgLE2UBVP5wpqQ7l", "name": "Winter 2023 - 16", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "6xEcwWkjpitcDpQ2jIbEXTya7hk", "name": "Winter 2023 - 17", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "P508nXcOqZo4Br9zt_UaudERswh", "name": "Winter 2023 - 18", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Rg9njLSXYX3hSPQEcPZ_ewrtv53", "name": "Winter 2023 - 19", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "lZyb1kAHAQXVttxp1iXUeSy00e3", "name": "Winter 2023 - 20", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "90a5UIZtJzok_YoT5u8mEQEln0d", "name": "Winter 2023 - 21", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "MfbFeDXBhCq6I5KUHgvG4B6b8Z7", "name": "Winter 2023 - 22", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "4f8s1XbBQ1u6vLi5oRWTuYsjCW8", "name": "Winter 2023 - 23", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Mi7zQZ0frhDs_Be8fQHdDqfi5Sb", "name": "Winter 2023 - 24", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "SyloDHKt9fmlK9caNmvb5XwkRWe", "name": "Winter 2023 - 25", "season": "Winter", "year": "2023", "alteration": "!OfficialNadeo"},

        {"uid": "bqADnHDhKOfimntdyJnyu_ltVhj", "name": "Spring 2023 - 01", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "U5oFzEOH6MSoJjHsFR8SJT_ar5g", "name": "Spring 2023 - 02", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "OxMofWWFasaUOCCwuYQlGIs98p3", "name": "Spring 2023 - 03", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "GYC5gFrd3TvWuyHRWe37ManmC76", "name": "Spring 2023 - 04", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "NAL3JyqwTLUlpGyksQUgd671E2j", "name": "Spring 2023 - 05", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "w0hxisP5CyjA26b9baGhdXEEqA7", "name": "Spring 2023 - 06", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "JKhwQt798cPc80TO1u0PQvY1kMk", "name": "Spring 2023 - 07", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "XgYfqSWDNz2vAnqHIzvnMvVNK8d", "name": "Spring 2023 - 08", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "7y_qm8eEqKxvrl8C_C8I0AXw3Qb", "name": "Spring 2023 - 09", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "8cKlKPVNYGr2N0N1vUhkvSgCb32", "name": "Spring 2023 - 10", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "yUxNoeHM07t6G5DMpTHkBJ_Ywe9", "name": "Spring 2023 - 11", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "5Iwvxuovgr30S19XIT8piEOj6_a", "name": "Spring 2023 - 12", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "OObD6AlU_Z0UCIUCZy6uZhNM9Ud", "name": "Spring 2023 - 13", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "KPchfL0cxDuCv3jbFgnmj9VHK66", "name": "Spring 2023 - 14", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "anR5Gj5OpLsXZOVzyUfdah1R3wk", "name": "Spring 2023 - 15", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "QOf4v2_DH6nhkcIKet3Qu4QxeBm", "name": "Spring 2023 - 16", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "F5p9I_LxeopCAnvROekLUBXm451", "name": "Spring 2023 - 17", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "wiPActb9f0eQ4ica6rL4bLFduek", "name": "Spring 2023 - 18", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "dJqN_xGBKwaeIC5bcG4TEgszD95", "name": "Spring 2023 - 19", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "zIy2cIm9qO1vpueHUwviMqzemYm", "name": "Spring 2023 - 20", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "p3R7lJcfUSKTzw4HRD2Pb2jUWh1", "name": "Spring 2023 - 21", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "upURnygIVRok76B7gqyQO2lcyhj", "name": "Spring 2023 - 22", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Wsh9rEXkDpT9zmBTV7IOZDBO513", "name": "Spring 2023 - 23", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "zijil4jxTIiY6oE5k3gQIUs7sT4", "name": "Spring 2023 - 24", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Bmy9m5jzyM2mKz3C2T7kEyJjg0k", "name": "Spring 2023 - 25", "season": "Spring", "year": "2023", "alteration": "!OfficialNadeo"},

        {"uid": "7hk8IflYsbMbpJv2gyYzx48Zvt7", "name": "Summer 2023 - 01", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "MXWiqbezzo03jdbq5RocFnyo7rm", "name": "Summer 2023 - 02", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "WmZ03TdjLsXufgnr4c2zeHFarjj", "name": "Summer 2023 - 03", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "dCjAuwEQX7gJ9FQwipZtxBZgCB8", "name": "Summer 2023 - 04", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "PUY0GI4rgGiAjK4o8nTZW2QvrA9", "name": "Summer 2023 - 05", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "ZmK6jYiKtlPonBPJcizk3MbWJ3m", "name": "Summer 2023 - 06", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "_8Y_L6OtGpluZo9hZIAfVfK2IN1", "name": "Summer 2023 - 07", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "0JGCnvDEnFZTSDmDOhprPUYvwIh", "name": "Summer 2023 - 08", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "5SSmvmxxcl9PSOpihacP0fVyJ5m", "name": "Summer 2023 - 09", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "uLTuyObJHgwQ3imynhvZzLHuHIm", "name": "Summer 2023 - 10", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Ry3hvIlSTPNoucwSTGtJtuHycpc", "name": "Summer 2023 - 11", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "lRRP2bUYCjCinn5IvPr_s8bpUJj", "name": "Summer 2023 - 12", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "MJMr4dIIroi2lU_n9peI8Tbzub",  "name": "Summer 2023 - 13", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "sEbDG1jZlWJSHn8c6du42P5TQA6", "name": "Summer 2023 - 14", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "sTnyAW9y9BY_RaTBrHQn43RDzmd", "name": "Summer 2023 - 15", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "SnsXvJAbLLmYNUnWP2xEbuEWBUb", "name": "Summer 2023 - 16", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "hXr6ucjiOFi2OIys3OGwNvVEH91", "name": "Summer 2023 - 17", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "L1cU9ejaXHgQkz7lIXEuxh5YGW",  "name": "Summer 2023 - 18", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "vIew_auy5tTCjF_5mf7BS5KeCc5", "name": "Summer 2023 - 19", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "9euCZooR_C1bLfAX8Fq_HNCasxl", "name": "Summer 2023 - 20", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "pgufNZ2qxXQcbaI_fkm0QRqPEK7", "name": "Summer 2023 - 21", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "hcEY0EgGCi2j6CTN2G8tiWW7Pc7", "name": "Summer 2023 - 22", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "3Bx1_oty8vrAk7Jlf63qwvlWQ4i", "name": "Summer 2023 - 23", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "ntnLI83jSOvdTqmEydbC1M_sybk", "name": "Summer 2023 - 24", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "ar1YeCxCQ8osUUmwyAprVyRc4Wb", "name": "Summer 2023 - 25", "season": "Summer", "year": "2023", "alteration": "!OfficialNadeo"},

        {"uid": "CMbUs4OzcDEwUcUUfOonUk4bit8", "name": "Fall 2023 - 01", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "zHkLNpadCwg6m8iJhpmiZ2IBppd", "name": "Fall 2023 - 02", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "L4ZaQ8GwLjMRAnm5xafWb2pvS_j", "name": "Fall 2023 - 03", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "OMdnBzKdfXLvY78qW3gf4IE8qu",  "name": "Fall 2023 - 04", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "e3zJ3badDcXBB7uboG4V8U2vJRc", "name": "Fall 2023 - 05", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "OpUNMYeOqouJ6LcOIZXTvHBJPE",  "name": "Fall 2023 - 06", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Iris7HUpoiOuWPHo66ILzG7lJQ2", "name": "Fall 2023 - 07", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "Kr0uBvcZNR_X3iYdk1ATgy9I9be", "name": "Fall 2023 - 08", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "f0yipIt9fLNstYHLIHH9GBtkD0",  "name": "Fall 2023 - 09", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "H5jpASfk6hAnL_eCjTcqUc6Qkn9", "name": "Fall 2023 - 10", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "YHuJj3uDZJtB2z7LH_91lKhGgLc", "name": "Fall 2023 - 11", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "VtJmsaPSUHT9gOADWKi4M4CL3tk", "name": "Fall 2023 - 12", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "WuVH1xk7hXiDEoW8pVwK8cK12sj", "name": "Fall 2023 - 13", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "_ubb4uj5z1EIjEQ1NhMQVqNZBom", "name": "Fall 2023 - 14", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "miMjehzUkQRJ3cIDvAB5nQsB7a1", "name": "Fall 2023 - 15", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "hw4QDZkMageFOrlmTofRblyV3K9", "name": "Fall 2023 - 16", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "IldAl8I6rrKcbAFajVz8XwP9sh4", "name": "Fall 2023 - 17", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "8af1oxaAao2GCqKyLRKEBq__hTm", "name": "Fall 2023 - 18", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "GVfBVIHLOHCCuTquXYePT4Fx2zc", "name": "Fall 2023 - 19", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "hXzJEg0oAfv7tC4l8SYaj1Nuykk", "name": "Fall 2023 - 20", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "kYBkv6xlVVbXRVHDXWEem3cYtOg", "name": "Fall 2023 - 21", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "BgGDVZKbYe3f2650WU4Ly2LRHc8", "name": "Fall 2023 - 22", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "UJJmEm6WLvYnsmtIZPxsootXYY5", "name": "Fall 2023 - 23", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "tjbEbQoiSDgeeRvPiSxUB8enNCa", "name": "Fall 2023 - 24", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},
        {"uid": "eWWM_jh1vY2pOuzNYx7fXvFJpn5", "name": "Fall 2023 - 25", "season": "Fall", "year": "2023", "alteration": "!OfficialNadeo"},

        {"uid": "JtxsQPcGS9fs7lrl0xVPaMwVN97", "name": "Winter 2024 - 01", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "KebGGKlfHOKiYtNfjIudPqWVMF2", "name": "Winter 2024 - 02", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "2oBvffN0RB9MU9LUmN7ankEJYVi", "name": "Winter 2024 - 03", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "uDXS9TWeQKzIUjWUOTgBYV8N5Z6", "name": "Winter 2024 - 04", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "nyEFLISrfRkRiG2wISsQnYm9G5j", "name": "Winter 2024 - 05", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "Alv8kG1jjhK2Il1C4JDxiygeZMa", "name": "Winter 2024 - 06", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "XkgUqpjBfzZzxj7n3aAy0Kr2nd6", "name": "Winter 2024 - 07", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "whR4gqrgMwfXSnAElMli0d16J7h", "name": "Winter 2024 - 08", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "Kg1nVgGp8bfVc4kbqz9aLcUBny8", "name": "Winter 2024 - 09", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "n7dH8uHp2WCJRAuiIZCpuuNU6El", "name": "Winter 2024 - 10", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "bDRcLIsxEbbac0eEtHn7qnvgJpd", "name": "Winter 2024 - 11", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "bHFtKTGKAmSiUzngSzrGnEhgRzj", "name": "Winter 2024 - 12", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "OsaDprWoMJSbmNVGSVz9_W7ue0d", "name": "Winter 2024 - 13", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "bNPnIE33nZ_1ac4XPqkY5VOjAig", "name": "Winter 2024 - 14", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "dnZLVBGMEC3md0SmyADmGqeIS57", "name": "Winter 2024 - 15", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "88MGs3oHHcZOWMqtH0R2H8eet0l", "name": "Winter 2024 - 16", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "DLcN1MPPJRiLaySQiMBA4fIuO2k", "name": "Winter 2024 - 17", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "_E3Sz1q7h_C47Izc3B5rT_uczB7", "name": "Winter 2024 - 18", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "uLXbj48kuVsXNgASzQPLddCjoO4", "name": "Winter 2024 - 19", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "89HH5AU8tkeCgj7_wws0tbS9YR7", "name": "Winter 2024 - 20", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "kbQzVZrNRr_nXizHH1xWGgR_yYk", "name": "Winter 2024 - 21", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "2fpMM3kIYqi1hN2PgdKqNQ4G962", "name": "Winter 2024 - 22", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "blqenheIuLxhUSUXNRp1iSc1jfh", "name": "Winter 2024 - 23", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "8AAJstK0fIhQO0_AO8RkRgQCzB3", "name": "Winter 2024 - 24", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "V0HLAzazg1MRNvFaUJiff_X_jo0", "name": "Winter 2024 - 25", "season": "Winter", "year": "2024", "alteration": "!OfficialNadeo"},

        {"uid": "yQ4ktCXu3SAxyRx9gar8hj7kVBb", "name": "Spring 2024 - 01", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "6y_26o7fxz0Es3t0e0EPBE7vF_k", "name": "Spring 2024 - 02", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "Qu0RAm2OEVhA8PtlHygSvwAP6af", "name": "Spring 2024 - 03", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "cg6LF9Dgogww_hL0I9rGoC4oXDb", "name": "Spring 2024 - 04", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "gLjlftQPuk5kBY2dpiabyAxXt2l", "name": "Spring 2024 - 05", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "lhLGScZNfT71Ti36T12QthclEx",  "name": "Spring 2024 - 06", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "OoIkCPCGS03kGSUVLdYQFYXp8z1", "name": "Spring 2024 - 07", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "k4TKkf1JSlWTEEZdCc9UCNTokk6", "name": "Spring 2024 - 08", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "2BlomISK77gQVgS6IvPahcbtEBm", "name": "Spring 2024 - 09", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "YnTMlq4EWuhP_3t07V1ltFN1d9i", "name": "Spring 2024 - 10", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "Dvta7ireTIDL0eM8yr41A9Bqrhj", "name": "Spring 2024 - 11", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "u7DgMxUjOS3QMoo6RK41_wVwUo8", "name": "Spring 2024 - 12", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "23qJ3GhkSPunIOi6hJGi53kN7Z6", "name": "Spring 2024 - 13", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "16SHL4He1HX73RGnwg1gw0XnVk5", "name": "Spring 2024 - 14", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "zmGw8qZpyugRtoRjIzv94NJEt00", "name": "Spring 2024 - 15", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "ANp_5I0olt_0vmies5vdxLkH1e2", "name": "Spring 2024 - 16", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "_oXHWr6nTCmZTUoLsLcC6Qn8VJl", "name": "Spring 2024 - 17", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "iX8qS5DXRjfaMqxYcToN75oXxzj", "name": "Spring 2024 - 18", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "jHJiEQ2HARFfrj4llyscCEajxla", "name": "Spring 2024 - 19", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "8zvR_6FvQnEAUs_Ng4mCDwkEe53", "name": "Spring 2024 - 20", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "mz96XbMuvGhHuAzHWWu_8Csfzb9", "name": "Spring 2024 - 21", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "23TjgtcgWtsOT8c8_YXmStk9yT1", "name": "Spring 2024 - 22", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "zNvVW_NnRdxDIQm6T6EbPDkYg20", "name": "Spring 2024 - 23", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "dQHEGKXg1PcUDL8pI5YGOfHtyum", "name": "Spring 2024 - 24", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
        {"uid": "bPpUQZuGgy56BE4ST2e9lb3Ln66", "name": "Spring 2024 - 25", "season": "Spring", "year": "2024", "alteration": "!OfficialNadeo"},
    #}


    
]



map_data = load_json_data("data/map_data.json")
sorted_maps = defaultdict(list)

for filename, map_info in map_data.items():
    map_info['filename'] = filename
    category = parse_map_category(map_info, alterations_dict, [snow_discovery_maps, rally_discovery_maps, official_competition_maps, all_TOTD_maps], special_uids)
    if category:
        sorted_maps[category].append(map_info)

save_sorted_data(sorted_maps, "byAlteration")

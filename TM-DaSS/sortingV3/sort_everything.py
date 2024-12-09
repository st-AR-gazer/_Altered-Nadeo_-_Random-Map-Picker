# parse_maps.py

import json
import re
import logging
from concurrent.futures import ThreadPoolExecutor
from uids import (
    DISCOVERY_CAMPAIGNS,
    OFFICIAL_NADEO_AUTHOR_AND_SUBMITTOR_UIDS,
    special_uids
)

INPUT_FILE = 'map_data.json'
OUTPUT_FILE = 'parsed_map_data.json'
LOG_FILE = 'unmatched_maps.log'

OFFICIAL_NADEO_TAG = "official nadeo map"

logging.basicConfig(
    filename=LOG_FILE,
    filemode='a',
    format='%(asctime)s %(levelname)s: %(message)s',
    datefmt='%Y-%m-%dT%H:%M:%S%z',
    level=logging.WARNING
)

console_handler = logging.StreamHandler()
console_handler.setLevel(logging.WARNING)
formatter = logging.Formatter('%(asctime)s %(levelname)s: %(message)s', '%Y-%m-%dT%H:%M:%S%z')
console_handler.setFormatter(formatter)
logging.getLogger().addHandler(console_handler)

logger = logging.getLogger(__name__)

VALID_SEASONS = ["winter", "spring", "summer", "fall", "training"]
SEASON_REGEX = '|'.join(VALID_SEASONS)

SANITIZE_PATTERN = re.compile(
    r'\$([0-9a-fA-F]{1,3}|[iIoOnNmMwWsSzZtTgG<>]|[lLhHpP](\[[^\]]+\])?)'
)

def sanitize_name(name: str) -> str:
    return SANITIZE_PATTERN.sub('', name).strip()

def validate_year(year: int) -> int:
    if year < 100:
        if 20 <= year <= 26:
            return 2000 + year
        else:
            logger.warning(f"Year {year} out of allowed range for short year (20-26).")
            return None
    else:
        if 2020 <= year <= 2026:
            return year
        else:
            logger.warning(f"Year {year} out of allowed range (2020-2026).")
            return None

def validate_mapnumber(map_nums: list) -> list:
    valid = []
    for num in map_nums:
        if 0 <= num <= 25:
            valid.append(num)
        else:
            logger.warning(f"Map number {num} out of allowed range (0-25).")
    return valid

# ------------------------------------------------------------
# REGEX PATTERNS (defined here for centralized attribute assignment)
# ------------------------------------------------------------


# ################ Altered Surface ################ #

# --------- Dirt ---------- #
# Pattern1: "Dirty <season> <year> - <mapnumber>"
dirt_pattern_1 = re.compile(
    rf"^(?P<alteration>Dirty)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# --------- fast-magnet ---------- #
# Pattern1: "<season> <year> - <mapnumber> FastMagnet"
fastmagnet_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>FastMagnet)$",
    re.IGNORECASE
)

# --------- Flooded ---------- #
# Pattern1: "<season> <year> - <mapnumber> Flooded"
flooded_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Flooded)$",
    re.IGNORECASE
)

# --------- Grass ---------- #
# Pattern1: "Grassy <season> <year> - <mapnumber>"
grass_pattern_1 = re.compile(
    rf"^(?P<alteration>Grassy)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# --------- Ice ---------- #
# Pattern1: "Icy <season> <year> - <mapnumber>"
ice_pattern_1 = re.compile(
    rf"^(?P<alteration>Icy)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# --------- Magnet ---------- #
# Pattern1: "<season> <year> - <mapnumber> Magnet"
magnet_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Magnet)$",
    re.IGNORECASE
)
# Pattern2: "Training - <mapnumber> Magnet"
magnet_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Magnet)$",
    re.IGNORECASE
)

# --------- Mixed ---------- #
# Pattern1: "Mixed <season> <year> - <mapnumber>"
mixed_pattern_1 = re.compile(
    rf"^(?P<alteration>Mixed)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# --------- Penalty ---------- #
# Pattern1: "<season> <year> - <mapnumber> Penalty"
penalty_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Penalty)$",
    re.IGNORECASE
)

# --------- Platic ---------- #
# Pattern1: "Plastic <season> <year> - <mapnumber>"
plastic_pattern_1 = re.compile(
    rf"^(?P<alteration>Plastic)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# --------- Road ---------- #
# Pattern1: "Roady <season> <year> - <mapnumber>"
road_pattern_1 = re.compile(
    rf"^(?P<alteration>Roady)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# --------- Wood ---------- #
# Pattern1: "<season> <year> - <mapnumber> Wood"
wood_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Wood)$",
    re.IGNORECASE
)

# --------- Bobsleigh ---------- #
# Pattern1: "<season> <year> - <mapnumber> (bobsleigh)"
bobsleigh_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>bobsleigh)\)$",
    re.IGNORECASE
)

# --------- Pipe ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Pipe)"
pipe_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Pipe)\)$",
    re.IGNORECASE
)

# --------- Sausage ---------- #
# Pattern1: "Saussage <season> <year> - <mapnumber>"
sausage_pattern_1 = re.compile(
    rf"^(?P<alteration>Sausage)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "Training - <mapnumber> Sausage"
sausage_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Sausage)$",
    re.IGNORECASE
)

# --------- Slot Track ---------- #
# Pattern1: "<season> <year> - <mapnumber> Slot Track"
slottrack_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Slot Track)$",
    re.IGNORECASE
)

# --------- Surfaceless ---------- #
# Pattern1: "<season> <year> - <mapnumber> Surfaceless"
surfaceless_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Surfaceless)$",
    re.IGNORECASE
)

# --------- Underwater ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Underwater)"
# Spring 2024 - 23 (Underwater)
underwater_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Underwater)\)$",
    re.IGNORECASE
)


# ################ Altered Effects ################ #

# -------- Antibooster ---------- #
# Pattern1: "<season> <year> - <mapnumber> AntiBoosters"
antibooster_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>AntiBoosters)$"#,
    # re.IGNORECASE
)

# -------- Boosterless ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Boosterless)"
boosterless_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Boosterless)\)$",
    re.IGNORECASE
)

# -------- Broken ---------- #
# Pattern1: "<season> <year> - <mapnumber> Broken"
broken_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Broken)$",
    re.IGNORECASE
)

# -------- Cleaned ---------- #
# Pattern1: "<season> <year> - <mapnumber> Cleaned"
cleaned_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Cleaned)$",
    re.IGNORECASE
)

# -------- Cruise Control ---------- #
# Pattern1: "<season> <year> - <mapnumber> Cruise Control"
cruisecontrol_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Cruise Control)$",
    re.IGNORECASE
)

# -------- Cruise Effects ---------- #
# Pattern1: "<season> <year> - <mapnumber> Cruise Effects"
cruiseeffects_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Cruise Effects)$",
    re.IGNORECASE
)
# Pattern2: "Training - <mapnumber> Cruise Effects"
cruiseeffects_pattern_2 = re.compile(
    rf"^<season>{SEASON_REGEX}\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Cruise Effects)$",
    re.IGNORECASE
)

# -------- Fast ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Fast)"
fast_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Fast)\)$",
    re.IGNORECASE
)

# -------- Fragile ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Fragile)"
fragile_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Fragile)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Fragile"
fragile_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Fragile)$",
    re.IGNORECASE
)

# -------- Full Fragile ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Full Fragile)"
fullfragile_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Full Fragile)\)$",
    re.IGNORECASE
)

# -------- FreeWheel ---------- #
# Pattern1: "<season> <year> - <mapnumber> FreeWheel"
freewheel_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>FreeWheel)$",
    re.IGNORECASE
)

# -------- Glider ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Glider"
glider_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Glider)$",
    re.IGNORECASE
)

# -------- No Brakes ---------- #
# Pattern1: "No Brakes - <season> <year> - <mapnumber>"
nobrakes_pattern_1 = re.compile(
    rf"^(?P<alteration>No Brakes)\s*-\s*(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> NoBrakes"
nobrakes_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>NoBrakes)$",
    re.IGNORECASE
)

# -------- No Effects ---------- #
# Pattern1: "<season> <year> Effectless - <mapnumber>"
noeffects_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<alteration>Effectless)\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- No Grip ---------- #
# Pattern1: "<season> <year> No Grip - <mapnumber>"
nogrip_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<alteration>No Grip)\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - No Grip"
nogrip_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>No Grip)$",
    re.IGNORECASE
)

# -------- No Steering ---------- #
# Pattern1: "<season> <year> No Steering - <mapnumber>"
nosteering_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<alteration>No Steering)\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Random Dankness ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Random Dankness"
randomdankness_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Random Dankness)$",
    re.IGNORECASE
)

# -------- Random Effects ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Random Effects"
randomeffects_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Random Effects)$",
    re.IGNORECASE
)

# -------- Reactor ---------- #
# Pattern1: "<season> <year> - <mapnumber> Reactor"
reactor_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Reactor)$",
    re.IGNORECASE
)

# -------- Reactor Down ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Reactor Down)"
reactordown_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Reactor Down)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Reactordown"
reactordown_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Reactordown)$",
    re.IGNORECASE
)

# -------- Red Effects ---------- #
# Pattern1: "<season> <year> - <mapnumber> Red Effects"
redeffects_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Red Effects)$",
    re.IGNORECASE
)

# -------- RNG Boosters ---------- #
# Pattern1: "<season> <year> - <mapnumber> RNG Booster"
rngboosters_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>RNG Booster)$",
    re.IGNORECASE
)
# Pattern2: "<spring2020season><mapnumber> RNG Boosters"
rngboosters_pattern_2 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+(?P<alteration>RNG Boosters)$",
    re.IGNORECASE
)

# -------- Slowmo ---------- #
# Pattern1: "<season> <year> - <mapnumber> slowmo"
slowmo_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>slowmo)$",
    re.IGNORECASE
)

# -------- Wet Wheels ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Wet-Wheels)"
wetwheels_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Wet-Wheels)\)$",
    re.IGNORECASE
)

# -------- Worn Tires ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Worn Tires)"
worntires_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Worn Tires)\)$",
    re.IGNORECASE
)


# ################ Altered Finish Location ################ #

# -------- 1Back/1Forwards ---------- #
# Pattern1: "<season> <year> - <mapnumber> (1-back)"
oneback_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>1-back)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - one back"
oneback_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>one back)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> - 1-back"
oneback_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>1-back)$",
    re.IGNORECASE
)
    
# Pattern4: "Training <year> 1-forward - <mapnumber>"
oneforward_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<alteration>1-forward)\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern5: "<spring2020><mapnumber> 1-forward"
oneforward_pattern_2 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+(?P<alteration>1-forward)$",
    re.IGNORECASE
)

# -------- 1 Down ---------- #
# Pattern1: "<season> <year> - <mapnumber> (1-DOWN)"
onedown_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>1-DOWN)\)$",
    re.IGNORECASE
)

# -------- 1 Left/1 Right ---------- #
# Pattern1: "<season> <year> - <mapnumber> 1 Left"
oneleft_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>1 Left)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> 1 Right"
oneright_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>1 Right)$",
    re.IGNORECASE
)

# -------- 1 Up ---------- #
# Pattern1: "<season> <year> - <mapnumber> (1-UP)"
oneup_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>1-UP)\)$",
    re.IGNORECASE
)

# -------- 2 Up ---------- #
# Pattern1: "<season> <year> - <mapnumber> (2-UP)"
twoup_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>2-UP)\)$",
    re.IGNORECASE
)

# -------- Better Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> (BeVerse)"
betterreverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>BeVerse)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - Better Reverse"
betterreverse_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Better Reverse)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> - Reverse Magna"
betterreverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Reverse Magna)$",
    re.IGNORECASE
)

# -------- CP1 is End ---------- #
# Pattern1: "<season> <year> - <mapnumber> CP1 Ends"
cp1isend_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>CP1 Ends)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> CP1 is End"
cp1isend_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>CP1 is End)$",
    re.IGNORECASE
)
# Pattern3: "<spring2020><mapnumber> CP1 is End"
cp1isend_pattern_3 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+(?P<alteration>CP1 is End)$",
    re.IGNORECASE
)

# -------- Floor Fin ---------- #
# Pattern1: "<season> <year> - <mapnumber> Floor-fin"
floorfin_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Floor-fin)$",
    re.IGNORECASE
)

# -------- Ground Clippers ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Ground Clippers)"
groundclippers_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Ground Clippers)\)$",
    re.IGNORECASE
)

# -------- Inclined ---------- #
# Pattern1: "<season> <year> - <mapnumber> Inclined"
inclined_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Inclined)$",
    re.IGNORECASE
)

# -------- Manslaughter ---------- #
# Pattern1: "<season> <year> - <mapnumber> Manslaughter"
manslaughter_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Manslaughter)$",
    re.IGNORECASE
)

# -------- No Gear 5 ---------- #
# Pattern1: "<season> <year> - <mapnumber> No Gear 5"
nogear5_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>No Gear 5)$",
    re.IGNORECASE
)

# -------- Podium ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Podium"
podium_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Podium)$",
    re.IGNORECASE
)

# -------- Puzzle ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Puzzle)"
puzzle_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Puzzle)\)$",
    re.IGNORECASE
)

# -------- Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Reverse"
reverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Reverse)$",
    re.IGNORECASE
)

# -------- Roofing ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Roofing)"
roofing_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Roofing)\)$",
    re.IGNORECASE
)

# --------- SHORT ---------- #
# Pattern1: "<season> <year> - <mapnumber> | Short"
short_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s*\|\s*(?P<alteration>Short)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Short"
short_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Short)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> shorts"
short_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>shorts)$",
    re.IGNORECASE
)
# Pattern4: "S06 Short" or "T13 Short"
# If starts with 'S': season='Spring', year=2020, mapnumber=06
# If starts with 'T': season='Spring', year=2020, mapnumber=13+10=23
short_pattern_4 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+(?P<alteration>Short)$",
    re.IGNORECASE
)
# Pattern5: "<season> <year> Short - <mapnumber>"
short_pattern_5 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<alteration>Short)\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# --------- Sky is the Finish ---------- #
# Pattern1: "<spring2020><mapnumber> Sky Finish"
skyfinish_pattern_1 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+(?P<alteration>Sky Finish)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Sky Finish"
skyfinish_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Sky Finish)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> (SITF)"
skyfinish_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>SITF)\)$",
    re.IGNORECASE
)
# Pattern4: "<season> <year> - <mapnumber> - Sky is the Finish"
skyfinish_pattern_4 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Sky is the Finish)$",
    re.IGNORECASE
)

# --------- There&Back/Boomerang ---------- #
# Pattern1: "<season> <year> - There&Back <mapnumber>"
thereandback_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<alteration>There&Back)\s+(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Boomerang"
thereandback_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Boomerang)$",
    re.IGNORECASE
)

# --------- YEP Tree Puzzle ---------- #
# Pattern1: "<season> <year> - <mapnumber> YEP TREE PUZZLE"
yeptreepuzzle_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>YEP TREE PUZZLE)$",
    re.IGNORECASE
)


# ################ Altered Enviroments ################ #

# -------- [Stadium] ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Stadium]"
stadium_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Stadium\])$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - CarSport"
stadium_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>CarSport)$",
    re.IGNORECASE
)
# Pattern3: "<special_map_name> - CarSport"
#stadium_pattern_3 = re.compile(
#    rf"^(?P<special_map_name>.*?)\s+-\s+(?P<alteration>CarSport)$",
#    re.IGNORECASE
#)

# -------- [Stadium] To The Top ---------- #
# Pattern1: "<season> <year> - <mapnumber> Stadium To The Top"
stadiumtothetop_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Stadium To The Top)$",
    re.IGNORECASE
)

# -------- [Stadium] Wet Wood ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Wet Wood Stadium Car)"
stadiumwetwood_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Wet Wood Stadium Car)\)$",
    re.IGNORECASE
)

# -------- [Snow] ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Snow]"
snow_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Snow\])$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - CarSnow"
snow_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>CarSnow)$",
    re.IGNORECASE
)
# Pattern3: "<special_map_name> - CarSnow"
#snow_pattern_3 = re.compile(
#    rf"^(?P<special_map_name>.*?)\s+-\s+(?P<alteration>CarSnow)$",
#    re.IGNORECASE
#)

# -------- [Snow] Carswitch ---------- #
# Pattern1: "<season> <year> - <mapnumber> Snowcarswitch"
snowcarswitch_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Snowcarswitch)$",
    re.IGNORECASE
)

# -------- [Snow] Checkpointless ---------- #
# Pattern1: "<season> <year> - <mapnumber> Checkpointless snow"
snowcheckpointless_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Checkpointless snow)$",
    re.IGNORECASE
)

# -------- [Snow] Ice ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Icy [Snow])"
snowice_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Icy \[Snow\])\)$",
    re.IGNORECASE
)

# -------- [Snow] Underwater ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Snow] (UW)"
snowunderwater_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Snow\]\s+\(UW\))$",
    re.IGNORECASE
)

# -------- [Snow] Wet Plastic ---------- #
# Pattern1: "(Snow) Wet Plastic <season> <year> - <mapnumber>"
snowwetplastic_pattern_1 = re.compile(
    rf"^(?P<alteration>\(Snow\) Wet Plastic)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- [Snow] Wood ---------- #
# Pattern1: "[Snow] <season> <year> - <mapnumber> Wood"
snowwood_pattern_1 = re.compile(
    rf"^\[Snow\]\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Wood)$",
    re.IGNORECASE
)

# -------- [Rally] ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Rally]"
rally_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Rally\])$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - CarRally"
rally_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>CarRally)$",
    re.IGNORECASE
)
# Pattern3: "<special_map_name> - CarRally"
#rally_pattern_3 = re.compile(
#    rf"^(?P<special_map_name>.*?)\s+-\s+(?P<alteration>CarRally)$",
#    re.IGNORECASE
#)

# -------- [Rally] Carswitch ---------- #
# Pattern1: "<season> <year> - <mapnumber> Rallycarswitch"
rallycarswitch_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Rallycarswitch)$",
    re.IGNORECASE
)

# -------- [Rally] CP1 is End ---------- #
# Pattern1: "[Rally] <season> <year> - <mapnumber> Cp1 is End"
rallycp1isend_pattern_1 = re.compile(
    rf"^(?P<environment>\[Rally\])\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Cp1 is End)$",
    re.IGNORECASE
)

# -------- [Rally] Ice ---------- #
# Pattern1: "Ricy <season> <year> - <mapnumber>"
rallyice_pattern_1 = re.compile(
    rf"^(?P<alteration>Ricy)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- [Rally] To The Top ---------- #
# Pattern1: "<season> <year> - <mapnumber> Rally to the Top"
rallytothetop_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Rally to the Top)$",
    re.IGNORECASE
)

# -------- [Rally] Underwater ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Rally] (Underwater)"
rallyunderwater_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\[Rally\]\s+\((?P<alteration>Underwater)\)$",
    re.IGNORECASE
)

# -------- [Desert] ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Desert]"
desert_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Desert\])$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - CarDesert"
desert_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>CarDesert)$",
    re.IGNORECASE
)
# Pattern3: "<special_map_name> - CarDesert"
#desert_pattern_3 = re.compile(
#    rf"^(?P<special_map_name>.*?)\s+-\s+(?P<alteration>CarDesert)$",
#    re.IGNORECASE
#)

# -------- [Desert] Antiboost ---------- #
# Pattern1: "<season> <year> - <mapnumber> - DAB"
desertantiboost_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>DAB)$",
    re.IGNORECASE
)

# -------- [Desert] Carswitch ---------- #
# Pattern1: "<season> <year> - <mapnumber> Desertcarswitch"
desertcarswitch_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Desertcarswitch)$",
    re.IGNORECASE
)

# -------- [Desert] Ice ---------- #
# Pattern1: "Dicy <season> <year> - <mapnumber>"
desertice_pattern_1 = re.compile(
    rf"^(?P<alteration>Dicy)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- [Desert] To The Top ---------- #
# Pattern1: "<season> <year> - <mapnumber> Desert to the Top"
deserttothetop_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Desert to the Top)$",
    re.IGNORECASE
)

# -------- [Desert] Underwater ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Desert] (UW)"
desertunderwater_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Desert\]\s+\(UW\))$",
    re.IGNORECASE
)

# -------- [Desert] Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Reverse Desert"
desertreverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Reverse Desert)$",
    re.IGNORECASE
)


# ################ Altered Game Mode ################ #

# -------- [Race] ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Race]"
race_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Race\])$",
    re.IGNORECASE
)

# -------- [Stunt] ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Stunt]"
stunt_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Stunt\])$",
    re.IGNORECASE
)

# -------- [Platform] ---------- #
# Pattern1: "<season> <year> - <mapnumber> [Platform]"
platform_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>\[Platform\])$",
    re.IGNORECASE
)


# ################ Multi Alterations ################ #

# -------- Checkpointless Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Checkpointless Reverse)"
checkpointlessreverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Checkpointless Reverse)\)$",
    re.IGNORECASE
)
# Pattern2: "<spring2020><mapnumber> (Checkpointless Reverse)"
checkpointlessreverse_pattern_2 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+\((?P<alteration>Checkpointless Reverse)\)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> - CPLess, Reverse"
checkpointlessreverse_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>CPLess, Reverse)$",
    re.IGNORECASE
)
# Pattern4: "<season> <year> - <mapnumber> - CPLess, Reverse (G)"
checkpointlessreverse_pattern_4 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>CPLess, Reverse \(G\))$",
    re.IGNORECASE
)
# Pattern5: "(G) <season> <year> - <mapnumber> - CPLess, Reverse"
checkpointlessreverse_pattern_5 = re.compile(
    rf"^(?P<alteration>\(G\))\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration_suffix>CPLess, Reverse)$",
    re.IGNORECASE
)

# -------- DEET To The Top ---------- #
# Pattern1: "<season> <year> - <mapnumber> (DEET to the Top)"
deettothetop_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>DEET to the Top)\)$",
    re.IGNORECASE
)

# -------- Ice Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> IR"
icereverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>IR)$",
    re.IGNORECASE
)

# -------- Ice Reverse Reactor ---------- #
# Pattern1: "Icy RR <season> <year> - <mapnumber>"
icereversereactor_pattern_1 = re.compile(
    rf"^(?P<alteration>Icy RR)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Ice Short ---------- #
# Pattern1: "short - Icy <season> <year> - <mapnumber>"
iceshort_pattern_1 = re.compile(
    rf"^(?P<alteration>short)\s+-\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Magner Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> Magnet Reverse"
magnetreverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Magnet Reverse)$",
    re.IGNORECASE
)

# -------- Plastic Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> PR"
plasticreverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>PR)$",
    re.IGNORECASE
)

# -------- Reverse Sky is the Finish ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Rev Sky is Finish"
reverseskyfinish_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Rev Sky is Finish)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - Rev Sky Finish"
reverseskyfinish_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Rev Sky Finish)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> - Rev Sky Fin"
reverseskyfinish_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Rev Sky Fin)$",
    re.IGNORECASE
)

# -------- Start Water 2 UP 1 Left - Checkpoints Unlinked - Finish 2 Down 1 Right ---------- #
# Pattern1: "<season> <year> - <mapnumber> sw2u1l-cpu-f2d1r"
sw2u1lcpuf2d1r_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>sw2u1l-cpu-f2d1r)$",
    re.IGNORECASE
)

# -------- Underwater Reverse ---------- #
# Pattern1: "<season> <year> - <mapnumber> (UW Reverse)"
underwaterreverse_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>UW Reverse)\)$",
    re.IGNORECASE
)
# Pattern2: "Training - <mapnumber> (UW Reverse)"
underwaterreverse_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+-\s+(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>UW Reverse)\)$",
    re.IGNORECASE
)

# -------- Wet Plastic ---------- #
# Pattern1: "Wet Plastic <season> <year> - <mapnumber>"
wetplastic_pattern_1 = re.compile(
    rf"^(?P<alteration>Wet Plastic)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Wet Wood ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Wet Wood)"
wetwood_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Wet Wood)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> (Wet Wood Red Reactor Down)"
wetwood_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Wet Wood Red Reactor Down)\)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> (Wet Wood Yellow Reactor Down)"
wetwood_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Wet Wood Yellow Reactor Down)\)$",
    re.IGNORECASE
)

# -------- Wet Icy Wood ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Wet Icy Wood)"
weticywood_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Wet Icy Wood)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> (100% Wet Icy Wood)"
weticywood_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>100% Wet Icy Wood)\)$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> - <mapnumber> (Pure Wet Icy Wood)"
weticywood_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Pure Wet Icy Wood)\)$",
    re.IGNORECASE
)

# -------- YEET Max-Up ---------- #
# Pattern1: "YEET <season> <year> - <mapnumber> Max-up"
yeetmaxup_pattern_1 = re.compile(
    rf"^(?P<alteration>YEET)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{2,4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration_suffix>Max-up)$",
    re.IGNORECASE
)

# -------- YEET (Random) Puzzle ---------- #
# Pattern1: "<season> <year> - <mapnumber> (YEET Puzzle)"
yeetpuzzle_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Yeet Puzzle)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> (YEET Random Puzzle)"
yeetpuzzle_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Yeet Random Puzzle)\)$",
    re.IGNORECASE
)

# -------- YEET Reverse ---------- #
# Pattern1: "YEET <season> <year> - <mapnumber> Reverse"
yeetreverse_pattern_1 = re.compile(
    rf"^(?P<alteration>YEET)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{2,4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration_suffix>Reverse)$",
    re.IGNORECASE
)


# ################ Other Alterations ################ #

# -------- XX-But ---------- #
# Pattern1: ""
#xxbut_pattern_1 = re.compile(
#    rf"",
#    re.IGNORECASE
#)

# -------- Flat/2D ---------- #
# Pattern1: "FLAT <season> <year> - <mapnumber>"
flat_pattern_1 = re.compile(
    rf"^(?P<alteration>FLAT)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{2,4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "Flat Training - <mapnumber>"
flat_pattern_2 = re.compile(
    rf"^(?P<alteration>Flat)\s(?P<season>Training)\s+-\s+(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern3: "Training - <mapnumber> Flat"
flat_pattern_3 = re.compile(
    rf"^(?P<season>Training)\s+-\s+(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Flat)$",
    re.IGNORECASE
)
# Pattern4: "Flat<season>'<year> - <mapnumber>"
flat_pattern_3 = re.compile(
    rf"^(?P<alteration>Flat)(?P<season>{SEASON_REGEX})'(?P<year>\d{{2}})\s+-\s+(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- A08 ---------- #
# Pattern1: "<season> <year> - <mapnumber> - 08"
a08_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>08)$",
    re.IGNORECASE
)

# -------- Backwards ---------- #
# Pattern1: "<season> <year> - <mapnumber> backwards"
backwards_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>backwards)$",
    re.IGNORECASE
)

# -------- BOSS ---------- #
# FIXME: This alteration is fundamentally different regarding "mapnumber", as it applies to multiple maps, this is the reason that map number is in an array...
# Pattern1: "BOSS <each map number in sets from 1-5 shown in sets using colours, white = 1-5, green = 6-10, blue = 11-15, red 16-20 black 21-25> of <season> <year>"
#boss_pattern_1 = re.compile(
#    rf"^(?P<alteration>BOSS)\s+(?P<mapnumber>\d{{1,2}})\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})$",
#    re.IGNORECASE
#)
# Pattern2: "<each map number in sets from 1-5 shown in sets using colours, white = 1-5, green = 6-10, blue = 11-15, red 16-20 black 21-25> BOSS - <season>'<year>"
#boss_pattern_2 = re.compile(
#    rf"^(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>BOSS)\s+-\s+(?P<season>{SEASON_REGEX})'(?P<year>\d{{2}})$",
#    re.IGNORECASE
#)

# -------- Bumper ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Bumper"
bumper_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Bumper)$",
    re.IGNORECASE
)
# Pattern2: "Training - <mapnumber> Bumper"
bumper_pattern_2 = re.compile(
    rf"^(?P<season>Training)\s+-\s+(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Bumper)$",
    re.IGNORECASE
)

# #### Altered Camera #### #
# -------- Blind ---------- #
# Pattern1: "<season> <mapnumber> (Blind)"
blind_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Blind)\)$",
    re.IGNORECASE
)
# -------- Egocentrism ---------- #
# Pattern1: "<season> <year> - <mapnumber> Egocentrism"
egocentrism_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Egocentrism)$",
    re.IGNORECASE
)
# -------- Replay ---------- #
# Pattern1: "<season> <year> - Replay <mapnumber>"
replay_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s+(?P<alteration>Replay)\s+(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# #### End of Altered Camera #### #

# -------- N'golo ---------- #
# Pattern1: "<season>N'golo <year> - <mapnumber>"
ngolo_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})N'golo\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "<season>olo <year> - <mapnumber>"
ngolo_pattern_2 = re.compile(
    rf"^(?P<season>Spring)olo\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Checkpoin't ---------- #
# Pattern1: "<season> <year> Checkpoin't - <mapnumber>"
checkpoin_t_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<alteration>Checkpoin't)\s+-\s+(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Colour Combined ---------- #
# Pattern1: "<season> <year> - <each map number in sets from 1-5 shown in sets using colours, white = 1-5, green = 6-10, blue = 11-15, red 16-20 black 21-25> Combined"
colourcombined_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+-\s+(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Combined)$",
    re.IGNORECASE
)

# -------- Checkpoint Boost Swap ---------- #
# Pattern1: "<season> <year> - <mapnumber> CP-Boost Swap"
checkpointboostswap_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>CP-Boost Swap)$",
    re.IGNORECASE
)

# -------- Checkpoint 1 Kept ---------- #
# Pattern1: "<season> <year> - <mapnumber> CP1 Kept"
checkpoint1kept_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>CP1 Kept)$",
    re.IGNORECASE
)

# -------- Checkpointfull ---------- #
# Pattern1: "<season> <year> - <mapnumber> CPfull"
checkpointfull_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>CPfull)$",
    re.IGNORECASE
)

# -------- Checkpointless ---------- #
# Pattern1: "<season> <year> - <mapnumber> - Checkpointless"
checkpointless_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Checkpointless)$",
    re.IGNORECASE
)
# Pattern2: "Training - <mapnumber> - Checkpointless"
checkpointless_pattern_2 = re.compile(
    rf"^(?P<season>Training)\s+-\s+(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Checkpointless)$",
    re.IGNORECASE
)
# Pattern3: "<spring2020><mapnumber> - Checkpointless"
checkpointless_pattern_3 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+-\s+(?P<alteration>Checkpointless)$",
    re.IGNORECASE
)

# -------- Checkpointlink ---------- #
# Pattern1: "<season> <year> - <mapnumber> CPLink"
checkpointlink_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>CPLink)$",
    re.IGNORECASE
)

# -------- Checkpoints Rotated 90° / Got Rotated ---------- #
# Pattern1: "<season> <year> - <mapnumber> - CPs Rotated 90°"
checkpointsrotated90_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>CPs Rotated 90°)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Got Rotated"
gotrotated_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Got Rotated)$",
    re.IGNORECASE
)

# -------- DragonYeet ---------- #
# Pattern1: "<season> <year> - <mapnumber> (DragonYeet)"
dragonyeet_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>DragonYeet)\)$",
    re.IGNORECASE
)

# -------- Earthquake ---------- #
# Pattern1: "<season> <year> - <mapnumber> Earthquake"
earthquake_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Earthquake)$",
    re.IGNORECASE
)

# -------- Extra Checkpoint ---------- #
# Pattern1: "<season> <year> - <mapnumber> Extra CP"
extracheckpoint_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Extra CP)$",
    re.IGNORECASE
)

# -------- Flipped ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Flipped)"
flipped_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Flipped)\)$",
    re.IGNORECASE
)
# Pattern2: "<season><year>UpsideDown - <mapnumber>"
flipped_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})(?P<year>\d{{4}})(?P<alteration_suffix>UpsideDown)\s+-\s+(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Holes ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Holes)"
holes_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Holes)\)$",
    re.IGNORECASE
)

# -------- Lunatic ---------- #
# Pattern1: "Lunatic <season> <year> - <mapnumber>"
lunatic_pattern_1 = re.compile(
    rf"^(?P<alteration>Lunatic)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "Harder <season> <year> - <mapnumber>"
lunatic_pattern_2 = re.compile(
    rf"^(?P<alteration>Harder)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Mini-RPG ---------- #
# Pattern1: "RPG <season><year> - <mapnumber>"
minirpg_pattern_1 = re.compile(
    rf"^(?P<alteration>RPG)\s+(?P<season>{SEASON_REGEX})(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Mirrored ---------- #
# Pattern1: "<season> <mapnumber> (Mirror)"
mirrored_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Mirror)\)$",
    re.IGNORECASE
)

# -------- No Items ---------- #
# Pattern1: "<season> <year> - <mapnumber> NoItems"
noitems_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>NoItems)$",
    re.IGNORECASE
)

# -------- Pool Hunters ---------- #
# Pattern1: "<season> <year> - <mapnumber> Pool Hunters"
poolhunters_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Pool Hunters)$",
    re.IGNORECASE
)

# -------- Random ---------- #
# Pattern1: "Random <season> <year> - <mapnumber>"
random_pattern_1 = re.compile(
    rf"^(?P<alteration>Random)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Ring Checkpoint ---------- #
# Pattern1: "<season> <year> - <mapnumber> Ring CP"
ringcheckpoint_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Ring CP)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> (Ring CP)"
ringcheckpoint_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Ring CP)\)$",
    re.IGNORECASE
)

# -------- Sections Joined ---------- #
# FIXME: This alteration is fundamentally different regarding "mapnumber", as it applies to multiple maps, I will likely say that 'map 1 is the first section of each set' etc
# Pattern1: "<season> <year> - Section [index] joined"
sectionsjoined_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<alteration>Section \[\d+\] joined)$",
    re.IGNORECASE
)

# -------- Select DEL ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Select DEL)"
selectdel_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Select DEL)\)$",
    re.IGNORECASE
)

# -------- Speedlimit ---------- #
# Pattern1: "<season> <year> - <mapnumber> (Speedlimit)"
speedlimit_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Speedlimit)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Speed Limit"
speedlimit_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Speed Limit)$",
    re.IGNORECASE
)

# -------- Start 1-Down ---------- #
# there are a bunch of maps that are just taggen "1-down" without the "start" part, so I have to use 'special uids' to individually identify them
# Pattern1: "<season> <year> - <mapnumber> (Start 1-Down)"
start1down_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>Start 1-Down)\)$",
    re.IGNORECASE
)

# -------- Supersized ---------- #
# FIXME: Supersized_Spring_2024_-_05 just found out that cases like <--- exist, so I have to replace "_" with " " before doing any regex? (or is this also counted as a whitespace?)
# Pattern1: "Supersized <season> <year> - <mapnumber>"
supersized_pattern_1 = re.compile(
    rf"^(?P<alteration>Supersized)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern2: "Supersized Training - <mapnumber>"
supersized_pattern_2 = re.compile(
    rf"^(?P<alteration>Supersized)\s+(?P<season>Training)\s+-\s+(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)
# Pattern3: "<season> <year> <mapnumber> Big"
supersized_pattern_3 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Big)$",
    re.IGNORECASE
)
# Pattern4: "Super<mapnumber>"
supersized_pattern_4 = re.compile(
    rf"^(?P<alteration>Super)(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Straigt to the Finish ---------- #
# Pattern1: "<season> <year> - <mapnumber> Straight to the Finish"
straighttothefinish_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Straight to the Finish)$",
    re.IGNORECASE
)
# Pattern2: "<spring2020><mapnumber> STTF"
straighttothefinish_pattern_2 = re.compile(
    r"^(?P<code>[STst][0-1]\d)\s+(?P<alteration>STTF)$",
    re.IGNORECASE
)

# -------- Stunt Mode ---------- #
# Pattern1: "<season> <year> - <mapnumber> Stunt"
stuntmode_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Stunt)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> Stunt Mode"
stuntmode_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+(?P<alteration>Stunt Mode)$",
    re.IGNORECASE
)

# -------- Symmetrical ---------- #
# Pattern1: "Symmetrical <season> <year> - <mapnumber>"
symmetrical_pattern_1 = re.compile(
    rf"^(?P<alteration>Symmetrical)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- Tilted ---------- #
# Pattern1: "<season> <mapnumber> - Tilted"
tilted_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Tilted)$",
    re.IGNORECASE
)

# -------- YEET ---------- #
# Pattern1: "YEET <season> <year> - <mapnumber>"
yeet_pattern_1 = re.compile(
    rf"^(?P<alteration>YEET)\s+(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE
)

# -------- YEET Down ---------- #
# Pattern1: "<season> <year> - <mapnumber> (DEET)"
yeetdown_pattern_1 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+\((?P<alteration>DEET)\)$",
    re.IGNORECASE
)
# Pattern2: "<season> <year> - <mapnumber> - Deet"
yeetdown_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s*-\s*(?P<mapnumber>\d{{1,2}})\s+-\s+(?P<alteration>Deet)$",
    re.IGNORECASE
)





ALL_PATTERNS = [
    dirt_pattern_1, 
    fastmagnet_pattern_1,
    flooded_pattern_1,
    grass_pattern_1,
    ice_pattern_1,
    magnet_pattern_1, magnet_pattern_2,
    mixed_pattern_1,
    penalty_pattern_1,
    plastic_pattern_1,
    road_pattern_1,
    wood_pattern_1,
    bobsleigh_pattern_1,
    pipe_pattern_1,
    sausage_pattern_1, sausage_pattern_2,
    slottrack_pattern_1,
    surfaceless_pattern_1,
    underwater_pattern_1,
    
    antibooster_pattern_1,
    boosterless_pattern_1,
    broken_pattern_1,
    cleaned_pattern_1,
    cruisecontrol_pattern_1,
    cruiseeffects_pattern_1, cruiseeffects_pattern_2,
    fast_pattern_1,
    fragile_pattern_1, fragile_pattern_2,
    fullfragile_pattern_1,
    freewheel_pattern_1,
    glider_pattern_1,
    nobrakes_pattern_1, nobrakes_pattern_2,
    noeffects_pattern_1, 
    nogrip_pattern_1, nogrip_pattern_2,
    nosteering_pattern_1,
    randomdankness_pattern_1,
    randomeffects_pattern_1,
    reactor_pattern_1,
    reactordown_pattern_1, reactordown_pattern_2,
    redeffects_pattern_1,
    rngboosters_pattern_1, rngboosters_pattern_2,
    slowmo_pattern_1,
    wetwheels_pattern_1,
    worntires_pattern_1,
    
    oneback_pattern_1, oneback_pattern_2, oneback_pattern_3, oneforward_pattern_1, oneforward_pattern_2,
    onedown_pattern_1,
    oneleft_pattern_1, oneright_pattern_1,
    oneup_pattern_1,
    twoup_pattern_1,
    betterreverse_pattern_1, betterreverse_pattern_2,
    cp1isend_pattern_1, cp1isend_pattern_2, cp1isend_pattern_3,
    floorfin_pattern_1,
    groundclippers_pattern_1,
    inclined_pattern_1,
    manslaughter_pattern_1,
    nogear5_pattern_1,
    podium_pattern_1,
    puzzle_pattern_1,
    reverse_pattern_1,
    roofing_pattern_1,
    short_pattern_1, short_pattern_2, short_pattern_3, short_pattern_4, short_pattern_5,
    skyfinish_pattern_1, skyfinish_pattern_2, skyfinish_pattern_3, skyfinish_pattern_4,
    thereandback_pattern_1, thereandback_pattern_2,
    yeptreepuzzle_pattern_1,
    
    stadium_pattern_1, stadium_pattern_2, #stadium_pattern_3,
    stadiumtothetop_pattern_1,
    stadiumwetwood_pattern_1,
    snow_pattern_1, snow_pattern_2, #snow_pattern_3,
    snowcarswitch_pattern_1,
    snowcheckpointless_pattern_1,
    snowice_pattern_1,
    snowunderwater_pattern_1,
    snowwetplastic_pattern_1,
    snowwood_pattern_1,
    rally_pattern_1, rally_pattern_2, #rally_pattern_3,
    rallycarswitch_pattern_1,
    rallycp1isend_pattern_1,
    rallyice_pattern_1,
    rallytothetop_pattern_1,
    rallyunderwater_pattern_1,
    desert_pattern_1, desert_pattern_2, #desert_pattern_3,
    desertantiboost_pattern_1,
    desertcarswitch_pattern_1,
    desertice_pattern_1,
    deserttothetop_pattern_1,
    desertunderwater_pattern_1,
    desertreverse_pattern_1,
    
    race_pattern_1,
    stunt_pattern_1,
    platform_pattern_1,
    
    checkpointlessreverse_pattern_1, checkpointlessreverse_pattern_2, checkpointlessreverse_pattern_3, checkpointlessreverse_pattern_4, checkpointlessreverse_pattern_5,
    deettothetop_pattern_1,
    icereverse_pattern_1,
    icereversereactor_pattern_1,
    magnetreverse_pattern_1,
    plasticreverse_pattern_1,
    reverseskyfinish_pattern_1, reverseskyfinish_pattern_2, reverseskyfinish_pattern_3,
    sw2u1lcpuf2d1r_pattern_1, 
    underwaterreverse_pattern_1, underwaterreverse_pattern_2,
    wetplastic_pattern_1,
    wetwood_pattern_1, wetwood_pattern_2, wetwood_pattern_3,
    weticywood_pattern_1, weticywood_pattern_2, weticywood_pattern_3,
    yeetmaxup_pattern_1,
    yeetpuzzle_pattern_1, yeetpuzzle_pattern_2,
    yeetreverse_pattern_1,
    
    # xxbut_pattern_1,
    flat_pattern_1, flat_pattern_2, flat_pattern_3,
    a08_pattern_1,
    backwards_pattern_1,
    #boss_pattern_1, boss_pattern_2,
    bumper_pattern_1, bumper_pattern_2,
    # Camera
    blind_pattern_1,
    egocentrism_pattern_1,
    replay_pattern_1,
    #
    ngolo_pattern_1, ngolo_pattern_2,
    checkpoin_t_pattern_1,
    colourcombined_pattern_1,
    checkpointboostswap_pattern_1,
    checkpoint1kept_pattern_1,
    checkpointfull_pattern_1,
    checkpointless_pattern_1, checkpointless_pattern_2, checkpointless_pattern_3,
    checkpointlink_pattern_1,
    checkpointsrotated90_pattern_1, gotrotated_pattern_1,
    dragonyeet_pattern_1,
    earthquake_pattern_1,
    extracheckpoint_pattern_1,
    flipped_pattern_1, flipped_pattern_2,
    holes_pattern_1,
    lunatic_pattern_1, lunatic_pattern_2,
    minirpg_pattern_1,
    mirrored_pattern_1,
    noitems_pattern_1,
    poolhunters_pattern_1,
    random_pattern_1,
    ringcheckpoint_pattern_1, ringcheckpoint_pattern_2,
    sectionsjoined_pattern_1,
    selectdel_pattern_1,
    speedlimit_pattern_1, speedlimit_pattern_2,
    start1down_pattern_1,
    supersized_pattern_1, supersized_pattern_2, supersized_pattern_3, supersized_pattern_4,
    straighttothefinish_pattern_1, straighttothefinish_pattern_2,
    stuntmode_pattern_1, stuntmode_pattern_2,
    symmetrical_pattern_1,
    tilted_pattern_1,
    yeet_pattern_1,
    yeetdown_pattern_1, yeetdown_pattern_2,
]

ft_pattern = re.compile(
    r"(?:ft[' ]|ft |featuring |AT by )(\w+)",
    re.IGNORECASE
)

def try_discovery_campaigns(map_name: str):
    for campaign in DISCOVERY_CAMPAIGNS:
        for dmap, dnum in campaign['maps'].items():
            if map_name.lower().startswith(dmap.lower()):
                remainder = map_name[len(dmap):].strip()
                return {
                    'season': campaign['season'].capitalize(),
                    'year': int(campaign['year']),
                    'mapnumber': [int(dnum)],
                    'alteration': remainder if remainder else ''
                }
    return None

def match_known_patterns(map_name: str):
    for pattern in ALL_PATTERNS:
        match = pattern.match(map_name)
        if match:
            attrs = match.groupdict()

            if 'code' in attrs and attrs['code']:
                code = attrs['code'].upper()
                season = 'Spring'
                year = 2020
                map_num = int(code[1:])
                if code.startswith('T'):
                    map_num += 10
                valid_mapnums = validate_mapnumber([map_num])
                if not valid_mapnums:
                    return None
                return {
                    'season': season,
                    'year': year,
                    'mapnumber': valid_mapnums,
                    'alteration': 'Short'
                }

            if 'year' in attrs and attrs['year']:
                y = validate_year(int(attrs['year']))
                if y is None:
                    return None
                attrs['year'] = y
            else:
                attrs['year'] = None

            if 'mapnumber' in attrs and attrs['mapnumber']:
                m = validate_mapnumber([int(attrs['mapnumber'])])
                if not m:
                    return None
                attrs['mapnumber'] = m
            else:
                attrs['mapnumber'] = []

            alteration = attrs.get('alteration', '').strip()
            alteration_suffix = attrs.get('alteration_suffix', '').strip() if 'alteration_suffix' in attrs else ''

            if alteration and alteration_suffix:
                combined_alteration = f"{alteration} {alteration_suffix}".strip()
            else:
                combined_alteration = alteration or alteration_suffix

            if 'season' in attrs and attrs['season']:
                attrs['season'] = attrs['season'].capitalize()
            else:
                attrs['season'] = None

            attrs['alteration'] = combined_alteration
            if 'alteration_suffix' in attrs:
                del attrs['alteration_suffix']

            return attrs
    return None

def try_special_uids(map_uid: str):
    for entry in special_uids:
        if entry['uid'].lower() == map_uid.lower():
            year = int(entry['year']) if entry['year'] else None
            year = validate_year(year) if year else None
            map_nums = []
            if entry['mapNumber']:
                map_nums = validate_mapnumber([int(entry['mapNumber'])])
            return {
                'season': entry['season'].capitalize() if entry['season'] else None,
                'year': year,
                'mapnumber': map_nums,
                'alteration': entry['alteration'] if entry['alteration'] else ''
            }
    return None

def extract_and_remove_ft(map_name: str):
    match = ft_pattern.search(map_name)
    if match:
        username = match.group(1)
        start, end = match.span()
        cleaned_name = map_name[:start] + map_name[end:]
        return cleaned_name, username
    return map_name, None

def normalize_whitespace(map_name: str):
    return re.sub(r'\s+', ' ', map_name).strip()

def assign_attributes(item_data: dict) -> dict:
    raw_name = item_data['name']
    sanitized_name = sanitize_name(raw_name)
    filename = sanitize_name(item_data['filename'].replace('.Map.Gbx', ''))
    map_uid = item_data.get('mapUid', '')

    sanitized_name, ft_username = extract_and_remove_ft(sanitized_name)
    sanitized_name = normalize_whitespace(sanitized_name)
    filename = normalize_whitespace(filename)

    attributes = try_discovery_campaigns(sanitized_name)
    if not attributes:
        attributes = match_known_patterns(sanitized_name)

    if not attributes and sanitized_name != filename:
        attributes = match_known_patterns(filename)

    if not attributes:
        attributes = try_special_uids(map_uid)

    if not attributes:
        attributes = {
            'season': None,
            'year': None,
            'mapnumber': [],
            'alteration': ''
        }
        logger.warning(f"Unmatched map name: {raw_name}")

    if attributes.get('alteration', '').lower() == 'super':
        attributes['alteration'] = 'Supersized'

    if ft_username:
        attributes['ft'] = ft_username

    if (
        item_data.get('author') in OFFICIAL_NADEO_AUTHOR_AND_SUBMITTOR_UIDS or
        item_data.get('submitter') in OFFICIAL_NADEO_AUTHOR_AND_SUBMITTOR_UIDS
    ):
        attributes['alteration'] = OFFICIAL_NADEO_TAG

    return attributes

def process_item(item: tuple) -> tuple:
    key, data = item
    parsed_attrs = assign_attributes(data)
    combined_data = {**data, **parsed_attrs}
    return key, combined_data

def main():
    try:
        with open(INPUT_FILE, 'r', encoding='utf-8') as f:
            map_data = json.load(f)
    except FileNotFoundError:
        logger.error(f"Input file {INPUT_FILE} not found.")
        return
    except json.JSONDecodeError as e:
        logger.error(f"Error decoding JSON from {INPUT_FILE}: {e}")
        return

    items = list(map_data.items())

    results = {}
    with ThreadPoolExecutor(max_workers=16) as executor:
        futures = [executor.submit(process_item, item) for item in items]
        for future in futures:
            try:
                key, value = future.result()
                results[key] = value
            except Exception as e:
                logger.error(f"Error processing item: {e}")

    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
            json.dump(results, f, ensure_ascii=False, indent=4)
        logger.info(f"Parsed data written to {OUTPUT_FILE}")
    except Exception as e:
        logger.error(f"Error writing to output file {OUTPUT_FILE}: {e}")

if __name__ == "__main__":
    main()

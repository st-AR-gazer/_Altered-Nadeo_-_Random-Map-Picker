import re

SEASON_REGEX = '|'.join(["winter", "spring", "summer", "fall", "training"])
poolhunters_seasonal_pattern_2 = re.compile(
    rf"^(?P<season>{SEASON_REGEX})\s+(?P<year>\d{{4}})\s+(?P<alteration>poolhunter)\s*-\s*(?P<mapnumber>\d{{1,2}})$",
    re.IGNORECASE)

test_map_name = "Spring 2023 Poolhunter - 01"
match = poolhunters_seasonal_pattern_2.match(test_map_name)
if match:
    print(match.groupdict())
else:
    print("No match")

import subprocess
import argparse

parser = argparse.ArgumentParser(description="Main script to run the entire TM-DaSS process.")
parser.add_argument('-v', '--verbose', action='store_true', help="Enable verbose output.")
args = parser.parse_args()
verbose = args.verbose

def run_script(script_name):
    """Runs a python script with optional verbosity."""
    command = ["python", script_name]
    if verbose:
        command.append("--verbose")
    result = subprocess.run(command, capture_output=True, text=True)
    if verbose:
        print(f"Running {script_name}...\n{result.stdout}\n{result.stderr}")
    if result.returncode != 0:
        raise Exception(f"Error occurred while running {script_name}")

try:
    run_script("DownloadFromNadeo.py")
    print("DownloadFromNadeo.py ran successfully.")
    run_script("SortByAlteration.py")
    print("SortByAlteration.py ran successfully.")
    run_script("SortBySeason.py")
    print("SortBySeason.py ran successfully.")
    run_script("ConsolidateFilesToOne.py")
    print("ConsolidateFilesToOne.py ran successfully.")
    print("TM-DaSS process completed successfully.")
except Exception as e:
    print(f"An error occurred: {e}")

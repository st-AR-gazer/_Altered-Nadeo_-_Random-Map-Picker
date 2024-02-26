import subprocess
import os

def run_script(script_name):
    result = subprocess.run(['python', script_name], capture_output=True, text=True)
    print(f"Running {script_name}:")
    print(result.stdout)
    if result.stderr:
        print(f"Errors in {script_name}:")
        print(result.stderr)

run_script('RecordFileStateToDir.py')

run_script('DownloadFromNadeo.py')
run_script('SortByAlteration.py')
run_script('SortBySeason.py')

run_script('RecordNewFileState.py')

run_script('CompareFileStates.py')

run_script('CreateManifest.py')

# Sorry Miss, but this was the easiest way to get all the Track of the Day names I could think of ShrugEg

import time
import re
import csv
from datetime import datetime
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import (
    NoSuchElementException,
    TimeoutException,
    WebDriverException,
)
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

START_YEAR = 2020
START_MONTH = 8
END_YEAR = 2024
END_MONTH = 12
BASE_URL = "https://trackmania.io/#/totd/{year}-{month}"
DELAY_BETWEEN_REQUESTS = 2
OUTPUT_CSV = "totd_names.csv"

pattern = re.compile(r"\$([0-9a-fA-F]{1,3}|[iIoOnNmMwWsSzZtTgG<>]|[lLhHpP](\[[^\]]+\])?)")

def init_driver():
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--disable-gpu")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--window-size=1920,1080")
    chrome_options.add_argument("--disable-dev-shm-usage")
    try:
        driver = webdriver.Chrome(options=chrome_options)
        return driver
    except WebDriverException as e:
        print(f"Error initializing WebDriver: {e}")
        exit(1)

def generate_date_range(start_year, start_month, end_year, end_month):
    dates = []
    current = datetime(start_year, start_month, 1)
    end = datetime(end_year, end_month, 1)
    while current <= end:
        dates.append((current.year, current.month))
        if current.month == 12:
            current = datetime(current.year + 1, 1, 1)
        else:
            current = datetime(current.year, current.month + 1, 1)
    return dates

def extract_and_write(driver, year, month, writer, file):
    url = BASE_URL.format(year=year, month=str(month).zfill(2))
    print(f"Processing {year}-{month:02d}")
    try:
        driver.get(url)
    except TimeoutException:
        print(f"Timeout while loading {url}. Skipping...\n")
        return
    except Exception as e:
        print(f"Error loading {url}: {e}\n")
        return

    try:
        wait = WebDriverWait(driver, 30)
        table = wait.until(EC.presence_of_element_located((By.XPATH, "//section//table/tbody")))
        rows = table.find_elements(By.TAG_NAME, "tr")
        print(f"Found {len(rows)} rows.")
    except TimeoutException:
        print(f"Table not found for {year}-{month}. Skipping...\n")
        return
    except NoSuchElementException:
        print(f"No rows found for {year}-{month}. Skipping...\n")
        return

    rows.reverse()

    for row in rows:
        try:
            span = row.find_element(By.XPATH, "./td[3]/p[1]/span[2]")
            span_class = span.get_attribute("class")
            if "game-text" not in span_class:
                print("Span does not have 'game-text' class. Skipping row.\n")
                continue
            data_source = span.get_attribute("data-source")
            if not data_source:
                print("'data-source' attribute not found. Skipping row.\n")
                continue
            track_name = pattern.sub("", data_source).strip()
            print(f"Extracted Track Name: {track_name}")

            writer.writerow([track_name])
            file.flush()
            print(f"Written to CSV: {track_name}\n")

        except NoSuchElementException:
            print("Required elements not found in row. Skipping row.\n")
            continue
        except Exception as e:
            print(f"Error processing row: {e}. Skipping row.\n")
            continue

def main():
    driver = init_driver()
    dates = generate_date_range(START_YEAR, START_MONTH, END_YEAR, END_MONTH)

    with open(OUTPUT_CSV, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(["track_name"])
        print(f"CSV file '{OUTPUT_CSV}' created with headers.\n")

        for year, month in dates:
            extract_and_write(driver, year, month, writer, file)
            print(f"Waiting for {DELAY_BETWEEN_REQUESTS} seconds...\n")
            time.sleep(DELAY_BETWEEN_REQUESTS)

    driver.quit()
    print("Scraping completed.")

if __name__ == "__main__":
    main()

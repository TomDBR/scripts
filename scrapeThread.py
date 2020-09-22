#!/bin/env python
from bs4 import BeautifulSoup
from scrape_tool import get_formatted_html, get_file
from contextlib import closing
import re
import sys
import os

usage = "./scrapeThread.py [thread] [location] (-t [ext(,ext)])"
def_type = ['png', 'jpg', 'webm', 'gif']
dbg_val = True

def main():
    if len(sys.argv) < 3:
        die("Expected at least 2 arguments!\n{}".format(usage))
    url = sys.argv[1]
    location = sys.argv[2]
    types = sys.argv[5].split(',') if len(sys.argv) == 5 else def_type
    scrapeThread(url, location, types)

def scrapeThread(thread, location, types):
    if not os.path.exists(location):
            os.mkdir(location)
    regex = r'^https?://boards\.4chann?e?l?\.org\/[\w]+\/thread\/\d+$'
    if not re.match(regex, thread):
        die(f"unsupported URL! {thread}")
    if os.path.isdir(location) is None:
        die(f"invalid path URL! {location}")
    html = get_formatted_html(thread)
    if html is None:
        die("scraping URL failed!")
    files = []
    for a in html.find_all('a', class_='fileThumb'):
        file_url = 'http:{}'.format(a.get('href'))
        reg = re.match(r"^http\:.*\/(\d{13})\.(\w+)$", file_url)
        if reg:
            name = reg.group(1)
            ext = reg.group(2)
            if ext in types:
                path = f"{location}/{name}.{ext}"
                if os.access(path, os.W_OK):
                    debug(f"File ({path}) exists, skipping")
                else:
                    debug(f"Downloading {file_url} to {path}")
                    data = get_file(file_url)
                    files.append((data, path))
    if files is None:
        die("No files were found in thread!")
    for i in files:
        data = i[0]
        path = i[1]
        with closing(open(path, "wb")) as f:
            f.write(data)

def die(msg):
    print(msg, file=sys.stderr)
    quit()

def debug(msg): 
    if dbg_val is True:
        print(msg)

if __name__ == "__main__":
    main()

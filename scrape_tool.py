#!/bin/env python 
from requests import get
from requests.exceptions import RequestException
from contextlib import closing
import sys
import re
from bs4 import BeautifulSoup

def get_formatted_html(url):
    try:
        with closing(get(url, stream=True)) as resp:
            if is_good_response(resp):
                return BeautifulSoup(resp.content, 'lxml')
            else:
                log_error("Invalid response status code! (status code: {}, url: {})".format(resp.status_code, url))
                return None
    except RequestException as e:
            log_error('Error during requests to {0} : {1}'.format(url, str(e)))
            return None

def is_good_response(resp):
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200
            and content_type is not None
            and content_type.find('html') > -1)

def get_file(url):
    try:
        img = b""
        with closing(get(url, stream=True)) as resp:
            content_type = resp.headers['Content-Type'].lower()
            if resp.status_code == 200 and (content_type.find('image') > -1 or content_type.find('video') > -1):
                for chunk in resp.iter_content(chunk_size=1024):
                    if chunk:
                        img += chunk
                return img
            else:
                log_error("Invalid response status code! (url: {})".format(url))
                log_error("status code: {}, content type: {}".format(resp.status_code, content_type))
                return None
    except RequestException as e:
            log_error('Error during requests to {0}: {1}'.format(url, str(e)))
            return None

def log_error(e):
    print(e, file=sys.stderr)

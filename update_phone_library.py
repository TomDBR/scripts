#!/bin/env python
import os
import subprocess
import mimetypes
from contextlib import closing
import re

debug = False
music_path = '{}/Music'.format(os.getenv('HOME'))
music_phone_path = '/media/InternalHDD/6TB_WD_HDD/phonemus/Music'

def main():
    # COPY NEW MUSIC FROM SRC TO TARGET
    find_cmd = ['find', '-L', music_path, '-type', 'd', '-links', '2', '!', '-empty']
    subp = subprocess.Popen(find_cmd, stdout=subprocess.PIPE, encoding='UTF-8', text=True)
    directories = subp.communicate()[0].split('\n')
    target_dirs = []
    target_files = []
    for i in directories:
        target = get_target_dir(i)
        if target is None:
            continue
        target_dirs.append(target)
        if not os.path.exists(target):
            os.makedirs(target)
        target_files.append(update_target_dir(i, target))

    # REMOVE FROM TARGET EVERYTHING THAT IS NOT IN SRC ANYMORE
    find_cmd = ['find', music_phone_path, '-type', 'd', '-links', '2' ]
    subp = subprocess.Popen(find_cmd, stdout=subprocess.PIPE, encoding='UTF-8', text=True)
    directories = subp.communicate()[0].split('\n')
    to_be_removed = []
    for i in directories:
        if not i in target_dirs:
            to_be_removed.append(i)
    for i in target_files:
        if i is not None:
            for x in i[1]:
                to_be_removed.append("{}/{}".format(i[0], x))
    with closing(open('./update_phone_library_log.txt', "w")) as f:
        f.write("# THESE FILES DON'T CORRESPOND WITH ANY FILES IN THE SRC DIR, MANUALLY DELETE THEM.\n")
        f.write("\n".join(to_be_removed))


def get_target_dir(src_dir):
    regex = re.match(r"{}\/Music\/(\w+)\/(.+)$".format(os.getenv('HOME')), src_dir)
    if regex is not None:
        target_dir = "{}/{}/{}".format(music_phone_path, regex.group(1), regex.group(2))
        return target_dir
    return None

def update_target_dir(src_dir, target_dir):
    reg_string = r"^(.*)\.\w+$"
    src_files = os.listdir(src_dir)
    target_files = os.listdir(target_dir)
    tmp = []
    for f in target_files:
        regex = re.match(reg_string, f)
        if regex is None:
            continue
        tmp.append(regex.group(1))
    for i in src_files:
        i_full_path = '{}/{}'.format(src_dir, i)
        regex = re.match(reg_string, i)
        fileType = mimetypes.guess_type('{}/{}'.format(src_dir, i))[0]
        if regex is None or fileType is None:
            continue
        if regex.group(1) in tmp:
            log_debug('file exists in target, skipping ({})'.format(i))
            try:
                tmp.remove(regex.group(1))
            except ValueError as e:
                print("item wasn't in list, ignoring. ", e)
            continue

        if fileType == 'audio/x-mpegurl':
            continue
        elif fileType.find('audio') > -1:
            i_target_full_path = '{}/{}.opus'.format(target_dir, regex.group(1))
            print("converting {} to OPUS.".format(i))
            song = convertToOpus(i_full_path)
            if song is None:
                continue
            with closing(open(i_target_full_path, "wb")) as f:
                    f.write(song)
        elif fileType.find('image') > -1:
            i_target_full_path = '{}/{}'.format(target_dir, i)
            cp_cmd = [ 'cp', i_full_path, i_target_full_path ]
            cp_proc = subprocess.Popen(cp_cmd)
            cp_proc.wait()
    return (target_dir, tmp) if len(tmp) > 0 else None


def convertToOpus(song):
        ffmpeg_cmd = [ 'ffmpeg', '-i', song, '-ar', '48000', '-ac', '2', '-acodec', 'libopus', '-ab', '128k', '-vbr', 'on', '-f', 'opus', '-loglevel', 'error', '-' ]
        ffmpeg_proc = subprocess.Popen(ffmpeg_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        song, stderr = ffmpeg_proc.communicate()
        if ffmpeg_proc.returncode == 0:
            return song
        else:
            print("ERROR CODE: {}. {}".format(ffmpeg_proc.returncode, stderr.decode("utf-8")))
            return None
def log_debug(msg):
    if debug:
        print(msg)


if __name__ == "__main__":
    main()

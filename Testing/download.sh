#!/bin/bash


if [[ "$#" -ne 1 ]]
then
	echo "usage: $0 <URL>"
	exit 1
fi

URL="$1"
echo "Cleaning URL: $URL"
CLEANED=$(sh ./extract_url.sh $URL)
echo "Cleaned URL: $CLEANED"
echo "Attempting Download..."
USER=$(echo $CLEANED | sed 's@[a-zA-Z]*:\/\/github\.com\/\([a-zA-Z]*\)\/[a-zA-Z]*@\1@' )
FILENAME="$USER.zip"
echo $FILENAME
curl -L -o $FILENAME $CLEANED
echo "Downloaded repository as: $FILENAME"
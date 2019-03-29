#!/bin/bash


if [[ "$#" -ne 1 ]]
then
	echo "usage: $0 <URL>"
	exit 1
fi

# Extract the URL
URL="$1"
CLEANED=$(sh ./extract_url.sh $URL)

# Download the file to <username>.zip
USER=$(echo $CLEANED | sed 's@[a-zA-Z]*:\/\/github\.com\/\([a-zA-Z]*\)\/\([a-zA-Z]*\)@\1_\2@' )
FILENAME="$USER.zip"
curl -L -o $FILENAME $CLEANED &>/dev/null
echo $FILENAME

#!/bin/bash
REPO_DIR="repos"


if [[ "$#" -ne 1 ]]
then
	echo "usage: $0 <URL Links>"
	exit 1
fi

URLS="$1"

# Make sure our directoies are set
if [[ ! -d "$REPO_DIR" ]]
then
    mkdir "$REPO_DIR"
fi

while IFS="" read -r URL || [[ -n "$URL" ]]
do
  echo "Downloading: [$URL]"
  FILENAME=$(sh ./download.sh $URL)
  mv $FILENAME "$REPO_DIR/$FILENAME"
  echo "Done!"
done < $URLS
echo "Repositories downloaded to ./$REPO_DIR/"

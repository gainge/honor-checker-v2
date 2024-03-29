#!/bin/bash
REPO_DIR="repos"


if [[ "$#" -eq 0 ]]
then
	echo "usage: $0 <URL Links File> [TARGET DIRECTORY]"
	exit 1
fi

URLS="$1"

# Check Url file existence
if [[ ! -f $URLS ]]; then
  echo "Could not locate urls file: [$URLS], exiting"
  exit 1
fi

# Attempt to extract a different target directory
shift # Shift ops down
if [[ "$#" -ge 1 ]]; then
	REPO_DIR="$1"
else
  echo "No repo directory specified, using [$REPO_DIR]"
fi

# Make sure our directoies are set
if [[ ! -d "$REPO_DIR" ]]
then
    mkdir "$REPO_DIR"
fi

# Extract each of the urls given in the config file
while IFS="" read -r URL || [[ -n "$URL" ]]
do
  echo -e "\tCloning: [$URL]"
  FILENAME=$(./download.sh $URL $REPO_DIR)
  echo -e "\tDone! [$FILENAME]"
	echo
done < $URLS
echo "Repositories downloaded to ./$REPO_DIR/"

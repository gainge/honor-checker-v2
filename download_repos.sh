#!/bin/bash
REPO_DIR="repos"


if [[ "$#" -eq 0 ]]
then
	echo "usage: $0 <URL Links File> [TARGET DIRECTORY]"
	exit 1
fi

URLS="$1"

# Attempt to extract a different target directory
shift # Shift ops down
if [[ "$#" -ge 1 ]]; then
	REPO_DIR="$1"
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

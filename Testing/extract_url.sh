#!/bin/bash

URL="$1"
PARSED=$(echo $URL | sed 's@\(http[s]*:\/\/github\.com\/[a-zA-Z]*\/[a-zA-Z]*\)[\/]*.*@\1@')
echo $PARSED



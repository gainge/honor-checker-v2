#!/bin/bash


# Handle some sick arguments
c=false
v=false
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
      -v|--verbose)
      v=true
      shift # past flag I guess
      ;;
      -c|--count)
      c=true
      shift # past flag again
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Check usage
if [[ "$#" -ne 2 ]]; then
  echo "USAGE: $0 [-c -v] <FILE> <PATTERNS>"
fi

# Read in arguments
FILE=$1
PATTERNS=$2

if [[ "$c" == false ]] || [[ "$v" == true ]]; then
  grep -i -F -o -f $PATTERNS $FILE | sort | uniq -c | sed 's/^ *.[[:blank:]]//'
fi

if [[ "$c" == true ]] || [[ "$v" == true ]]; then
  echo $(grep -i -F -o -f $PATTERNS $FILE | sort | uniq -c | sed 's/^ *//' | wc -l)
fi

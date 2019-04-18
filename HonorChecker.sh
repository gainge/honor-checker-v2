#!/bin/bash

# TODO: Eventuall Add semester Support...  All you'd be doing is changing how you route student code

ALLJAVA="alljava.txt"
CLEANED_JAVA="cleaned.txt"
NOISE="noise.txt"
URLS="urls.txt"

STUDENT_CODE="student-code-directories"
REPO_CODE="repos"
RESULTS_DIR="results"
BATCH_DIR="batch"


# Pull options from the arguments
opts=false

clean=false
extract=false
download=false
compare=false
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
      -e|-x|--extract)
      extract=true
      shift # past flag I guess
      ;;
      -d|--download)
      download=true
      shift
      ;;
      -c|--clean)
      clean=true
      shift
      ;;
      -m|-p|--compare)
      compare=true
      shift
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

[[ "$clean" == true ]] || [[ "$extract" == true ]] || [[ "$download" == true ]] || [[ "$compare" == true ]]; opts=$?
echo $opts

set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ "$#" -ne 1 ]]; then
  echo "usage: $0 [options] <WORKING DIRECTORY>"
fi

WORKING_DIRECTORY="$1"
WORKING_DIRECTORY=${WORKING_DIRECTORY%%/} # Strip trailing slashes

if [[ ! -d $WORKING_DIRECTORY ]]; then
  echo "Invalid directory supplied [$WORKING_DIRECTORY], exiting"
  exit 1
fi

# Aight, now we're good to roll
# First let's make sure our environment is set up
STUDENT_CODE="$WORKING_DIRECTORY/$STUDENT_CODE"
REPO_CODE="$WORKING_DIRECTORY/$REPO_CODE"
RESULTS_DIR="$WORKING_DIRECTORY/$RESULTS_DIR"
BATCH_DIR="$WORKING_DIRECTORY/$BATCH_DIR"
NOISE="$WORKING_DIRECTORY/$NOISE"
URLS="$WORKING_DIRECTORY/$URLS"

# Verify Directories are all set
if [[ ! -d $BATCH_DIR ]] && ( [[ "$extract" == true ]] || [[ "$opts" == 1 ]] ); then
  echo "Batch directory [$BATCH_DIR] not found, did you extract the zip file?"
  exit 1
fi

if [[ ! -d $REPO_CODE ]]; then
  echo "Creating Repo Code Directory [$REPO_CODE]"
  mkdir $REPO_CODE
fi

if [[ ! -d $STUDENT_CODE ]]; then
  echo "Creating Student Code Directory [$STUDENT_CODE]"
  mkdir $STUDENT_CODE
fi

# Make sure all the necessary files are set
if [[ ! -f $URLS ]] && ( [[ "$download" == true ]] || [[ "$opts" == 1 ]] ); then
  echo "Repo URL file [$URLS] not found, creating empty file"
  touch $URLS
fi

if [[ ! -f $NOISE ]] && ( [[ "$clean" == true ]] || [[ "$opts" == 1 ]] ); then
  echo "Noise file [$NOISE] not found, creating empty file"
  touch $NOISE
fi









# Ok, now we can actually start doing useful work


# 1) Download repositories to the correct directory
./download_repos "$URLS" "$REPO_CODE"

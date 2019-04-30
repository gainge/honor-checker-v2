#!/bin/bash


printHeader() {
  local MESSAGE="$1"
  local len=${#MESSAGE}

  HEADER_LEN=$(($len + 4))

  printf '\n'
  printf '=%.0s' $( seq 1 $HEADER_LEN )
  printf "\n"

  printf "= $MESSAGE ="
  printf "\n"

  printf '=%.0s' $( seq 1 $HEADER_LEN )

  echo
}


showHelp() {
  echo "options:
  [-e, -x, --extract]   Extract student code from batch directory
  [-d, --download]      Download github repos in url file
  [-c, --clean]         Clean all code, student and repo
  [-m, -p, --compare]   Compare codebases (student to repo by default)
  [-s, --students]      Also compare students to other students

  [-h, --help]          Show help
  "
}


# TODO: Eventually Add semester Support...  All you'd be doing is changing how you route student code

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
students=false
hlp=false
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
      -s|--students)
      students=true
      shift
      ;;
      -h|--help)
      hlp=true
      shift
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save the non-config arg in an array for later
      shift # past argument
      ;;
  esac
done

# Check help
if [[ "$hlp" == true ]]; then
  showHelp
  exit 1
fi


# Determine if any options were given
[[ "$clean" == true ]] || [[ "$extract" == true ]] || [[ "$download" == true ]] || [[ "$compare" == true ]]; opts=$?
echo $opts

set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ "$#" -ne 1 ]]; then
  echo "usage: $0 [options] <WORKING DIRECTORY>"
  showHelp
  exit 1
fi

WORKING_DIRECTORY="$1"
WORKING_DIRECTORY=${WORKING_DIRECTORY%%/} # Strip trailing slashes

if [[ ! -d $WORKING_DIRECTORY ]]; then
  echo "Invalid working directory supplied [$WORKING_DIRECTORY], exiting"
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
  # Put in a temporary line so the cleaning script doesn't erase everything
  echo "(Fill with noise patterns)" >> $NOISE
fi




# Ok, now we can actually start doing useful work


# 1) Download repositories to the correct directory
if [[ "$download" == true ]] || [[ "$opts" == 1 ]]; then
  printHeader "Dowloading repositories"
  ./download_repos.sh "$URLS" "$REPO_CODE"
fi


# 2) Extract student code into correct directory
if [[ "$extract" == true ]] || [[ "$opts" == 1 ]]; then
  printHeader "Extracting Student Code"
  ./extract_all.sh "$BATCH_DIR" "$STUDENT_CODE"
fi


# 3) Clean the java files in preparation for comparison
if [[ "$clean" == true ]] || [[ "$opts" == 1 ]]; then
  printHeader "Cleaning Code"
  ./clean_all.sh "$REPO_CODE"
  ./clean_all.sh "$STUDENT_CODE"
fi

# 4) Compare the files!  Wahoo!
if [[ "$compare" == true ]] || [[ "$opts" == 1 ]]; then
  printHeader "Comparing Codebases"
  if [[ "$students" == true ]]; then
    ./compare_all.sh "$STUDENT_CODE" "$REPO_CODE" "$RESULTS_DIR" -s
  else
    ./compare_all.sh "$STUDENT_CODE" "$REPO_CODE" "$RESULTS_DIR"
  fi
  
fi












# Then we done!

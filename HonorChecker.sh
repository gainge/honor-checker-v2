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
  [-r n, --random n]    Use random codebase subset of size n
  [-s, --students]      Also compare students to other students
  [-i, --results]       Start local server to show results

  [--remove]            Clear out existing extracted/cleaned code

  [-h, --help]          Show help
  "
}


# TODO: Eventually Add semester Support...  All you'd be doing is changing how you route student code

ALLJAVA="alljava.txt"
CLEANED_JAVA="cleaned.txt"
NOISE="noise.txt"
LINE_NOISE="line_noise.txt"
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
results=false
remove=false
random=false
num="n/a"

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
      -r|--random)
      random=true
      num="$2"
      shift # past the flag
      shift # past the arg
      ;;
      -s|--students)
      students=true
      shift
      ;;
      -h|--help)
      hlp=true
      shift
      ;;
      -i|--results)
      results=true
      shift
      ;;
      --remove)
      remove=true
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

# Prevent back navigation + invalid params
if [[ ! -d $WORKING_DIRECTORY ]] || [[ "$WORKING_DIRECTORY" == *"../"* ]]; then
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
LINE_NOISE="$WORKING_DIRECTORY/$LINE_NOISE"
URLS="$WORKING_DIRECTORY/$URLS"

# -- Verify Directories are all set -- #
if [[ ! -d $BATCH_DIR ]] && ( [[ "$extract" == true ]] || [[ "$opts" == 1 ]] ); then
  echo "Batch directory [$BATCH_DIR] not found, did you extract the zip file?"
  exit 1
fi

# Check for remove, ask for confirmation
if [[ "$remove" == true ]]; then
  read -p "[--remove] specified.  Are you sure you want to remove extracted code? (y/N): "
  echo    
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      echo "exiting..."
      exit 1
  fi

  # Otherwise we can just remove this stuff 
  if [[ -d $REPO_CODE ]]; then
    echo "Removing Repo Directory..."
    rm -rf $REPO_CODE
  fi

  if [[ -d $STUDENT_CODE ]]; then
  echo "Removing Student Code Directory..."
    rm -rf $STUDENT_CODE
  fi
fi

if [[ ! -d $REPO_CODE ]]; then
  echo "Creating Repo Code Directory [$REPO_CODE]"
  mkdir $REPO_CODE
fi

if [[ ! -d $STUDENT_CODE ]]; then
  echo "Creating Student Code Directory [$STUDENT_CODE]"
  mkdir $STUDENT_CODE
fi

# -- Make sure all the necessary files are set -- #
if [[ ! -f $URLS ]] && ( [[ "$download" == true ]] || [[ "$opts" == 1 ]] ); then
  echo "Repo URL file [$URLS] not found, creating empty file"
  touch $URLS
fi

if [[ ! -f $NOISE ]] && ( [[ "$clean" == true ]] || [[ "$opts" == 1 ]] ); then
  echo "Noise file [$NOISE] not found, creating template file"
  touch $NOISE
  # Put in a temporary line so the cleaning script doesn't erase everything
  echo "(Fill with noise patterns)" >> $NOISE
fi

if [[ ! -f $LINE_NOISE ]] && ( [[ "$clean" == true ]] || [[ "$opts" == 1 ]] ); then
  echo "Noise file [$LINE_NOISE] not found, creating template file"
  touch $LINE_NOISE
  # Again we need a temp line so things don't get nuked
  echo "(Fill with exact match line noise)" >> $LINE_NOISE
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
  ./clean_all.sh "$REPO_CODE" "$WORKING_DIRECTORY"
  ./clean_all.sh "$STUDENT_CODE" "$WORKING_DIRECTORY"
fi

# 4) Compare the files!
if [[ "$compare" == true ]] || [[ "$opts" == 1 ]]; then
  printHeader "Comparing Codebases"
  # initialize the arguments
  args=("$STUDENT_CODE" "$REPO_CODE" "$RESULTS_DIR")

  # Pass in student flag if applicable
  if [[ "$students" == true ]]; then
    args+=("--students")
  fi

  # Add on the random flag and our subset size
  if [[ "$random" == true ]]; then
    args+=("--random")
    args+=("$num")
  fi

  ./compare_all.sh ${args[@]}
fi

echo -e "\nFinished!"

# 5) If configured, display the results via local server
if [[ "$results" == true ]]; then
  printHeader "Starting Local Server"
  ./start_server.sh 8000
fi

# Then we're done!

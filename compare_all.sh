#!/bin/bash

getCleanedJava() {
  local DIR=$1
  # Lol we actually don't need this anymore either
  local PARENT=$(echo $DIR | cut -d/ -f1)
  # Netid is no longer necessary, as all cleaend java files are uniformly named
  # local NETID=${DIR#$PARENT/}
  local CLEANED_SOURCE="$DIR/cleaned.txt"

  echo $CLEANED_SOURCE
}

getNetID() {
  local DIR=$1
  local NETID=${DIR#$STUDENT_CODE_DIR/}
  echo $NETID
}

getMatches() {
  local FILE1=$1
  local FILE2=$2

  # Check the matches
  local MATCHES=$(./compare_java.sh "$FILE1" "$FILE2")

  echo $MATCHES
}

getNumMatches() {
  local FILE1=$1
  local FILE2=$2

  # Check the match count using our comparison script
  local NUM_MATCHES=$(./compare_java.sh "-c" "$FILE1" "$FILE2")

  echo $NUM_MATCHES
}

compareFiles() {
  local RESULTS=$1
  local FILE1=$2
  local FILE2=$3

  # Compare the files
  # local MATCHES=$(getMatches $FILE1 $FILE2)
  # local NUM_MATCHES=$(echo "$MATCHES" | wc -l)
  local NUM_MATCHES=$(getNumMatches $FILE1 $FILE2)

  # Write the number to the output file
  echo -n "$NUM_MATCHES," >> $RESULTS
}

usage() {
  echo "USAGE: $0 [options] <BASE CODE DIR> <PATTERN CODE DIR>"
}

showHelp() {
  echo "options:
  [-s, --students]      Compare students to other students
  [-r n, --random n]    Use random subset of size n from both base and pattern dirs

  [-h, --help]          Show help
  "
}


# Check for optional student flag
students=false
hlp=false
random=false
num="n/a"
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
      -s|--students)
      students=true
      shift # past flag I guess
      ;;
      -h|--help)
      hlp=true
      shift
      ;;
      -r|--random)
      random=true
      num="$2"
      shift # past the flag
      shift # past the arg
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

# Check help statement
if [[ "$hlp" == true ]]; then
  showHelp
  exit 1
fi

set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ "$#" -lt 2 ]]; then
  usage
  exit 1
fi

STUDENT_CODE_DIR="$1"
REPO_DIR="$2"
RESULT_DIR="./results"

# Attempt to overwrite defaults
if [[ "$#" -eq 3 ]]; then
  RESULT_DIR="$3"
fi

# Check the args to make sure they're valid
if [[ ! -d $STUDENT_CODE_DIR ]]; then
  echo "Could not locate directory: [$STUDENT_CODE_DIR], exiting"
  exit 1
fi

if [[ ! -d $REPO_DIR ]]; then
  echo "Could not locate directory: [$REPO_DIR], exiting"
  exit 1
fi

# Find all entries in each directory, repos and students
REPOS=( $(find $REPO_DIR -maxdepth 1 \( ! -wholename $REPO_DIR \) -type d) )
DIRECTORIES=( $(find $STUDENT_CODE_DIR -maxdepth 1 \( ! -wholename $STUDENT_CODE_DIR \) -type d) )

REPO_INDICES=($(seq 0 1 $(expr "${#REPOS[@]}" - 1)))
STUDENT_INDICES=($(seq 0 1 $(expr "${#DIRECTORIES[@]}" - 1)))

# If they've configured a random sampling, initialize the indices accordingly
if [[ "$random" == true ]]; then
  # Check for invalid param
  oob1=$(expr "$num" ">" "${#DIRECTORIES[@]}")
  oob2=$(expr "$num" ">" "${#REPOS[@]}")
  oob3=$(expr "$num" "<" 1)
  if [[ ! "$num" =~ ^[0-9][0-9]*$ ]] || [[ oob1 -eq 1 ]] || [[ oob2 -eq 1 ]] || [[ oob3 -eq 1 ]]; then
    echo "Invalid Sequence Length [$num], exiting..."
    usage
    exit 1
  fi

  echo "Randomizing Codebases and selecting [$num] entries"
  # Do a simple reassignment
  REPO_INDICES=($(printf "%s\n" "${REPO_INDICES[@]}" | shuf -n $num))
  STUDENT_INDICES=($(printf "%s\n" "${STUDENT_INDICES[@]}" | shuf -n $num))
fi

# Create the spreadsheet to store our results
RESULTS="$RESULT_DIR/results.csv"

# prepare the testing directory
if [[ -d $RESULT_DIR ]]; then
  rm -r $RESULT_DIR
fi
mkdir $RESULT_DIR

if [[ -f $RESULTS ]]; then
  rm $RESULTS
fi

touch $RESULTS

# Write out the header for the results file
# Write the legend/key
echo -n "NetID/Comparison," >> $RESULTS

# Write out each repository to the header
len=${#REPO_INDICES[@]}
for ((i = 0; i < $len; ++i)) do
  index=${REPO_INDICES[$i]}
  REPO=${REPOS[$index]}s

  echo -n "$REPO," >> $RESULTS
done

# If comparing students was enabled
if [[ "$students" == "true" ]]; then
  # Do the same for each student, in reverse order
  len=${#STUDENT_INDICES[@]}
  for ((i = $len - 1; i >= 0; --i)) do
    index=${STUDENT_INDICES[$i]}
    NETID=$(getNetID ${DIRECTORIES[$index]})

    echo -n "$NETID," >> $RESULTS
  done
fi

# Remove last traling comma
truncate -s-1 $RESULTS

# End the header row
echo -ne "\n" >> $RESULTS

TOTAL=${#STUDENT_INDICES[@]}

# Finally, perform the comparison of the files against eachother
for ((i = 0; i < $TOTAL; ++i)) do
  index=${STUDENT_INDICES[$i]}
  CURRENT_DIR=${DIRECTORIES[$index]}
  # Extract the NETID from the file path
  NETID=$(getNetID $CURRENT_DIR)

  echo "Currently Processing: $NETID"
  echo -n "$NETID," >> $RESULTS # Write out net id for this row's results

  CLEANED_SOURCE=$(getCleanedJava $CURRENT_DIR)

  # First compare against the repositories
  for ((j = 0; j < ${#REPO_INDICES[@]}; ++j)) do
    repo_index=${REPO_INDICES[$j]}
    CURRENT_REPO=${REPOS[$repo_index]}
    # Compare the two files and log the result
    OTHER_CLEANED=$(getCleanedJava $CURRENT_REPO)

    compareFiles $RESULTS $CLEANED_SOURCE $OTHER_CLEANED
  done

  # Following repositories, compare against the other students
  if [[ "$students" == "true" ]]; then
    for ((j = $TOTAL - 1; j > i; --j)) do
      # don't compare students against themselves
      if [[ j == i ]]; then
        echo -n "-1" >> $RESULTS
      else
        student_index=${STUDENT_INDICES[$j]}
        CURRENT_STUDENT=${DIRECTORIES[$student_index]}

        OTHER_CLEANED=$(getCleanedJava $CURRENT_STUDENT)

        compareFiles $RESULTS $CLEANED_SOURCE $OTHER_CLEANED
      fi
    done
  fi


  # Legit, there's definitely a way to refactor this, but idk if it's that useful given the
  #   backwards iteration over the students array

  # But, anyway, at this point in the program we should be done with the current student!
  # Just finish off the current line of the results file and call it a day

  # Remove last comma
  truncate -s-1 $RESULTS
  # add in the line break
  echo -ne "\n" >> $RESULTS
done

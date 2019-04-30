#!/bin/bash


showHelp() {
  echo "options:
  [-v, --verbose]       Display matches as well as the total count as the last line
  [-c, --count]         Only display the number of matches found

  [-h, --help]          Show help
  "
}

# Handle some sick arguments
c=false
v=false
hlp=false
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
      -h|--help)
      hlp=true
      shift
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

# Check that help usage baby
if [[ "$hlp" == true ]]; then
  showHelp
  exit 1
fi

set -- "${POSITIONAL[@]}" # restore positional parameters

# Check usage
if [[ "$#" -ne 2 ]]; then
  echo "USAGE: $0 [options] <FILE> <PATTERNS>"
  showHelp
  exit 1
fi

# Read in arguments
FILE=$1
PATTERNS=$2

if [[ "$c" == false ]] || [[ "$v" == true ]]; then
  grep -i -F -o -f $PATTERNS $FILE | sort | uniq -c | sed 's/^ *[0-9][0-9]*[[:blank:]]//'
fi

if [[ "$c" == true ]] || [[ "$v" == true ]]; then
  echo $(grep -i -F -o -f $PATTERNS $FILE | sort | uniq -c | sed 's/^ *//' | wc -l)
fi

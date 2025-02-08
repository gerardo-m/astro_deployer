#! /bin/bash

# First make sure parameters list is not empty
if [[ $# == 0 ]]; then
  echo "Expected 1 or more parameters. Found 0"
  exit 1
fi

# Display help if requested
if [[ $1 == "-h" ]]; then
  echo "HELP <adep-add>"
  echo 
  echo "SYNTAX"
  echo "  adep-add [OPTION] PROJECT_DIR DEPLOY_DIR [FLAGS]"
  echo "    PROJECT_DIR   - Directory of the Astro project"
  echo "    DEPLOY_DIR    - Directory where the static files will be deployed"
  echo
  echo "AVAILABLE OPTIONS"
  echo "  Option  Action"
  echo "  -h      Show this help"
  exit 0
fi

PROJECT_DIR=$1
DEPLOY_DIR=$2
LABEL=$3

# Make sure the directories exists
if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "Directory $PROJECT_DIR doesn't exist"
  exit 1
fi
if [[ ! -d "$DEPLOY_DIR" ]]; then
  echo "Directory $DEPLOY_DIR doesn't exist"
  exit 1
fi

# Make sure the user has write permissions in the deploy directory

if [[ ! -w "$DEPLOY_DIR" ]]; then
  echo "User doesn't have permissions to write on $DEPLOY_DIR"
  exit 1
fi

# If the program data directory doesn't exist, create it

if [[ ! -d ~/.adep ]]; then
  (cd ~ || exit 1; mkdir ".adep")
fi

# If the program data file doesn't exist, create it

if [[ ! -e ~/.adep/data ]]; then
  (cd ~/.adep || exit 1; touch "data")
  
fi

# If there is already a record with the same deploy directory or label, Ask to replace it

declare -A records
EXISTING_LABEL=""
EXISTING_DIR=""
while read -r line; do
  if [[ -z "$line" ]]; then
    continue
  fi
  # string="apple,banana,orange"
# IFS=',' read -ra arr <<< "$string"
  IFS=';' read -ra val <<< "$line"
  records["${val[0]}"]="${val[1]};{$val[2]}"
  if [[ "${val[0]}" == "$LABEL" ]]; then
    EXISTING_LABEL="${val[0]}"
    continue
  fi
  if [[ "${val[2]}" == "$DEPLOY_DIR" ]]; then
    EXISTING_DIR="${val[0]}"
  fi
done < ~/.adep/data

if [[ "$EXISTING_LABEL" != "" || "$EXISTING_DIR" != "" ]]; then
  printf "Existing records where found, replace them? (Y/N): "
  read REPLACE_EXISTING
  # Replace the existing records and rewrite the whole file
  unset records["$EXISTING_DIR"]
  records["$EXISTING_LABEL"]="$PROJECT_DIR;$DEPLOY_DIR"
  # Rewrite file TODO
  exit 0
fi

# Register the new site
printf '%s;%s;%s\n' "$LABEL" "$PROJECT_DIR" "$DEPLOY_DIR" >> ~/.adep/data

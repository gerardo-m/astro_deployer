#! /bin/bash

# Display help if requested
if [[ $1 == "-h" ]]; then
  echo "HELP <adep>"
  echo 
  echo "SYNTAX"
  echo "  adep [OPTION] [LABEL]"
  echo "    LABEL    - Optional label if you want to deploy a single project"
  echo
  echo "AVAILABLE OPTIONS"
  echo "  Option  Action"
  echo "  -h      Show this help"
  exit 0
fi

if [[ "$1" == -* ]]; then
  echo "$1 option not recognized"
  exit 1
fi


# Get the projects list

while read -u 3 -r line; do
  if [[ -z "$line" ]]; then
    continue
  fi
  IFS=';' read -ra val <<< "$line"
  # For every project
  LABEL="${val[0]}"
  # Remove backslashes
  PROJECT_DIR=$(echo "${val[1]}" | sed 's:/*$::')
  DEPLOY_DIR=$(echo "${val[2]}" | sed 's:/*$::')

  SHOULD_CONTINUE=1
  if [[ $# -gt 0 ]]; then
    for i in $@; do
      if [[ $i == $LABEL ]]; then
        SHOULD_CONTINUE=0
        break
      fi
    done
  else
    SHOULD_CONTINUE=0
  fi

  if [[ $SHOULD_CONTINUE -eq 1 ]]; then
    continue
  fi

  if [[ ! -d "${PROJECT_DIR}/.git" ]]; then
    echo "Project dir doesn't have a git repo"
    read -r -p $'Provide the git origin url: ' GIT_REPO
    while [[ -z "$GIT_REPO" ]]; do
      read -r -p $'\nPlease enter a non blank git repo\ngit origin url: ' GIT_REPO
    done
    # TODO add the repo to the data file
    #     # checkout the repo
    echo "Checking out $GIT_REPO"
    $(cd "$PROJECT_DIR" || exit 1 ; git ls-remote "$GIT_REPO" || exit 1; git init . && git remote add  -f origin $GIT_REPO && git checkout master);
    if [[ $? == 1 ]]; then
      echo "git repo not found"; exit 1
    fi
  fi

  #   Pull the code
  echo "Pulling the code for $LABEL..."
  (cd $PROJECT_DIR || exit 1; git pull)
  #   Deploy
  echo "Deploying to $DEPLOY_DIR"
  (cd $PROJECT_DIR && npm install && npm run build && cp -a dist/. $DEPLOY_DIR) || exit 1

  
done 3< ~/.adep/data

echo "Success"

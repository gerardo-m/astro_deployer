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

while read -r line; do
  if [[ -z "$line" ]]; then
    continue
  fi
  IFS=';' read -ra val <<< "$line"
  # For every project
  LABEL="${val[0]}"
  PROJECT_DIR="${val[1]}"
  DEPLOY_DIR="${val[2]}"
  #   Make sure there is a git repo TODO, is not working
  # $(
  #   cd $PROJECT_DIR;
  #   if [[ ! -d ./.git ]]; then
  #     echo "Project dir doesn't have a git repo"
  #     printf "Provide the git origin url: "
  #     read -r GIT_REPO
  #     printf "whaty"
  #     while [[ -z "$GIT_REPO" ]]; do
  #       read -r -p $'\nPlease enter a non blank git repo\ngit origin url: ' GIT_REPO
  #     done
  #     # TODO add the repo to the data file
  #     # checkout the repo
  #     echo "Checking out $GIT_REPO"
  #     git init . && git remote add  -f origin $GIT_REPO && git checkout master || exit 1
  #   fi
  # )
  #   Pull the code
  echo "Pulling the code for $LABEL..."
  (cd $PROJECT_DIR || exit 1; git pull)
  #   Deploy
  echo "Deploying to $DEPLOY_DIR"
  (cd $PROJECT_DIR && npm install && npm run build && cp -a dist/. $DEPLOY_DIR) || exit 1
done < ~/.adep/data

echo "Success"
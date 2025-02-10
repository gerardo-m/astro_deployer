# ASTRO DEPLOYER

The goal of this scripts is to deploy an static Astro site
on another directory locally.

## Why?

Because I have a server in my local network that doesn't
have a dedicated ip address, so I can't setup an existing
CD solution.

And because I wanted to do something with bash

## Setup

- Copy the adep.sh and adep-add.sh file into /opt/adep/
- Make them executable with
```
sudo chmod +x adep.sh
sudo chmod +x adep-add.sh
```
- Add them to the path by adding this to your .bashrc file
```
export PATH="$PATH:/opt/adep"
```
- Restart your shell

## Execution

Run the following to know how to add projects to the data file
```
adep-add.sh -h
```

Basically you have to run this for all your projects
```
adep-add.sh /path/to/project /path/to/destination label
```

Then you just run 
```
adep.sh
```

And all your projects will be pulled and deployed.

## TODO

- Add a couple of things to the data file: git repo, flags
- Check if the repo exist before running the script
- Replace existing projects when duplicates are sent
- Option to remove projects

## Data file Overview

The file data is located at ~/.adep/data

The file contains a row for every project with the following
fields separated by a semicolon:

- label
- project directory
- deploy directory

## THIS IS STILL A WORK IN PROGRESS
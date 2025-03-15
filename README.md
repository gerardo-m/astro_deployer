# ASTRO DEPLOYER

The goal of this scripts is to deploy an static Astro site
on another directory locally.

## Why?

Because I have a server in my local network that doesn't
have a dedicated ip address, so I can't setup an existing
CD solution.

And because I wanted to do something with bash

## Install

Just execute the installer.sh script, to do it automatically
just run

```
sudo wget https://raw.githubusercontent.com/gerardo-m/astro_deployer/refs/heads/master/installer.sh
sudo chmod +x installer.sh
./installer.sh
```

The installer script is just copying the other scripts into /opt,
making them executable and adding the directory to the PATH

You can do this manually:

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

### Adding projects

Run the following to know how to add projects to the data file
```
adep-add.sh -h
```

Basically you have to run this for all your projects
```
adep-add.sh /path/to/project /path/to/destination label
```

### Deploying

To deploy all your projects just run
```
adep.sh
```

If you want to deploy a single project run
```
adep.sh <project-label>
```

With the label of the project you want to deploy

## TODO

- Add a couple of things to the data file: git repo, flags
- Check if the repo exist before running the script
- Option to remove projects
- Basically a lot of edge cases and handle things that could go wrong

## Data file Overview

The data file is located at ~/.adep/data

The file contains a row for every project with the following
fields separated by a semicolon:

- label
- project directory
- deploy directory

## THIS IS STILL A WORK IN PROGRESS

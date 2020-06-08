#!/bin/bash

# Create Ansible Role Directory Structure
# pass in singluar string arugment
# ./ansible-create-template.sh <string>
if [ -z $1 ]; then
    echo "Must supply a string argument"
    exit 1
fi

ANSIBLE_DIRECTORY="ansible-$1"

# create role directory
if [ -d "$ANSIBLE_DIRECTORY" ]; then
    echo "Directory already exists at $PWD/$ANSIBLE_DIRECTORY, exiting..."
    exit 1
else
    mkdir "$ANSIBLE_DIRECTORY"
fi

# Create Defaults
mkdir -p "$ANSIBLE_DIRECTORY/defaults"
touch "$ANSIBLE_DIRECTORY/defaults/main.yml"

# Create Handlers
mkdir -p "$ANSIBLE_DIRECTORY/handlers"
touch "$ANSIBLE_DIRECTORY/handlers/main.yml" 

# Create Tasks
mkdir -p "$ANSIBLE_DIRECTORY/tasks"
touch "$ANSIBLE_DIRECTORY/tasks/main.yml"

# Create README.md
touch $ANSIBLE_DIRECTORY/README.md

echo "Created $ANSIBLE_DIRECTORY!"

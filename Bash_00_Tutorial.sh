#!/bin/bash
echo 'Hello World'

# Create a name variable
name=George
# Substitute the variable name with your own
echo "My name is $name"

# What about if you want to have a command in the variable
command_string=`ls`
# echo "Files" $command_string

# Backslash to escape special character
price_per_apple=5
echo "The price of an Apple is: \$HK $price_per_apple"

# Put a variable has spaces inside double quotes
# to preserve the spaces
greeting='Hello        world!'
echo $greeting" now with spaces : $greeting"

# Programming problem:
# Create a birthdate variable, Create an age variable
# Convert your birthdate into 01 JAN 2019 format using date command.
# BIRTHDATE="Jan 1, 2000"
# Presents=10
# BIRTHDAY=`date -d "$BIRTHDATE" +%A`
# echo "$BIRTHDAY"

# Review and Question Chapter 01:
# https://www.learnshell.org/en/Variables
# -- How to print hello world in Bash?
# -- How to Create a variable string?
# -- How to use an variable in print?
# -- How to have a command in the variable?
# -- How to escape special character?
# -- How to preserve white spaces in string variable?
# -- How to convert date (What is the command)?
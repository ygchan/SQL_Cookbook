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
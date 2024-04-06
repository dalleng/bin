#!/bin/bash

# Check if exactly two arguments are given
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.mov output.gif"
    exit 1
fi

# Assign the first argument to input variable
INPUT=$1

# Assign the second argument to output variable
OUTPUT=$2

# Execute the ffmpeg command with parameters
ffmpeg -i "$INPUT" -vf "fps=30,scale=1080:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$OUTPUT"

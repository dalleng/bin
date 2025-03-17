#!/bin/bash

# This script converts QuickTime screen recordings in .mov format to animated .gif format.
# It takes two arguments: the input .mov file and the output .gif filename.

# Check if exactly two arguments are given
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input.mov output.gif"
    exit 1
fi

# Assign the first argument to input variable (the .mov file)
INPUT=$1

# Assign the second argument to output variable (the desired .gif file)
OUTPUT=$2

# Execute the ffmpeg command with parameters to convert .mov to .gif
ffmpeg -i "$INPUT" -vf "fps=30,scale=1080:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$OUTPUT"
# The ffmpeg command breakdown:
# - -i "$INPUT" specifies the input file.
# - -vf specifies the filter chain:
#   - fps=30 sets the frame rate of the output GIF to 30 frames per second.
#   - scale=1080:-1 maintains the aspect ratio while setting the width to 1080 pixels.
#   - flags=lanczos uses the Lanczos resampling algorithm for better quality.
#   - split[s0][s1] splits the input into two streams for palette generation and usage.
#   - [s0]palettegen[p] creates a palette from the first split stream.
#   - [s1][p]paletteuse applies the generated palette to the second split stream to optimize GIF colors.
# - -loop 0 makes the GIF loop indefinitely.

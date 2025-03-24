#!/bin/bash

# requires
# brew install ffmpeg
# brew install atomicparsley

# Set the name of the cover image file to embed (must be JPG or PNG)
COVER_IMAGE="cover.jpg"

# Check that the cover image exists
if [[ ! -f "$COVER_IMAGE" ]]; then
  echo "Error: Cover image '$COVER_IMAGE' not found in current directory."
  exit 1
fi

# Loop through all .flac files in the current directory
for f in *.flac; do
  # Skip if no .flac files are found
  [[ -e "$f" ]] || { echo "No .flac files found."; exit 0; }

  # Remove .flac extension and set output file name
  base="${f%.flac}"
  output="${base}.m4a"

  echo "Converting: $f → $output"

  # Step 1: Convert FLAC to ALAC (Apple Lossless) in M4A container
  # Only include the audio stream
  # Copy metadata from the original file
  ffmpeg -i "$f" \
         -map 0:a \
         -map_metadata 0 \
         -c:a alac \
         "$output"

  # Check if ffmpeg succeeded
  if [[ $? -ne 0 ]]; then
    echo "Error converting $f — skipping artwork embedding."
    continue
  fi

  # Step 2: Embed cover art using AtomicParsley (Apple-friendly)
  AtomicParsley "$output" \
                --artwork "$COVER_IMAGE" \
                --overWrite

  # Check success
  if [[ $? -eq 0 ]]; then
    echo "✅ Successfully converted and embedded artwork: $output"
  else
    echo "⚠️ Converted $output but failed to embed artwork."
  fi
done

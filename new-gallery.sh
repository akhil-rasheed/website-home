#!/bin/bash

# Usage: ./new-gallery.sh <source_directory> <r2_prefix>
# Example: R2_BUCKET=my-bucket ./new-gallery.sh ~/photos/freiburg-winter freiburg-winter

# Load environment variables from .env if it exists
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

SOURCE_DIR=$1
R2_PREFIX=$2
BUCKET=${R2_BUCKET}

if [ -z "$SOURCE_DIR" ] || [ -z "$R2_PREFIX" ]; then
  echo "Usage: R2_BUCKET=your-bucket $0 <source_directory> <r2_prefix>"
  exit 1
fi

if [ -z "$BUCKET" ]; then
  echo "Error: R2_BUCKET environment variable is not set."
  exit 1
fi

# Output YAML header
echo "photos:"

# Process each image file
shopt -s nullglob
for img in "$SOURCE_DIR"/*.{jpg,jpeg,JPG,JPEG}; do
  filename=$(basename "$img")
  
  # Get dimensions using identify: width height (accounting for EXIF orientation)
  read -r width height <<< $(identify -auto-orient -format "%w %h" "$img")
  
  echo "  - src: $R2_PREFIX/$filename"
  echo "    w: $width"
  echo "    h: $height"
  echo "    caption: \"\""
done

# Upload to R2
echo "" >&2
echo "--- Debug Info ---" >&2
echo "Bucket: $BUCKET" >&2
echo "Prefix: $R2_PREFIX" >&2
echo "Source: $SOURCE_DIR" >&2
echo "------------------" >&2
echo "" >&2

echo "--- Uploading to R2: $BUCKET/$R2_PREFIX ---" >&2
rclone copy "$SOURCE_DIR" "r2:$BUCKET/$R2_PREFIX" --progress -vv >&2
echo "--- Upload Complete ---" >&2

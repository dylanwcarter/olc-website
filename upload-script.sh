#!/bin/bash

# Check if a file argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <file> <folder>"
    echo "Example: $0 /path/to/image.jpg drawings"
    exit 1
fi

# File to upload
FILE="$1"

# Folder to upload images to (e.g., "drawings" or "photography")
FOLDER="$2"

# Path to the repository
REPO_DIR="$HOME/.dont-touch/olc-website" # Update this to the path of your repo
IMAGES_DIR="$REPO_DIR/assets/images/$FOLDER"

# Copy the file to the appropriate folder (instead of moving it)
echo "Copying $FILE to $FOLDER folder..."
cp "$FILE" "$IMAGES_DIR/"

# Get the filename of the copied image
FILENAME=$(basename "$FILE")

# Update the image-list.json file
echo "Updating image-list.json..."
cd "$IMAGES_DIR"

# Create or update the JSON file
if [ ! -f image-list.json ]; then
    # Create a new JSON array if the file doesn't exist
    echo "[]" > image-list.json
fi

# Check if the image is already in the list
if ! grep -Fq "\"$FILENAME\"" image-list.json; then
    # Add the new filename to the JSON array
    TEMP_FILE=$(mktemp)
    jq --arg filename "$FILENAME" '. += [$filename]' image-list.json > "$TEMP_FILE"
    mv "$TEMP_FILE" image-list.json
fi

# Commit and push changes to GitHub
echo "Committing and pushing changes to GitHub..."
cd "$REPO_DIR"
git pull
git add .
git commit -m "Upload new image to $FOLDER"
git push

echo "Upload complete!"

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
REPO_DIR="$HOME/dont-touch/olc-website" # Update this to the path of your repo
IMAGES_DIR="$REPO_DIR/assets/images/$FOLDER"

# Move the file to the appropriate folder
echo "Moving $FILE to $FOLDER folder..."
mv "$FILE" "$IMAGES_DIR/"

# Update the image-list.json file
echo "Updating image-list.json..."
cd "$IMAGES_DIR"
ls *.jpg *.png > image-list.json

# Commit and push changes to GitHub
echo "Committing and pushing changes to GitHub..."
cd "$REPO_DIR"
git add .
git commit -m "Upload new image to $FOLDER"
git push

echo "Upload complete!"

#!/bin/bash

echo "=== Copying Enhanced Files for Pull Request ==="
echo ""

# Store the current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# Create a temporary directory to store enhanced files
TEMP_DIR="/tmp/rayhunter_enhanced_files"
echo "Creating temporary directory: $TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Copy key enhanced files from main branch
echo "Copying enhanced files from main branch..."
git checkout main > /dev/null 2>&1

# Copy the enhanced bin directory (main application)
echo "Copying bin/ directory..."
cp -r bin/ "$TEMP_DIR/"

# Copy enhanced lib directory
echo "Copying lib/ directory..."
cp -r lib/ "$TEMP_DIR/"

# Copy enhanced installer directory
echo "Copying installer/ directory..."
cp -r installer/ "$TEMP_DIR/"

# Copy enhanced telcom-parser directory
echo "Copying telcom-parser/ directory..."
cp -r telcom-parser/ "$TEMP_DIR/"

# Copy enhanced rootshell directory
echo "Copying rootshell/ directory..."
cp -r rootshell/ "$TEMP_DIR/"

# Copy key configuration files
echo "Copying configuration files..."
cp Cargo.toml "$TEMP_DIR/"
cp Cargo.lock "$TEMP_DIR/"

# Go back to the PR branch
git checkout "$CURRENT_BRANCH"

# Remove existing directories that we're replacing
echo "Removing existing directories to replace with enhanced versions..."
rm -rf daemon/
rm -rf check/

# Copy the enhanced files to the current branch
echo "Copying enhanced files to current branch..."
cp -r "$TEMP_DIR"/* .

# Clean up
rm -rf "$TEMP_DIR"

echo ""
echo "=== Files Copied Successfully ==="
echo "Enhanced files have been copied to the current branch."
echo ""

# Show what we have now
echo "=== Current Structure ==="
ls -la

echo ""
echo "=== Next Steps ==="
echo "1. Review the changes"
echo "2. Commit the enhanced files"
echo "3. Push the branch"
echo "4. Create pull request" 
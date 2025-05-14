#!/bin/bash

# Ensure we're in the root of the repository
if [ ! -d ".git" ]; then
  echo "This script should be run from the root of the Git repository."
  exit 1
fi

# Build the site using Hugo
echo "Building the site with Hugo..."
hugo

# Switch to the gh-pages branch (or create it if it doesn't exist)
echo "Switching to the gh-pages branch..."
git checkout gh-pages || git checkout --orphan gh-pages

# Remove all content in the gh-pages branch (except .git)
echo "Cleaning the gh-pages branch..."
cp .gitignore .gitmodules /tmp/

git rm -rf .

mv /tmp/.gitignore ./
mv /tmp/.gitmodules ./

git add .gitignore .gitmodules

# Copy the content of public/ to the root of the gh-pages branch
echo "Copying content from public/ to the gh-pages branch..."
cp -r public/* .

# Add changes to git
echo "Adding changes to git..."
git add .
git commit -m "Deploy site"

# Push the changes to gh-pages
echo "Pushing changes to the gh-pages branch..."
git push origin gh-pages --force

# Switch back to the main branch
echo "Switching back to the main branch..."
git checkout main

echo "Deployment complete!"

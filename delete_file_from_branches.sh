#!/bin/bash

# Define the main branch name
main_branch="main"
file_path=$1

# Prompt for the Personal Access Token (PAT)
echo "Enter your GitHub Personal Access Token:"
read -s pat

# Fetch the latest updates from the remote repository
git fetch --all

# Get a list of all branches except the main branch
branches=$(git branch | grep -v "$main_branch")

# Loop through each branch and check for the file
for branch in $branches; do
  branch=$(echo $branch | sed 's/*//')  # Remove the asterisk from the current branch
  echo "Checking branch '$branch' for file '$file_path'..."
  
  # Switch to the branch
  git checkout $branch
  
  # Check if the file exists in the branch
  if git ls-tree -r $branch --name-only | grep -q "^$file_path$"; then
    echo "File '$file_path' exists in branch '$branch'. Deleting file..."
    
    # Delete the file
    git rm $file_path
    git commit -m "Deleted file $file_path from branch $branch"
    
    # Push the changes using PAT
    git push https://$pat@github.com/adrianINGmanangan/testShellScript.git $branch
  else
    echo "File '$file_path' does not exist in branch '$branch'."
  fi
done

# Switch back to the main branch
git checkout $main_branch

echo "File '$file_path' has been deleted from all branches containing it."

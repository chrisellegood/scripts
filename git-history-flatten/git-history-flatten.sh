#!/bin/bash

# Script to flatten Git history to a single commit while preserving current files
# Based on the tutorial from git/flatten-git-tutorial.md

# Exit on any error
set -e

# Function to print colored messages
print_message() {
    echo -e "\033[1;34m==>\033[0m $1"
}

# Function to print warning messages
print_warning() {
    echo -e "\033[1;33mWarning:\033[0m $1"
}

# Function to print error messages
print_error() {
    echo -e "\033[1;31mError:\033[0m $1"
    exit 1
}

# Check if we're in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    print_error "Not in a Git repository"
fi

# Check if remote exists
if ! git remote get-url origin > /dev/null 2>&1; then
    print_error "No remote 'origin' found. Please set up a remote repository first"
fi

# Check Git version (needs to be at least 2.23 for --show-current)
git_version=$(git --version | cut -d' ' -f3)
if [ "$(printf '%s\n' "2.23.0" "$git_version" | sort -V | head -n1)" != "2.23.0" ]; then
    print_error "Git version 2.23.0 or higher is required. Current version: $git_version"
fi

# Step 1: Ensure we're on main branch and working directory is clean
print_message "Checking current branch and working directory..."
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    print_error "Not on main branch. Please checkout main branch first"
fi

if ! git diff-index --quiet HEAD --; then
    print_error "Working directory is not clean. Please commit or stash changes first"
fi

# Check if backup branch already exists
backup_branch="backup-pre-flatten"
if git show-ref --verify --quiet refs/heads/$backup_branch; then
    print_error "Backup branch '$backup_branch' already exists. Please delete it first or use a different name"
fi

# Display warning about force push
print_warning "This operation will rewrite Git history and force push to remote."
print_warning "Other team members will need to reset their local repositories."
read -p "Do you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Operation cancelled by user"
fi

# Step 2: Create backup branch
print_message "Creating backup branch..."
git branch $backup_branch
git push origin $backup_branch || print_error "Failed to push backup branch"

# Step 3: Create orphan branch
print_message "Creating orphan branch..."
git checkout --orphan temp-flatten

# Step 4: Remove tracked files from index
print_message "Clearing Git index..."
git reset --hard

# Step 5: Add everything and make single commit
print_message "Creating new commit with current state..."
git add .
git commit -m "Flattened history with current state"

# Step 6: Delete old main branch
print_message "Removing old main branch..."
git branch -D main

# Step 7: Fix detached HEAD and rename branch
print_message "Creating new main branch..."
git switch -c main

# Step 8: Force push the new history
print_message "Pushing new history to remote..."
git push --force origin main

print_message "✅ Successfully flattened Git history!"
print_message "A backup of the original history is available in the '$backup_branch' branch"
print_message "To verify the new history, run: git log --oneline"
print_message "To recover the original history, run:"
print_message "  git checkout $backup_branch"
print_message "  git push --force origin main" 
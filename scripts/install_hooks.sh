#!/bin/sh

# Ensure scripts dir exists
mkdir -p scripts

# Create hooks dir
mkdir -p .git/hooks

# Copy pre-commit script
cp scripts/pre-commit .git/hooks/pre-commit

# Make executable
chmod +x .git/hooks/pre-commit
chmod +x scripts/pre-commit

echo "Git hooks installed successfully!"

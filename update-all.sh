#!/bin/bash
set -euo pipefail

# Define a list of directories
directories=(
    "aws-c-common"
    "aws-c-cal"
    "aws-c-io"
    "aws-checksums"
    "aws-c-compression"
    "aws-c-event-stream"
    "aws-c-http"
    "aws-c-sdkutils"
    "aws-c-auth"
    "aws-c-mqtt"
    "aws-c-s3"
    "aws-c-iot"
)

# Loop over each directory
for dir in "${directories[@]}"; do
    echo "--- $dir  ---"
    cd "$dir"
    { set -x; } 2>/dev/null

    git checkout update-cmake
    git pull
    # Replace cmake_minimum_required version in CMakeLists.txt (exact match)
    #sed -i '/^cmake_minimum_required(VERSION 3.13)$/c\cmake_minimum_required(VERSION 3.9)' CMakeLists.txt

    # Replace "CMake 3.13+" with "CMake 3.9+" in README.md
    sed -i 's/CMake 3.13+/CMake 3.9+/g' README.md

    # Check if there are changes to commit
    if git diff --quiet; then
        echo "No changes detected, skipping commit and push."
    else
        # Commit and push the changes
        git add CMakeLists.txt README.md
        git commit -m "Update CMake version requirements to 3.9"
        git push
    fi

    { set +x; } 2>/dev/null
    cd ..
done

echo "--- DONE ---"

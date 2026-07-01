#!/bin/bash
# MIT License
#
# Copyright (c) 2023-present Poing Studios

echo "Resolving Swift Package Manager dependencies..."

if swift build; then
    SPM_BUILD_DIR="$(pwd)/.build"
    export SPM_BUILD_DIR
    echo "SPM dependencies resolved and built at: $SPM_BUILD_DIR"
else
    echo "Failed to build SPM dependencies."
    exit 1
fi

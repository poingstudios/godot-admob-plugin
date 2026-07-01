#!/bin/bash
# MIT License
#
# Copyright (c) 2023-present Poing Studios

if [ $# -eq 0 ]; then
    echo "[ERROR] Please provide the Godot version as an argument (e.g., 3.5.2)."
    exit 1
fi

GODOT_VERSION="$1"
LIB_DIR="godot-lib"
VERSION_FILE="${LIB_DIR}/.version"

# Check if already downloaded and matching
if [ -f "$VERSION_FILE" ]; then
    INSTALLED_VER=$(cat "$VERSION_FILE")
    if [ "$INSTALLED_VER" == "$GODOT_VERSION" ] && [ -f "${LIB_DIR}/godot-lib.aar" ]; then
        echo "[INFO] godot-lib.aar for version $GODOT_VERSION is already downloaded. Skipping."
        exit 0
    fi
fi

# Determine repo, tag, and asset name
if [[ "$GODOT_VERSION" =~ (beta|rc|dev) ]]; then
    GODOT_TAG="$GODOT_VERSION"
    GODOT_REPO="godotengine/godot-builds"
else
    # Normalize version
    NORMALIZED="${GODOT_VERSION%.0}"
    GODOT_TAG="${NORMALIZED}-stable"
    GODOT_REPO="godotengine/godot"
fi

ASSET_NAME="godot-lib.${GODOT_TAG//-/.}.release.aar"
DOWNLOAD_URL="https://github.com/${GODOT_REPO}/releases/download/${GODOT_TAG}/${ASSET_NAME}"

echo "[INFO] Downloading godot-lib.aar from: $DOWNLOAD_URL"

mkdir -p "$LIB_DIR"
TEMP_FILE="${LIB_DIR}/temp_godot_lib.aar"

if ! curl -f -L -o "$TEMP_FILE" "$DOWNLOAD_URL"; then
    echo "[ERROR] Failed to download godot-lib.aar from $DOWNLOAD_URL"
    rm -f "$TEMP_FILE"
    exit 1
fi

mv "$TEMP_FILE" "${LIB_DIR}/godot-lib.aar"
echo "$GODOT_VERSION" > "$VERSION_FILE"

echo "[SUCCESS] godot-lib.aar version $GODOT_VERSION downloaded successfully."

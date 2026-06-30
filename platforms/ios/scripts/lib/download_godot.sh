#!/bin/bash
# MIT License
#
# Copyright (c) 2023-present Poing Studios

if [ $# -eq 0 ]; then
  echo "[ERROR] Please provide the Godot version as an argument (e.g., 3.5.2)."
  exit 1
fi

CURRENT_GODOT_VERSION="$1"

# Determine if this is a stable release or a pre-release (beta, rc, dev)
if [[ "$CURRENT_GODOT_VERSION" =~ (beta|rc|dev) ]]; then
    GODOT_TAG="$CURRENT_GODOT_VERSION"
    GODOT_REPO="godotengine/godot-builds"
else
    NORMALIZED="${CURRENT_GODOT_VERSION%.0}"
    GODOT_TAG="${NORMALIZED}-stable"
    GODOT_REPO="godotengine/godot"
fi

GODOT_FOLDER="godot-${GODOT_TAG}"

# Optimization: Check if Godot is already present and matches the requested version
if [ -d "godot" ]; then
    if [ -f "godot/.version" ]; then
        INSTALLED_VER=$(cat godot/.version)
        if [ "$INSTALLED_VER" == "$CURRENT_GODOT_VERSION" ]; then
            echo "[INFO] Godot $CURRENT_GODOT_VERSION source found. Skipping download."
            exit 0
        fi
    fi
    echo "[INFO] Godot version mismatch or .version file missing. Re-downloading..."
    rm -rf "godot"
fi

DOWNLOAD_FILE="${GODOT_FOLDER}.tar.xz"
DOWNLOAD_URL="https://github.com/${GODOT_REPO}/releases/download/${GODOT_TAG}/${DOWNLOAD_FILE}"

echo "[INFO] Downloading Godot ${CURRENT_GODOT_VERSION} from: $DOWNLOAD_URL"

if ! curl -LO "$DOWNLOAD_URL"; then
  echo "[ERROR] Failed to download $DOWNLOAD_FILE"
  exit 1
fi

if [ ! -f "$DOWNLOAD_FILE" ]; then
  echo "[ERROR] Download file $DOWNLOAD_FILE not found"
  exit 1
fi

echo "[INFO] Extracting..."
if ! tar -xf "$DOWNLOAD_FILE"; then
  echo "[ERROR] Failed to extract $DOWNLOAD_FILE"
  rm -f "$DOWNLOAD_FILE"
  exit 1
fi

rm -f "$DOWNLOAD_FILE"

if [ ! -d "$GODOT_FOLDER" ]; then
  echo "[ERROR] Extracted folder $GODOT_FOLDER not found"
  exit 1
fi

# Prepare the godot folder
if [ -d "godot" ]; then
  echo "[WARNING] Deleting existing 'godot' folder..."
  rm -rf "godot"
fi

if ! mv "$GODOT_FOLDER" "godot"; then
  echo "[ERROR] Failed to rename $GODOT_FOLDER to godot"
  exit 1
fi

echo "$CURRENT_GODOT_VERSION" > godot/.version

echo "[SUCCESS] Godot $CURRENT_GODOT_VERSION downloaded and ready in 'godot' folder"

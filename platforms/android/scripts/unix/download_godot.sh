#!/bin/bash
# MIT License
#
# Copyright (c) 2023-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# platforms/android/scripts/unix/download_godot.sh

if [ $# -eq 0 ]; then
    echo "[ERROR] Please provide the Godot version as an argument."
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

# Determine repo and tag name
# E.g. stable version 4.6.3 vs pre-release 4.7-rc3
if [[ "$GODOT_VERSION" =~ (beta|rc|dev) ]]; then
    GODOT_TAG="$GODOT_VERSION"
    GODOT_REPO="godotengine/godot-builds"
else
    # Check if suffix -stable is already present, if not append it
    if [[ "$GODOT_VERSION" == *-stable ]]; then
        GODOT_TAG="$GODOT_VERSION"
    else
        GODOT_TAG="${GODOT_VERSION}-stable"
    fi
    GODOT_REPO="godotengine/godot"
fi

# Replace '-' with '.' in the tag for the asset name
# E.g. 4.7-rc3 -> 4.7.rc3
# E.g. 4.6.3-stable -> 4.6.3.stable
GODOT_TAG_DOTS="${GODOT_TAG//-/.}"
ASSET_NAME="godot-lib.${GODOT_TAG_DOTS}.template_release.aar"
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

#!/bin/bash
set -e

# This script must be run from the root of the repository.

echo ">>> Compressing Godot Editor Plugin..."

cd platforms/godot_editor

RAW_VERSION=$(grep "version=" addons/admob/plugin.cfg | cut -d'"' -f2)
CH_VERSION=${RAW_VERSION#v}
ZIP_NAME="poing-godot-admob-v${CH_VERSION}.zip"

echo "Version detected: $CH_VERSION"

# Create a clean staging directory structure
mkdir -p build_stage/poing-godot-admob/addons

# Copy the plugin keeping the required folder structure
cp -R addons/admob build_stage/poing-godot-admob/addons/

# Compress the staging directory
cd build_stage
zip -qr "$ZIP_NAME" poing-godot-admob

# Move the zip back to platforms/godot_editor/ and clean up
mv "$ZIP_NAME" ../
cd ..
rm -rf build_stage

echo ">>> Successfully created platforms/godot_editor/$ZIP_NAME"

# Export variables if running in GitHub Actions
if [ -n "$GITHUB_ENV" ]; then
    echo "ZIP_NAME=$ZIP_NAME" >> "$GITHUB_ENV"
    echo "PLUGIN_TAG=v$CH_VERSION" >> "$GITHUB_ENV"
fi
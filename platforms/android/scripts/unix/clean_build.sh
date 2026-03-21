#!/bin/bash
echo "Executing Clean Build"

if [ $# -eq 0 ]; then
  echo "Error: Please provide the Godot version as an argument."
  exit 1
fi

CURRENT_GODOT_VERSION="$1"

chmod +x ./scripts/unix/download_godot.sh
./gradlew clean
./gradlew build -PgodotVersion="$CURRENT_GODOT_VERSION"

BUILD_EXIT_CODE=$?

if [ $BUILD_EXIT_CODE -ne 0 ]; then
  echo "Error: ./gradlew build failed with exit code $BUILD_EXIT_CODE"
  exit 1
fi

./gradlew zipPlugins -PgodotVersion="${CURRENT_GODOT_VERSION}"
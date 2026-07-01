#!/bin/bash
# MIT License
#
# Copyright (c) 2023-present Poing Studios

show_help() {
    echo "Usage: ./scripts/build_local.sh [android|ios|all] <godot_version>"
    echo ""
    echo "Arguments:"
    echo "  [platform]       android, ios, or all (default: all)"
    echo "  <godot_version>  The target Godot version (e.g. 3.6.2)"
    echo ""
    echo "Examples:"
    echo "  ./scripts/build_local.sh all 3.6.2"
    echo "  ./scripts/build_local.sh ios 3.6.2"
    echo "  ./scripts/build_local.sh android 3.6.2"
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

PLATFORM=${1:-all}
GODOT_VERSION=$2

if [ -z "$GODOT_VERSION" ]; then
    echo "[ERROR] Please specify target Godot version (e.g., 3.6.2)."
    show_help
    exit 1
fi

ROOT_DIR=$(pwd)
EDITOR_DIR="$ROOT_DIR/platforms/godot_editor"

build_android() {
    echo ">>> Preparing Android build for Godot $GODOT_VERSION..."
    cd "$ROOT_DIR/platforms/android" || exit 1
    chmod +x ./scripts/unix/download_godot.sh
    ./scripts/unix/download_godot.sh "$GODOT_VERSION" || exit 1
    
    echo ">>> Compiling Android plugin..."
    chmod +x gradlew
    ./gradlew build || exit 1
    
    echo ">>> Exporting Android plugin files to Godot Editor..."
    mkdir -p "$EDITOR_DIR/android/plugins"
    cp "$ROOT_DIR/platforms/android/admob/AdMob.gdap" "$EDITOR_DIR/android/plugins/"
    cp "$ROOT_DIR/platforms/android/admob/build/outputs/aar/admob-release.aar" "$EDITOR_DIR/android/plugins/"
    cp "$ROOT_DIR/platforms/android/admob/build/outputs/aar/admob-debug.aar" "$EDITOR_DIR/android/plugins/"
}

build_ios() {
    echo ">>> Preparing iOS build for Godot $GODOT_VERSION..."
    cd "$ROOT_DIR/platforms/ios" || exit 1
    chmod +x ./scripts/lib/download_godot.sh
    ./scripts/lib/download_godot.sh "$GODOT_VERSION" || exit 1
    
    chmod +x ./scripts/resolve_spm_deps.sh
    ./scripts/resolve_spm_deps.sh || exit 1
    
    echo ">>> Generating Godot binding headers..."
    chmod +x ./scripts/generate_headers.sh
    ./scripts/generate_headers.sh 3.x || exit 1
    
    echo ">>> Compiling iOS static libraries..."
    chmod +x ./scripts/release_static_library.sh
    chmod +x ./scripts/generate_static_library.sh
    ./scripts/release_static_library.sh 3.x || exit 1
    
    echo ">>> Exporting iOS plugin files to Godot Editor..."
    mkdir -p "$EDITOR_DIR/ios/plugins"
    cp -R "$ROOT_DIR/platforms/ios/bin/release/admob/"* "$EDITOR_DIR/ios/plugins/"
}

case "$PLATFORM" in
    android) build_android ;;
    ios)     build_ios ;;
    all)     build_android; build_ios ;;
    *)       echo "Invalid platform: $PLATFORM"; exit 1 ;;
esac

echo "Done!"

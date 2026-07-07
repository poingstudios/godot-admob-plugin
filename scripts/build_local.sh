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

# scripts/build_local.sh

show_help() {
    echo "Usage: ./scripts/build_local.sh [android|ios|all] <godot_version> [--clean]"
    echo ""
    echo "Arguments:"
    echo "  [platform]       android, ios, or all (default: all)"
    echo "  <godot_version>  The Godot version (e.g., 4.6.1 or 4.7-beta1)"
    echo "  --clean          Clean before building"
    echo ""
    echo "Examples:"
    echo "  ./scripts/build_local.sh all 4.6.3"
    echo "  ./scripts/build_local.sh ios 4.7-rc3 --clean"
    echo "  ./scripts/build_local.sh android 4.6.3 --clean"
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

CLEAN=false
ARGS=()
for arg in "$@"; do
    if [ "$arg" = "--clean" ]; then
        CLEAN=true
    else
        ARGS+=("$arg")
    fi
done

PLATFORM=${ARGS[0]:-all}
GODOT_VERSION=${ARGS[1]}

if [ -z "$GODOT_VERSION" ]; then
    show_help
    exit 1
fi

ROOT_DIR=$(pwd)
DEST="$ROOT_DIR/platforms/godot_editor"

build_android() {
    echo ">>> Building Android ($GODOT_VERSION)..."
    cd "$ROOT_DIR/platforms/android" && \
    chmod +x ./scripts/unix/download_godot.sh && \
    ./scripts/unix/download_godot.sh "$GODOT_VERSION" && \
    chmod +x gradlew
    
    if [ "$CLEAN" = true ]; then
        echo ">>> Cleaning Android build and export directories..."
        ./gradlew clean || exit 1
        rm -rf "$DEST/addons/admob/android/bin/"*
    fi
    
    ./gradlew build -PgodotVersion="$GODOT_VERSION" && \
    ./gradlew exportFiles -PpluginExportPath="$DEST/addons/admob/android/bin" || exit 1
}

build_ios() {
    echo ">>> Building iOS ($GODOT_VERSION)..."
    BUILD_OPTS=""
    if [ "$CLEAN" = true ]; then
        BUILD_OPTS="--clean"
        echo ">>> Cleaning iOS export directories..."
        rm -rf "$DEST/addons/admob/ios/bin/"*
    fi
    cd "$ROOT_DIR/platforms/ios" && ./scripts/build.sh $BUILD_OPTS "$GODOT_VERSION" || exit 1
    
    ARCHIVE=$(ls -1 bin/release/poing-godot-admob-ios-v${GODOT_VERSION}.zip 2>/dev/null | tail -n 1)
    if [ -f "$ARCHIVE" ]; then
        mkdir -p "$DEST/addons/admob/ios/bin/"
        unzip -qo "$ARCHIVE" -d "$DEST/addons/admob/ios/bin/" || exit 1
    fi
}

case "$PLATFORM" in
    android) build_android ;;
    ios)     build_ios ;;
    all)     build_android; build_ios ;;
    *)       echo "Invalid platform: $PLATFORM"; exit 1 ;;
esac

echo "Done! Plugin binaries updated in $DEST"

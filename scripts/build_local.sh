#!/bin/bash
# scripts/build_local.sh

PLATFORM=${1:-all}
GODOT_VERSION=${2}

if [ -z "$GODOT_VERSION" ]; then
    echo "Usage: ./scripts/build_local.sh [android|ios|all] <godot_version>"
    echo "Example: ./scripts/build_local.sh all 4.6.1"
    exit 1
fi

ROOT_DIR=$(pwd)
DEST="$ROOT_DIR/platforms/godot_editor"

build_android() {
    echo ">>> Building Android ($GODOT_VERSION)..."
    cd "$ROOT_DIR/platforms/android" && chmod +x gradlew && \
    ./gradlew build -PgodotVersion="$GODOT_VERSION" && \
    ./gradlew exportFiles -PpluginExportPath="$DEST/addons/admob/android/bin" || exit 1
}

build_ios() {
    echo ">>> Building iOS ($GODOT_VERSION)..."
    cd "$ROOT_DIR/platforms/ios" && ./scripts/build.sh "$GODOT_VERSION" || exit 1
    
    ARCHIVE=$(ls -1 bin/release/poing-godot-admob-ios-v${GODOT_VERSION}.zip 2>/dev/null | tail -n 1)
    if [ -f "$ARCHIVE" ]; then
        mkdir -p "$DEST/ios/plugins/"
        unzip -qo "$ARCHIVE" -d "$DEST/ios/plugins/" || exit 1
    fi
}

case "$PLATFORM" in
    android) build_android ;;
    ios)     build_ios ;;
    all)     build_android; build_ios ;;
    *)       echo "Invalid platform: $PLATFORM"; exit 1 ;;
esac

echo "Done! Plugin binaries updated in $DEST"

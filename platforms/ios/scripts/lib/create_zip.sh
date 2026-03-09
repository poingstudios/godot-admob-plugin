#!/bin/bash
# scripts/lib/create_zip.sh

# Source common for logging and helpers
if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
elif [ -f "lib/common.sh" ]; then
    source lib/common.sh
else
    echo "Error: Cannot find common.sh"
    exit 1
fi

TYPE="$1" # "plugin" or "sdk"
NAME="$2" # internal or external-dependencies
VERSION="$3" # Godot version (optional for SDK)

if [ "$TYPE" != "plugin" ] && [ "$TYPE" != "sdk" ]; then
    log_error "Usage: $0 <plugin|sdk> <name> [version]"
    exit 1
fi

PROJECT_ROOT=$(pwd)
RELEASE_DIR_ABS="$PROJECT_ROOT/bin/release"

if [ ! -d "$RELEASE_DIR_ABS/$NAME" ]; then
    log_error "Staging directory not found: $RELEASE_DIR_ABS/$NAME"
    exit 1
fi

if [ "$TYPE" == "plugin" ]; then
    if [ -n "$VERSION" ]; then
        VER_STR="-v$VERSION"
    else
        VER_STR=""
    fi
    FILE_NAME="poing-godot-admob-ios$VER_STR.zip"
    
    log_info "Creating Plugin ZIP: $FILE_NAME"
    rm -f "$RELEASE_DIR_ABS/$FILE_NAME"
    cd "$RELEASE_DIR_ABS/$NAME" || exit 1
    zip -rq "$RELEASE_DIR_ABS/$FILE_NAME" ./*.gdip ./*.gd poing-godot-admob/bin/
    cd "$PROJECT_ROOT" || exit 1
else
    FILE_NAME="poing-godot-admob-ios-sdk-$NAME.zip"
    
    log_info "Creating SDK ZIP: $FILE_NAME"
    rm -f "$RELEASE_DIR_ABS/$FILE_NAME"
    cd "$RELEASE_DIR_ABS/$NAME" || exit 1
    zip -rq "$RELEASE_DIR_ABS/$FILE_NAME" ./*.gd poing-godot-admob/frameworks/
    cd "$PROJECT_ROOT" || exit 1
fi

log_success "Created artifact: ./bin/release/$FILE_NAME"
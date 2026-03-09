#!/bin/bash
# scripts/lib/generate_static_library.sh

if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
elif [ -f "lib/common.sh" ]; then
    source lib/common.sh
else
    echo "Error: Cannot find common.sh"
    exit 1
fi

PLUGIN="$1"
TARGET="$2"

log_info "Compiling $PLUGIN ($TARGET)..."

# Using timeout script to prevent hanging if configured
TIMEOUT_CMD=""
if [ -f "scripts/lib/timeout" ]; then
    TIMEOUT_CMD="scripts/lib/timeout"
fi

# Compile static libraries
# ARM64 Device
log_info "Building arm64 device..."
$TIMEOUT_CMD scons -j $NUM_CORES target=$TARGET arch=arm64 plugin=$PLUGIN || { log_error "Failed to build arm64 device"; exit 1; }

# ARM64 Simulator (Apple Silicon Macs)
log_info "Building arm64 simulator..."
$TIMEOUT_CMD scons -j $NUM_CORES target=$TARGET arch=arm64 simulator=yes plugin=$PLUGIN || { log_error "Failed to build arm64 simulator"; exit 1; }

# x86_64 Simulator (Intel Macs / Rosetta)
log_info "Building x86_64 simulator..."
$TIMEOUT_CMD scons -j $NUM_CORES target=$TARGET arch=x86_64 simulator=yes plugin=$PLUGIN || { log_error "Failed to build x86_64 simulator"; exit 1; }

XCF_OUT="./bin/xcframeworks/$PLUGIN/poing-godot-admob-$PLUGIN.$TARGET.xcframework"

# Optimization: Check if we need to recreate the XCFramework
# We use a timestamp file to track when the last successful post-processing happened
TIMESTAMP_FILE="./bin/static_libraries/$PLUGIN/.last_build_$TARGET"
LIB_DEVICE="./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-ios.$TARGET.a"
LIB_SIM_ARM="./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-simulator.$TARGET.a"
LIB_SIM_X86="./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.x86_64-simulator.$TARGET.a"

if [ -f "$XCF_OUT/Info.plist" ] && [ -f "$TIMESTAMP_FILE" ]; then
    if [[ "$LIB_DEVICE" -ot "$TIMESTAMP_FILE" ]] && [[ "$LIB_SIM_ARM" -ot "$TIMESTAMP_FILE" ]] && [[ "$LIB_SIM_X86" -ot "$TIMESTAMP_FILE" ]]; then
        # Quietly exit if everything is up to date
        exit 0
    fi
fi

# Post-processing (Strip, Lipo, XCFramework)
log_info "Post-processing $PLUGIN ($TARGET)..."
STAGING_LIBS="./bin/static_libraries/$PLUGIN/processed_$TARGET"
mkdir -p "$STAGING_LIBS"

LIB_DEVICE_STRIPPED="$STAGING_LIBS/$(basename "$LIB_DEVICE")"
LIB_SIM_ARM_STRIPPED="$STAGING_LIBS/$(basename "$LIB_SIM_ARM")"
LIB_SIM_X86_STRIPPED="$STAGING_LIBS/$(basename "$LIB_SIM_X86")"
LIB_SIM_FAT="$STAGING_LIBS/poing-godot-admob-$PLUGIN.simulator.$TARGET.a"

# Strip local symbols to reduce size (on copies!)
cp "$LIB_DEVICE" "$LIB_DEVICE_STRIPPED"
cp "$LIB_SIM_ARM" "$LIB_SIM_ARM_STRIPPED"
cp "$LIB_SIM_X86" "$LIB_SIM_X86_STRIPPED"

strip -S "$LIB_DEVICE_STRIPPED"
strip -S "$LIB_SIM_ARM_STRIPPED"
strip -S "$LIB_SIM_X86_STRIPPED"

# Create fat simulator library (arm64-sim + x86_64-sim)
lipo -create \
    "$LIB_SIM_ARM_STRIPPED" \
    "$LIB_SIM_X86_STRIPPED" \
    -output "$LIB_SIM_FAT" || { log_error "Failed to create fat lib"; exit 1; }

# Create xcframework (device + simulator)
mkdir -p "./bin/xcframeworks/$PLUGIN"
rm -rf "$XCF_OUT"

xcodebuild -create-xcframework \
    -library "$LIB_DEVICE_STRIPPED" \
    -library "$LIB_SIM_FAT" \
    -output "$XCF_OUT" > /dev/null || { log_error "Failed to create xcframework"; exit 1; }

touch "$TIMESTAMP_FILE"
log_success "Updated xcframework: $PLUGIN ($TARGET)"
#!/bin/bash
# scripts/lib/generate_headers.sh

# Source common for logging and helpers
# Ensure we are running from project root or scripts folder
if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
elif [ -f "lib/common.sh" ]; then
    source lib/common.sh
else
    echo "Error: Cannot find common.sh"
    exit 1
fi

log_info "Checking if Godot headers need generation..."

if [ -f "godot/core/version_generated.gen.h" ]; then
    log_info "Headers already generated. Skipping."
    exit 0
fi

if [ ! -d "godot" ]; then
    log_error "Godot source folder not found."
    exit 1
fi

cd ./godot || exit 1


# Using timeout script to prevent hanging if configured
TIMEOUT_CMD=""
if [ -f "../scripts/lib/timeout" ]; then
    TIMEOUT_CMD="../scripts/lib/timeout"
fi

log_info "Running SCons to generate headers..."
# Use -Wno-module-import-in-extern-c to avoid issues with Vulkan headers in Godot 4.3.0 on modern macOS/Clang
SCONS_FLAGS=""
if [ -f ".version" ]; then
    GODOT_VERSION=$(cat .version)
    log_info "Detected Godot version: $GODOT_VERSION"
    if [ "$GODOT_VERSION" == "4.3" ]; then
        SCONS_FLAGS="ccflags=\"-Wno-module-import-in-extern-c\""
    fi
fi
$TIMEOUT_CMD scons -j $NUM_CORES platform=ios target=template_release $SCONS_FLAGS

# We don't check for exit code here because the process is intentionally 
# interrupted by the timeout script once headers are likely generated.
log_success "Proceeding after header generation attempt."

cd ..
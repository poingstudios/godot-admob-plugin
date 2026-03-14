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


# Detect Godot version and set specific flags if needed
SCONS_FLAGS=""
IS_MODERN=false
if [ -f ".version" ]; then
    GODOT_VERSION=$(cat .version)
    log_info "Detected Godot version: $GODOT_VERSION"
    
    # Use -Wno-module-import-in-extern-c to avoid issues with Vulkan headers in Godot 4.3.0
    if [ "$GODOT_VERSION" == "4.3" ]; then
        SCONS_FLAGS="ccflags=\"-Wno-module-import-in-extern-c\""
    fi

    # Extract major and minor version for comparison
    MAJOR=$(echo "$GODOT_VERSION" | cut -d. -f1)
    MINOR=$(echo "$GODOT_VERSION" | cut -d. -f2)
    
    # GDExtension interface header exists only in Godot 4.2+
    if [ "$MAJOR" -eq 4 ] && [ "$MINOR" -ge 2 ]; then
        IS_MODERN=true
    fi
fi

# Essential targets for all versions
TARGETS=(
    "core/version_generated.gen.h"
    "core/disabled_classes.gen.h"
    "core/object/gdvirtual.gen.inc"
    "modules/modules_enabled.gen.h"
)

# Add version-specific targets
if [ "$IS_MODERN" = true ]; then
    TARGETS+=("core/extension/gdextension_interface.gen.h")
fi

log_info "Running SCons to generate headers..."
# We build only the required generated files. This is extremely fast and 
# ensures all headers are present for the plugin to compile.
scons -j $NUM_CORES platform=ios target=template_release "${TARGETS[@]}" $SCONS_FLAGS

log_success "Headers generated successfully."

cd ..
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

# Suppress Python SyntaxWarnings (common when running older Godot scripts with newer Python versions)
export PYTHONWARNINGS="ignore::SyntaxWarning"

cd ./godot || exit 1


# Detect Godot version-specific flags
SCONS_FLAGS=""
if [ -f ".version" ] && [ "$(cat .version)" == "4.3" ]; then
    log_info "Applying Godot 4.3 specific flags"
    SCONS_FLAGS="ccflags=\"-Wno-module-import-in-extern-c\""
fi

# Essential targets for all 4.x versions
TARGETS=(
    "core/version_generated.gen.h"
    "core/disabled_classes.gen.h"
    "core/object/gdvirtual.gen.inc"
    "modules/modules_enabled.gen.h"
)

# GDExtension interface header (added in Godot 4.2/4.4+)
# We check if the directory exists instead of parsing the version string.
if [ -d "core/extension" ]; then
    TARGETS+=("core/extension/gdextension_interface.gen.h")
fi

log_info "Running SCons to generate headers..."
scons -j $NUM_CORES platform=ios target=template_release --keep-going "${TARGETS[@]}" $SCONS_FLAGS

log_success "Headers generated successfully."

cd ..
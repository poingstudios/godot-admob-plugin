#!/bin/bash
# scripts/clean.sh

# Source common library
if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
else
    echo "Error: Cannot find scripts/lib/common.sh"
    exit 1
fi

log_info "Cleaning project artifacts and temporary files..."

# Remove all binary artifacts
rm -rf bin/
rm -rf build/
log_info "Removed bin/ and build/"

# Remove temporary extraction folders
rm -rf godot/
rm -rf godot-*
log_info "Removed godot/ and godot-*"

# Remove SPM artifacts (resolved via common.sh)
rm -rf "$SPM_BUILD_DIR"
rm -f Package.resolved
log_info "Removed SPM artifacts ($SPM_BUILD_DIR, Package.resolved)"

# Remove SCons temporary files
find . -name ".sconsign.dblite" -delete
find . -name "*.os" -delete
find . -name "*.o" -delete
log_info "Removed SCons temporary files (.sconsign, .os, .o)"

log_success "Clean complete."

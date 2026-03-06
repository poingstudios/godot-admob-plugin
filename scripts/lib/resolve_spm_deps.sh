#!/bin/bash
# scripts/lib/resolve_spm_deps.sh

# Source common for logging
if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
elif [ -f "lib/common.sh" ]; then
    source lib/common.sh
else
    echo "Error: Cannot find common.sh"
    exit 1
fi

log_info "Resolving Swift Package Manager dependencies..."

if swift package resolve; then
    SPM_BUILD_DIR="$(pwd)/.build"
    export SPM_BUILD_DIR
    log_success "SPM dependencies resolved at: $SPM_BUILD_DIR"
else
    log_error "Failed to resolve SPM dependencies."
    exit 1
fi

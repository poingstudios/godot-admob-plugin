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

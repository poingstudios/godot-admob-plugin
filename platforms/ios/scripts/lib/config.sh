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

# _config.sh - Central configuration for the build scripts

# Core plugin name
CORE_PLUGIN="ads"

# Auto-discover mediation plugins based on the directory structure
# This lists directories in src/mediation and gets their names
MEDIATION_PLUGINS=()
if [ -d "./src/mediation" ]; then
    for dir in ./src/mediation/*/; do
        if [ -d "$dir" ]; then
            MEDIATION_PLUGINS+=("$(basename "$dir")")
        fi
    done
fi

# Combined list for scripts that need to loop through everything
ALL_PLUGINS=("$CORE_PLUGIN" "${MEDIATION_PLUGINS[@]}")

# Helper function to get config directory for a plugin
get_plugin_config_dir() {
    local plugin="$1"
    if [ "$plugin" == "$CORE_PLUGIN" ]; then
        echo "./src/${plugin}/config"
    else
        echo "./src/mediation/${plugin}/config"
    fi
}

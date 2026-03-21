#!/bin/bash
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

#!/bin/bash
# scripts/lib/download_godot.sh

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

if [ $# -eq 0 ]; then
  log_error "Please provide the Godot version as an argument."
  exit 1
fi

CURRENT_GODOT_VERSION="${1%.0}"
GODOT_FOLDER="godot-${CURRENT_GODOT_VERSION}-stable"

# Optimization: Check if Godot is already present and matches the requested version
if [ -d "godot" ]; then
    if [ -f "godot/.version" ]; then
        INSTALLED_VER=$(cat godot/.version)
        if [ "$INSTALLED_VER" == "$CURRENT_GODOT_VERSION" ]; then
            log_info "Godot $CURRENT_GODOT_VERSION source found. Skipping download."
            exit 0
        fi
    fi
    log_info "Godot version mismatch or .version file missing. Re-downloading..."
    rm -rf "godot"
fi


DOWNLOAD_FILE="${GODOT_FOLDER}.tar.xz"
FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS="https://github.com/godotengine/godot/releases/download/${CURRENT_GODOT_VERSION}-stable/${DOWNLOAD_FILE}"

log_info "Downloading Godot ${CURRENT_GODOT_VERSION} from: $FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS"

if ! curl -LO "$FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS"; then
  log_error "Failed to download $DOWNLOAD_FILE"
  exit 1
fi

if [ ! -f "$DOWNLOAD_FILE" ]; then
  log_error "Download file $DOWNLOAD_FILE not found"
  exit 1
fi

log_info "Extracting..."
if ! tar -xf "$DOWNLOAD_FILE"; then
  log_error "Failed to extract $DOWNLOAD_FILE"
  rm -f "$DOWNLOAD_FILE"
  exit 1
fi

rm -f "$DOWNLOAD_FILE"

if [ ! -d "$GODOT_FOLDER" ]; then
  log_error "Extracted folder $GODOT_FOLDER not found"
  exit 1
fi

# Prepare the godot folder
if [ -d "godot" ]; then
  log_warning "Deleting existing 'godot' folder (incomplete/corrupt)..."
  rm -rf "godot"
fi

if ! mv "$GODOT_FOLDER" "godot"; then
  log_error "Failed to rename $GODOT_FOLDER to godot"
  exit 1
fi

echo "$CURRENT_GODOT_VERSION" > godot/.version

log_success "Godot $CURRENT_GODOT_VERSION downloaded and ready in 'godot' folder"
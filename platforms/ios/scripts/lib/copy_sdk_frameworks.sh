#!/bin/bash
# scripts/lib/copy_sdk_frameworks.sh

if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
elif [ -f "lib/common.sh" ]; then
    source lib/common.sh
else
    echo "Error: Cannot find common.sh"
    exit 1
fi

PLUGIN="$1"
DEST_PATH="$2"

ensure_dir "$DEST_PATH/frameworks/"

log_info "Copying and optimizing SDK frameworks for plugin: $PLUGIN"

# Helper function to thin an xcframework
optimize_framework() {
    local framework_path="$1"
    log_info "  Optimizing: $(basename "$framework_path")"
    
    # Remove metadata not needed for binary linking in Godot
    find "$framework_path" -name "Headers" -type d -exec rm -rf {} +
    find "$framework_path" -name "Modules" -type d -exec rm -rf {} +
    find "$framework_path" -name "_CodeSignature" -type d -exec rm -rf {} +
}

# Helper function to copy and optimize a single framework
copy_framework() {
    local src="$1"
    local name=$(basename "$src")
    if [ ! -d "$src" ]; then
        log_error "Framework not found at $src"
        exit 1
    fi
    cp -R "$src" "$DEST_PATH/frameworks/"
    optimize_framework "$DEST_PATH/frameworks/$name"
}

# Helper to try multiple paths and copy the first that exists
copy_first_exists() {
    local target_name="$1"
    shift
    for src in "$@"; do
        if [ -d "$src" ]; then
            cp -R "$src" "$DEST_PATH/frameworks/"
            optimize_framework "$DEST_PATH/frameworks/$target_name"
            return 0
        fi
    done
    log_error "Could not find any source for $target_name"
    exit 1
}

case "$PLUGIN" in
    ads)
        copy_framework "$SPM_ARTIFACTS/swift-package-manager-google-mobile-ads/GoogleMobileAds/GoogleMobileAds.xcframework"
        copy_framework "$SPM_ARTIFACTS/swift-package-manager-google-user-messaging-platform/UserMessagingPlatform/UserMessagingPlatform.xcframework"
        ;;
    meta)
        META_PATH="$SPM_ARTIFACTS/googleads-mobile-ios-mediation-meta"
        copy_framework "$META_PATH/MetaAdapter/MetaAdapter.xcframework"
        copy_first_exists "FBAudienceNetwork.xcframework" \
            "$META_PATH/FBAudienceNetwork/Static/FBAudienceNetwork.xcframework" \
            "$META_PATH/FBAudienceNetwork/Dynamic/FBAudienceNetwork.xcframework"
        ;;
    vungle)
        VUNGLE_PATH="$SPM_ARTIFACTS/googleads-mobile-ios-mediation-liftoffmonetize"
        VUNGLE_SDK_PATH="$SPM_ARTIFACTS/vungleadssdk-swiftpackagemanager"
        copy_framework "$VUNGLE_PATH/LiftoffMonetizeAdapter/LiftoffMonetizeAdapter.xcframework"
        copy_framework "$VUNGLE_SDK_PATH/VungleAdsSDK/VungleAdsSDK.xcframework"
        ;;
    *)
        log_error "Unknown plugin for SDK copy: $PLUGIN"
        exit 1
        ;;
esac

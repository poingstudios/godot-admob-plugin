// MIT License
// Copyright (c) 2023-present Poing Studios

#import "PoingGodotAdMobNativeOverlayAd.h"

PoingGodotAdMobNativeOverlayAd *PoingGodotAdMobNativeOverlayAd::instance = NULL;

PoingGodotAdMobNativeOverlayAd::PoingGodotAdMobNativeOverlayAd() {
    instance = this;
}

PoingGodotAdMobNativeOverlayAd::~PoingGodotAdMobNativeOverlayAd() {
    instance = NULL;
}

PoingGodotAdMobNativeOverlayAd *PoingGodotAdMobNativeOverlayAd::get_singleton() {
    return instance;
}


Dictionary PoingGodotAdMobNativeOverlayAd::get_response_info(int uid) {
    NativeOverlayAd* adObj = this->getObject(uid);
    if (adObj && adObj.nativeAd && adObj.nativeAd.responseInfo) {
        return [ObjectToGodotDictionary convertResponseInfoToDictionary:adObj.nativeAd.responseInfo];
    }
    return Dictionary();
}

void PoingGodotAdMobNativeOverlayAd::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create"), &PoingGodotAdMobNativeOverlayAd::create);
    ClassDB::bind_method(D_METHOD("load", "ad_unit_id", "ad_request_dictionary", "keywords", "options_dictionary", "uid"), &PoingGodotAdMobNativeOverlayAd::load);
    ClassDB::bind_method(D_METHOD("render_template", "uid", "style_dictionary", "position", "ad_size_dictionary"), &PoingGodotAdMobNativeOverlayAd::render_template);
    ClassDB::bind_method(D_METHOD("render_template_custom_position", "uid", "style_dictionary", "x", "y", "ad_size_dictionary"), &PoingGodotAdMobNativeOverlayAd::render_template_custom_position);
    ClassDB::bind_method(D_METHOD("destroy", "uid"), &PoingGodotAdMobNativeOverlayAd::destroy);
    ClassDB::bind_method(D_METHOD("hide", "uid"), &PoingGodotAdMobNativeOverlayAd::hide);
    ClassDB::bind_method(D_METHOD("show", "uid"), &PoingGodotAdMobNativeOverlayAd::show);
    ClassDB::bind_method(D_METHOD("update_position", "uid", "position"), &PoingGodotAdMobNativeOverlayAd::update_position);
    ClassDB::bind_method(D_METHOD("update_custom_position", "uid", "x", "y"), &PoingGodotAdMobNativeOverlayAd::update_custom_position);
    ClassDB::bind_method(D_METHOD("get_width_in_pixels", "uid"), &PoingGodotAdMobNativeOverlayAd::get_width_in_pixels);
    ClassDB::bind_method(D_METHOD("get_height_in_pixels", "uid"), &PoingGodotAdMobNativeOverlayAd::get_height_in_pixels);

    ADD_SIGNAL(MethodInfo("on_native_overlay_ad_loaded", PropertyInfo(Variant::INT, "uid")));
    ADD_SIGNAL(MethodInfo("on_native_overlay_ad_failed_to_load", PropertyInfo(Variant::INT, "uid"), PropertyInfo(Variant::DICTIONARY, "error")));
    ADD_SIGNAL(MethodInfo("on_native_overlay_ad_clicked", PropertyInfo(Variant::INT, "uid")));
    ADD_SIGNAL(MethodInfo("on_native_overlay_ad_closed", PropertyInfo(Variant::INT, "uid")));
    ADD_SIGNAL(MethodInfo("on_native_overlay_ad_impression", PropertyInfo(Variant::INT, "uid")));
    ADD_SIGNAL(MethodInfo("on_native_overlay_ad_opened", PropertyInfo(Variant::INT, "uid")));
    ADD_SIGNAL(MethodInfo("on_native_overlay_ad_paid", PropertyInfo(Variant::INT, "uid"), PropertyInfo(Variant::DICTIONARY, "adValueDictionary")));
}

int PoingGodotAdMobNativeOverlayAd::create() {
    int uid = (int)objectVector.size();
    NativeOverlayAd *nativeAd = [[NativeOverlayAd alloc] initWithUID:[NSNumber numberWithInt:uid]];
    objectVector.push_back(nativeAd);
    return uid;
}

void PoingGodotAdMobNativeOverlayAd::load(String ad_unit_id, Dictionary ad_request_dictionary, PackedStringArray keywords, Dictionary options_dictionary, int uid) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad == nil) {
        ad = [[NativeOverlayAd alloc] initWithUID:[NSNumber numberWithInt:uid]];
        objectVector[uid] = ad;
    }
    
    NSString *unitId = [NSString stringWithUTF8String:ad_unit_id.utf8().get_data()];
    GADRequest *request = [GodotDictionaryToObject convertDictionaryToGADRequest:ad_request_dictionary withKeywords:keywords];
    NSDictionary *options = [GodotDictionaryToObject convertDictionaryToNSDictionary:options_dictionary];
    
    [ad loadWithAdUnitId:unitId adRequest:request options:options];
}

void PoingGodotAdMobNativeOverlayAd::render_template(int uid, Dictionary style_dictionary, int position, Dictionary ad_size_dictionary) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        NSDictionary *style = [GodotDictionaryToObject convertDictionaryToNSDictionary:style_dictionary];
        NSDictionary *adSize = [GodotDictionaryToObject convertDictionaryToNSDictionary:ad_size_dictionary];
        [ad renderTemplate:style position:position adSize:adSize];
    }
}

void PoingGodotAdMobNativeOverlayAd::render_template_custom_position(int uid, Dictionary style_dictionary, int x, int y, Dictionary ad_size_dictionary) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        NSDictionary *style = [GodotDictionaryToObject convertDictionaryToNSDictionary:style_dictionary];
        NSDictionary *adSize = [GodotDictionaryToObject convertDictionaryToNSDictionary:ad_size_dictionary];
        [ad renderTemplateCustomPosition:style x:x y:y adSize:adSize];
    }
}

void PoingGodotAdMobNativeOverlayAd::destroy(int uid) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        [ad destroy];
        objectVector[uid] = nil;
    }
}

void PoingGodotAdMobNativeOverlayAd::hide(int uid) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        [ad hide];
    }
}

void PoingGodotAdMobNativeOverlayAd::show(int uid) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        [ad show];
    }
}

void PoingGodotAdMobNativeOverlayAd::update_position(int uid, int position) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        [ad updatePosition:position];
    }
}

void PoingGodotAdMobNativeOverlayAd::update_custom_position(int uid, int x, int y) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        [ad updateCustomPosition:x y:y];
    }
}

float PoingGodotAdMobNativeOverlayAd::get_width_in_pixels(int uid) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        return [ad getWidthInPixels];
    }
    return 0.0f;
}

float PoingGodotAdMobNativeOverlayAd::get_height_in_pixels(int uid) {
    NativeOverlayAd *ad = getObject(uid);
    if (ad != nil) {
        return [ad getHeightInPixels];
    }
    return 0.0f;
}

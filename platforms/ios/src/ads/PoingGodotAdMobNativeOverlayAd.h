// MIT License
// Copyright (c) 2023-present Poing Studios

#ifndef PoingGodotAdMobNativeOverlayAd_h
#define PoingGodotAdMobNativeOverlayAd_h

#import "converters/GodotDictionaryToObject.h"
#import "ObjectController.h"
#import "adformats/NativeOverlayAd.h"

@class NativeOverlayAd;

#import <UIKit/UIKit.h>

class PoingGodotAdMobNativeOverlayAd : public ObjectController<NativeOverlayAd> {

    GDCLASS(PoingGodotAdMobNativeOverlayAd, Object);

    static PoingGodotAdMobNativeOverlayAd *instance;
    static void _bind_methods();

public:
    int create();
    void load(String ad_unit_id, Dictionary ad_request_dictionary, PackedStringArray keywords, Dictionary options_dictionary, int uid);
    void render_template(int uid, Dictionary style_dictionary, int position, Dictionary ad_size_dictionary);
    void render_template_custom_position(int uid, Dictionary style_dictionary, int x, int y, Dictionary ad_size_dictionary);
    void destroy(int uid);
    Dictionary get_response_info(int uid);
    void hide(int uid);
    void show(int uid);
    void update_position(int uid, int position);
    void update_custom_position(int uid, int x, int y);
    float get_width_in_pixels(int uid);
    float get_height_in_pixels(int uid);

    static PoingGodotAdMobNativeOverlayAd *get_singleton();

    PoingGodotAdMobNativeOverlayAd();
    ~PoingGodotAdMobNativeOverlayAd();
};

#endif /* PoingGodotAdMobNativeOverlayAd_h */

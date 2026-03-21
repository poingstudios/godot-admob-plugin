// MIT License
//
// Copyright (c) 2023-present Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#ifndef PoingGodotAdMobAdView_h
#define PoingGodotAdMobAdView_h

#import "converters/GodotDictionaryToObject.h"
#import "ObjectController.h"
#import "adformats/BannerAd.h"

@class BannerAd;

@import GoogleMobileAds;

class PoingGodotAdMobAdView : public ObjectController<BannerAd> {

    GDCLASS(PoingGodotAdMobAdView, Object);

    static PoingGodotAdMobAdView *instance;
    static void _bind_methods();

public:
    int create(Dictionary adViewDictionary);
    void load_ad(int uid, Dictionary adRequestDictionary, PackedStringArray keywords);
    void destroy(int uid);
    void hide(int uid);
    void show(int uid);
    int get_width(int uid);
    int get_height(int uid);
    int get_width_in_pixels(int uid);
    int get_height_in_pixels(int uid);

    static PoingGodotAdMobAdView *get_singleton();

    PoingGodotAdMobAdView();
    ~PoingGodotAdMobAdView();
};


#endif /* PoingGodotAdMobAdView_h */

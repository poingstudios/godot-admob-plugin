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

#import "PoingGodotAdMobInterstitialAd.h"

PoingGodotAdMobInterstitialAd *PoingGodotAdMobInterstitialAd::instance = NULL;

PoingGodotAdMobInterstitialAd::PoingGodotAdMobInterstitialAd() {
    ERR_FAIL_COND(instance != NULL);

    instance = this;
}

PoingGodotAdMobInterstitialAd::~PoingGodotAdMobInterstitialAd() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobInterstitialAd *PoingGodotAdMobInterstitialAd::get_singleton() {
    return instance;
};

int PoingGodotAdMobInterstitialAd::create() {
    NSLog(@"create interstitialAd");
    
    int uid = (int)objectVector.size();
    objectVector.push_back(nullptr);

    return uid;
}

void PoingGodotAdMobInterstitialAd::load(String adUnitId, Dictionary adRequestDictionary, PackedStringArray keywords, int uid) {
    NSLog(@"load_ad interstitialAd");
    GADRequest *adRequest = [GodotDictionaryToObject convertDictionaryToGADRequest:adRequestDictionary withKeywords:keywords];

    InterstitialAd *interstitialAd = [[InterstitialAd alloc] initWithUID:uid];
    [interstitialAd load:adRequest withAdUnitId:[NSString stringWithUTF8String:adUnitId.utf8().get_data()]];
}

void PoingGodotAdMobInterstitialAd::destroy(int uid) {
    InterstitialAd* interstitialAd = getObject(uid);

    if (interstitialAd) {
        objectVector.at(uid) = nullptr; //just set to null in order to try to clean up memory
    }
}

void PoingGodotAdMobInterstitialAd::show(int uid) {
    NSLog(@"show interstitialAd");
    InterstitialAd* interstitialAd = getObject(uid);
    if (interstitialAd) {
        [interstitialAd show];
    }
}


void PoingGodotAdMobInterstitialAd::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create"),    &PoingGodotAdMobInterstitialAd::create);
    ClassDB::bind_method(D_METHOD("load"),      &PoingGodotAdMobInterstitialAd::load);
    ClassDB::bind_method(D_METHOD("show"),      &PoingGodotAdMobInterstitialAd::show);
    ClassDB::bind_method(D_METHOD("destroy"),   &PoingGodotAdMobInterstitialAd::destroy);
    
    ADD_SIGNAL(MethodInfo("on_interstitial_ad_failed_to_load",                      PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "loadAdErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_interstitial_ad_loaded",                              PropertyInfo(Variant::INT, "UID")));

    ADD_SIGNAL(MethodInfo("on_interstitial_ad_clicked",                             PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_interstitial_ad_dismissed_full_screen_content",       PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_interstitial_ad_failed_to_show_full_screen_content",  PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "adErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_interstitial_ad_impression",                          PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_interstitial_ad_showed_full_screen_content",          PropertyInfo(Variant::INT, "UID")));
};

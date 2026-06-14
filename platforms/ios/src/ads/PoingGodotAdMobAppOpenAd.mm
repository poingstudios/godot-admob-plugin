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

#import "PoingGodotAdMobAppOpenAd.h"
#import "adformats/AppOpenAd.h"
#include "core/variant/variant.h"

PoingGodotAdMobAppOpenAd *PoingGodotAdMobAppOpenAd::instance = NULL;

PoingGodotAdMobAppOpenAd::PoingGodotAdMobAppOpenAd() {
    ERR_FAIL_COND(instance != NULL);

    instance = this;
}

PoingGodotAdMobAppOpenAd::~PoingGodotAdMobAppOpenAd() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobAppOpenAd *PoingGodotAdMobAppOpenAd::get_singleton() {
    return instance;
};

int PoingGodotAdMobAppOpenAd::create() {
    NSLog(@"create appOpenAd");
    
    int uid = (int)objectVector.size();
    objectVector.push_back(nullptr);

    return uid;
}

void PoingGodotAdMobAppOpenAd::load(String adUnitId, Dictionary adRequestDictionary, PackedStringArray keywords, int uid) {
    NSLog(@"load_ad appOpenAd");
    GADRequest *adRequest = [GodotDictionaryToObject convertDictionaryToGADRequest:adRequestDictionary withKeywords:keywords];

    AppOpenAd *appOpenAd = [[AppOpenAd alloc] initWithUID:uid];
    [appOpenAd load:adRequest withAdUnitId:[NSString stringWithUTF8String:adUnitId.utf8().get_data()]];
}

void PoingGodotAdMobAppOpenAd::destroy(int uid) {
    AppOpenAd* appOpenAd = this->getObject(uid);

    if (appOpenAd) {
        this->objectVector.at(uid) = nullptr;
    }
}

void PoingGodotAdMobAppOpenAd::show(int uid) {
    NSLog(@"show appOpenAd");
    AppOpenAd* appOpenAd = this->getObject(uid);
    if (appOpenAd) {
        [appOpenAd show];
    }
}

String PoingGodotAdMobAppOpenAd::get_ad_unit_id(int uid) {
    AppOpenAd* appOpenAd = this->getObject(uid);
    if (appOpenAd && appOpenAd.appOpenAd) {
        return [appOpenAd.appOpenAd.adUnitID UTF8String];
    }
    return "";
}

Dictionary PoingGodotAdMobAppOpenAd::get_response_info(int uid) {
    AppOpenAd* appOpenAd = this->getObject(uid);
    if (appOpenAd && appOpenAd.appOpenAd && appOpenAd.appOpenAd.responseInfo) {
        return [ObjectToGodotDictionary convertResponseInfoToDictionary:appOpenAd.appOpenAd.responseInfo];
    }
    return Dictionary();
}

void PoingGodotAdMobAppOpenAd::set_placement_id(int uid, int placementId) {
    AppOpenAd* appOpenAd = this->getObject(uid);
    if (appOpenAd) {
        appOpenAd.placementId = placementId;
    }
}

int PoingGodotAdMobAppOpenAd::get_placement_id(int uid) {
    AppOpenAd* appOpenAd = this->getObject(uid);
    if (appOpenAd) {
        return appOpenAd.placementId;
    }
    return 0;
}

void PoingGodotAdMobAppOpenAd::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create"),    &PoingGodotAdMobAppOpenAd::create);
    ClassDB::bind_method(D_METHOD("load"),      &PoingGodotAdMobAppOpenAd::load);
    ClassDB::bind_method(D_METHOD("show"),      &PoingGodotAdMobAppOpenAd::show);
    ClassDB::bind_method(D_METHOD("destroy"),   &PoingGodotAdMobAppOpenAd::destroy);
    
    ClassDB::bind_method(D_METHOD("get_ad_unit_id"),    &PoingGodotAdMobAppOpenAd::get_ad_unit_id);
    ClassDB::bind_method(D_METHOD("get_response_info"), &PoingGodotAdMobAppOpenAd::get_response_info);
    ClassDB::bind_method(D_METHOD("set_placement_id"),  &PoingGodotAdMobAppOpenAd::set_placement_id);
    ClassDB::bind_method(D_METHOD("get_placement_id"),  &PoingGodotAdMobAppOpenAd::get_placement_id);
    
    ADD_SIGNAL(MethodInfo("on_app_open_ad_failed_to_load",                      PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "loadAdErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_app_open_ad_loaded",                              PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_app_open_ad_paid",                                PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "adValueDictionary")));

    ADD_SIGNAL(MethodInfo("on_app_open_ad_clicked",                             PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_app_open_ad_dismissed_full_screen_content",       PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_app_open_ad_failed_to_show_full_screen_content",  PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "adErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_app_open_ad_impression",                          PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_app_open_ad_showed_full_screen_content",          PropertyInfo(Variant::INT, "UID")));
};

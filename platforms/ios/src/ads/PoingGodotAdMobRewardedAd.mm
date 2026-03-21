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

#import "PoingGodotAdMobRewardedAd.h"

PoingGodotAdMobRewardedAd *PoingGodotAdMobRewardedAd::instance = NULL;

PoingGodotAdMobRewardedAd::PoingGodotAdMobRewardedAd() {
    ERR_FAIL_COND(instance != NULL);

    instance = this;
}

PoingGodotAdMobRewardedAd::~PoingGodotAdMobRewardedAd() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobRewardedAd *PoingGodotAdMobRewardedAd::get_singleton() {
    return instance;
};

int PoingGodotAdMobRewardedAd::create() {
    NSLog(@"create RewardedAd");
    
    int uid = (int)objectVector.size();
    objectVector.push_back(nullptr);

    return uid;
}

void PoingGodotAdMobRewardedAd::load(String adUnitId, Dictionary adRequestDictionary, PackedStringArray keywords, int uid) {
    NSLog(@"load_ad RewardedAd");
    GADRequest *adRequest = [GodotDictionaryToObject convertDictionaryToGADRequest:adRequestDictionary withKeywords:keywords];

    RewardedAd *ad = [[RewardedAd alloc] initWithUID:uid];
    [ad load:adRequest withAdUnitId:[NSString stringWithUTF8String:adUnitId.utf8().get_data()]];
}

void PoingGodotAdMobRewardedAd::destroy(int uid) {
    RewardedAd* ad = getObject(uid);

    if (ad) {
        objectVector.at(uid) = nullptr; //just set to null in order to try to clean up memory
    }
}

void PoingGodotAdMobRewardedAd::show(int uid) {
    NSLog(@"show RewardedAd");
    RewardedAd* ad = getObject(uid);
    if (ad) {
        [ad show];
    }
}


void PoingGodotAdMobRewardedAd::set_server_side_verification_options(int uid, Dictionary serverSideVerificationOptionsDictionary) {
    NSLog(@"set_server_side_verification_options");

    RewardedAd* ad = getObject(uid);
    if (ad) {
        GADServerSideVerificationOptions *serverSideVerificationOptions = [GodotDictionaryToObject convertDictionaryToGADServerSideVerificationOptions:serverSideVerificationOptionsDictionary];
        [ad setServerSideVerificationOptions:serverSideVerificationOptions];
    }
}


void PoingGodotAdMobRewardedAd::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create"),    &PoingGodotAdMobRewardedAd::create);
    ClassDB::bind_method(D_METHOD("load"),      &PoingGodotAdMobRewardedAd::load);
    ClassDB::bind_method(D_METHOD("show"),      &PoingGodotAdMobRewardedAd::show);
    ClassDB::bind_method(D_METHOD("destroy"),   &PoingGodotAdMobRewardedAd::destroy);
    ClassDB::bind_method(D_METHOD("set_server_side_verification_options"),   &PoingGodotAdMobRewardedAd::set_server_side_verification_options);

    ADD_SIGNAL(MethodInfo("on_rewarded_ad_failed_to_load",                      PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "loadAdErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_rewarded_ad_loaded",                              PropertyInfo(Variant::INT, "UID")));

    ADD_SIGNAL(MethodInfo("on_rewarded_ad_clicked",                             PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_rewarded_ad_dismissed_full_screen_content",       PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_rewarded_ad_failed_to_show_full_screen_content",  PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "adErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_rewarded_ad_impression",                          PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_rewarded_ad_showed_full_screen_content",          PropertyInfo(Variant::INT, "UID")));

    ADD_SIGNAL(MethodInfo("on_rewarded_ad_user_earned_reward",          PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "rewardedItemDictionary")));
};

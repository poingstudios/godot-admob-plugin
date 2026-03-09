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

#import "PoingGodotAdMobRewardedInterstitialAd.h"

PoingGodotAdMobRewardedInterstitialAd *PoingGodotAdMobRewardedInterstitialAd::instance = NULL;

PoingGodotAdMobRewardedInterstitialAd::PoingGodotAdMobRewardedInterstitialAd() {
    ERR_FAIL_COND(instance != NULL);

    instance = this;
}

PoingGodotAdMobRewardedInterstitialAd::~PoingGodotAdMobRewardedInterstitialAd() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobRewardedInterstitialAd *PoingGodotAdMobRewardedInterstitialAd::get_singleton() {
    return instance;
};

int PoingGodotAdMobRewardedInterstitialAd::create() {
    NSLog(@"create RewardedInterstitialAd");
    
    int uid = (int)objectVector.size();
    objectVector.push_back(nullptr);

    return uid;
}

void PoingGodotAdMobRewardedInterstitialAd::load(String adUnitId, Dictionary adRequestDictionary, PackedStringArray keywords, int uid) {
    NSLog(@"load_ad RewardedInterstitialAd");
    GADRequest *adRequest = [GodotDictionaryToObject convertDictionaryToGADRequest:adRequestDictionary withKeywords:keywords];

    RewardedInterstitialAd *ad = [[RewardedInterstitialAd alloc] initWithUID:uid];
    [ad load:adRequest withAdUnitId:[NSString stringWithUTF8String:adUnitId.utf8().get_data()]];
}

void PoingGodotAdMobRewardedInterstitialAd::destroy(int uid) {
    RewardedInterstitialAd* ad = getObject(uid);

    if (ad) {
        objectVector.at(uid) = nullptr; //just set to null in order to try to clean up memory
    }
}

void PoingGodotAdMobRewardedInterstitialAd::show(int uid) {
    NSLog(@"show RewardedInterstitialAd");
    RewardedInterstitialAd* ad = getObject(uid);
    if (ad) {
        [ad show];
    }
}


void PoingGodotAdMobRewardedInterstitialAd::set_server_side_verification_options(int uid, Dictionary serverSideVerificationOptionsDictionary) {
    NSLog(@"set_server_side_verification_options");

    RewardedInterstitialAd* ad = getObject(uid);
    if (ad) {
        GADServerSideVerificationOptions *serverSideVerificationOptions = [GodotDictionaryToObject convertDictionaryToGADServerSideVerificationOptions:serverSideVerificationOptionsDictionary];
        [ad setServerSideVerificationOptions:serverSideVerificationOptions];
    }
}


void PoingGodotAdMobRewardedInterstitialAd::_bind_methods() {
    ClassDB::bind_method(D_METHOD("create"),    &PoingGodotAdMobRewardedInterstitialAd::create);
    ClassDB::bind_method(D_METHOD("load"),      &PoingGodotAdMobRewardedInterstitialAd::load);
    ClassDB::bind_method(D_METHOD("show"),      &PoingGodotAdMobRewardedInterstitialAd::show);
    ClassDB::bind_method(D_METHOD("destroy"),   &PoingGodotAdMobRewardedInterstitialAd::destroy);
    ClassDB::bind_method(D_METHOD("set_server_side_verification_options"),   &PoingGodotAdMobRewardedInterstitialAd::set_server_side_verification_options);

    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_failed_to_load",                      PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "loadAdErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_loaded",                              PropertyInfo(Variant::INT, "UID")));

    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_clicked",                             PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_dismissed_full_screen_content",       PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_failed_to_show_full_screen_content",  PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "adErrorDictionary")));
    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_impression",                          PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_showed_full_screen_content",          PropertyInfo(Variant::INT, "UID")));

    ADD_SIGNAL(MethodInfo("on_rewarded_interstitial_ad_user_earned_reward",          PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "rewardedItemDictionary")));
};

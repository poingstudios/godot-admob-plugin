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

#import "PoingGodotAdMobModule.h"
#include "core/config/engine.h"


PoingGodotAdMob *poing_godot_admob;
PoingGodotAdMobAdSize *poing_godot_admob_ad_size;
PoingGodotAdMobAdView *poing_godot_admob_ad_view;
PoingGodotAdMobInterstitialAd *poing_godot_admob_interstitial_ad;
PoingGodotAdMobRewardedAd *poing_godot_admob_rewarded_ad;
PoingGodotAdMobRewardedInterstitialAd *poing_godot_admob_rewarded_interstitial_ad;
PoingGodotAdMobConsentInformation *poing_godot_admob_consent_information;
PoingGodotAdMobUserMessagingPlatform *poing_godot_admob_user_messaging_platform;

void register_poing_godot_admob_ads_types() {
    poing_godot_admob = memnew(PoingGodotAdMob);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMob", poing_godot_admob));
    
    poing_godot_admob_ad_size = memnew(PoingGodotAdMobAdSize);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobAdSize", poing_godot_admob_ad_size));
    
    poing_godot_admob_ad_view = memnew(PoingGodotAdMobAdView);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobAdView", poing_godot_admob_ad_view));
    
    poing_godot_admob_interstitial_ad = memnew(PoingGodotAdMobInterstitialAd);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobInterstitialAd", poing_godot_admob_interstitial_ad));
    
    poing_godot_admob_rewarded_ad = memnew(PoingGodotAdMobRewardedAd);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobRewardedAd", poing_godot_admob_rewarded_ad));
    
    poing_godot_admob_rewarded_interstitial_ad = memnew(PoingGodotAdMobRewardedInterstitialAd);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobRewardedInterstitialAd", poing_godot_admob_rewarded_interstitial_ad));
    
    poing_godot_admob_consent_information = memnew(PoingGodotAdMobConsentInformation);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobConsentInformation", poing_godot_admob_consent_information));
    
    poing_godot_admob_user_messaging_platform = memnew(PoingGodotAdMobUserMessagingPlatform);
    Engine::get_singleton()->add_singleton(Engine::Singleton("PoingGodotAdMobUserMessagingPlatform", poing_godot_admob_user_messaging_platform));
}

void unregister_poing_godot_admob_ads_types() {
    if (poing_godot_admob) {
        memdelete(poing_godot_admob);
    }
    if (poing_godot_admob_ad_size) {
        memdelete(poing_godot_admob_ad_size);
    }
    if (poing_godot_admob_ad_view) {
        memdelete(poing_godot_admob_ad_view);
    }
    if (poing_godot_admob_interstitial_ad) {
        memdelete(poing_godot_admob_interstitial_ad);
    }
    if (poing_godot_admob_rewarded_ad) {
        memdelete(poing_godot_admob_rewarded_ad);
    }
    if (poing_godot_admob_rewarded_interstitial_ad) {
        memdelete(poing_godot_admob_rewarded_interstitial_ad);
    }
    if (poing_godot_admob_consent_information) {
        memdelete(poing_godot_admob_consent_information);
    }
    if (poing_godot_admob_user_messaging_platform) {
        memdelete(poing_godot_admob_user_messaging_platform);
    }
}

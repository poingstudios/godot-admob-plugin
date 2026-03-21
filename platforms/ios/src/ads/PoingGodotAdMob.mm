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

#import "PoingGodotAdMob.h"

PoingGodotAdMob *PoingGodotAdMob::instance = NULL;

PoingGodotAdMob::PoingGodotAdMob() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMob::~PoingGodotAdMob() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMob *PoingGodotAdMob::get_singleton() {
    return instance;
};

void PoingGodotAdMob::initialize() {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus *_Nonnull status)
    {
        Dictionary dictionary = [ObjectToGodotDictionary convertGADInitializationStatusToDictionary:status];
        emit_signal("on_initialization_complete", dictionary);
    }];
}
void PoingGodotAdMob::set_request_configuration(Dictionary requestConfigurationDictionary, PackedStringArray testDeviceIds) {
    String maxAdContentRating = requestConfigurationDictionary["max_ad_content_rating"];
    int tagForChildDirectedTreatment = requestConfigurationDictionary["tag_for_child_directed_treatment"];
    int tagForUnderAgeOfConsent = requestConfigurationDictionary["tag_for_under_age_of_consent"];
    
    GADRequestConfiguration *requestConfiguration = [GADMobileAds sharedInstance].requestConfiguration;

    if (!maxAdContentRating.is_empty())
        requestConfiguration.maxAdContentRating = [NSString stringWithUTF8String:maxAdContentRating.utf8().get_data()];

    if (tagForChildDirectedTreatment >= 0)
        requestConfiguration.tagForChildDirectedTreatment = [NSNumber numberWithInt:tagForChildDirectedTreatment];
    
    if (tagForUnderAgeOfConsent >= 0)
        requestConfiguration.tagForUnderAgeOfConsent = [NSNumber numberWithInt:tagForUnderAgeOfConsent];
        
    NSMutableArray<NSString *> *testDeviceIdsArray = [NSMutableArray arrayWithCapacity:testDeviceIds.size() + 1];
    for (String deviceId : testDeviceIds) {
        [testDeviceIdsArray addObject:[NSString stringWithUTF8String:deviceId.utf8().get_data()]];
    }
    
    requestConfiguration.testDeviceIdentifiers = testDeviceIdsArray;
    NSLog(@"AdMob requestConfiguration: maxAdContentRating=%@, tagForChildDirectedTreatment=%@, tagForUnderAgeOfConsent=%@, testDeviceIds=%@", 
        requestConfiguration.maxAdContentRating, requestConfiguration.tagForChildDirectedTreatment, requestConfiguration.tagForUnderAgeOfConsent, requestConfiguration.testDeviceIdentifiers
    );
}

Dictionary PoingGodotAdMob::get_initialization_status() {
    return [ObjectToGodotDictionary convertGADInitializationStatusToDictionary: [GADMobileAds sharedInstance].initializationStatus];
}

void PoingGodotAdMob::set_ios_app_pause_on_background(bool pause) {
    [StaticVariablesHelper setPauseOnBackground:pause];
}

void PoingGodotAdMob::set_app_volume(float volume) {
    float clampedVolume = CLAMP(volume, 0.0f, 1.0f);
    [GADMobileAds sharedInstance].applicationVolume = (CGFloat)clampedVolume;
}

void PoingGodotAdMob::set_app_muted(bool muted) {
    [GADMobileAds sharedInstance].applicationMuted = muted;
}

void PoingGodotAdMob::_bind_methods() {
    ADD_SIGNAL(MethodInfo("on_initialization_complete", PropertyInfo(Variant::DICTIONARY, "initialization_status_dictionary")));

    ClassDB::bind_method(D_METHOD("initialize"), &PoingGodotAdMob::initialize);
    ClassDB::bind_method(D_METHOD("set_request_configuration"), &PoingGodotAdMob::set_request_configuration);
    ClassDB::bind_method(D_METHOD("get_initialization_status"), &PoingGodotAdMob::get_initialization_status);
    ClassDB::bind_method(D_METHOD("set_ios_app_pause_on_background"), &PoingGodotAdMob::set_ios_app_pause_on_background);
    ClassDB::bind_method(D_METHOD("set_app_volume"), &PoingGodotAdMob::set_app_volume);
    ClassDB::bind_method(D_METHOD("set_app_muted"), &PoingGodotAdMob::set_app_muted);
};

// MIT License
//
// Copyright (c) 2026-present Poing Studios
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

#import "PoingGodotAdMobUnityAds.h"

PoingGodotAdMobUnityAds *PoingGodotAdMobUnityAds::instance = NULL;

PoingGodotAdMobUnityAds::PoingGodotAdMobUnityAds() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobUnityAds::~PoingGodotAdMobUnityAds() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobUnityAds *PoingGodotAdMobUnityAds::get_singleton() {
    return instance;
}

void PoingGodotAdMobUnityAds::set_consent(bool consent) {
    UADSMetaData *metaData = [[UADSMetaData alloc] init];
    [metaData setRaw:@"gdpr.consent" value:consent ? @YES : @NO];
    [metaData commit];
    NSLog(@"set unityads consent: %d", consent);
}

void PoingGodotAdMobUnityAds::set_privacy_consent(String privacy_type, bool consent) {
    NSString *privacyType = [NSString stringWithUTF8String:privacy_type.utf8().get_data()];
    UADSMetaData *metaData = [[UADSMetaData alloc] init];
    [metaData setRaw:privacyType value:consent ? @YES : @NO];
    [metaData commit];
    NSLog(@"set unityads privacy consent: %@, value: %d", privacyType, consent);
}

void PoingGodotAdMobUnityAds::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_consent"), &PoingGodotAdMobUnityAds::set_consent);
    ClassDB::bind_method(D_METHOD("set_privacy_consent"), &PoingGodotAdMobUnityAds::set_privacy_consent);
}

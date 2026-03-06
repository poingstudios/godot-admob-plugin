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

#import "PoingGodotAdMobMetaFBAdSettings.h"

PoingGodotAdMobMetaFBAdSettings *PoingGodotAdMobMetaFBAdSettings::instance = NULL;

PoingGodotAdMobMetaFBAdSettings::PoingGodotAdMobMetaFBAdSettings() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobMetaFBAdSettings::~PoingGodotAdMobMetaFBAdSettings() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobMetaFBAdSettings *PoingGodotAdMobMetaFBAdSettings::get_singleton() {
    return instance;
};

void PoingGodotAdMobMetaFBAdSettings::set_advertiser_tracking_enabled(bool tracking_required) {
    NSOperatingSystemVersion iOS14Version = { .majorVersion = 14, .minorVersion = 0, .patchVersion = 0 };

    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:iOS14Version]) {
        NSLog(@"FBAdSettings set_advertiser_tracking_enabled, %@", tracking_required ? @"YES" : @"NO");
        [FBAdSettings setAdvertiserTrackingEnabled:tracking_required];
    } else {
        NSLog(@"not executing set_advertiser_tracking_enabled because the iOS version is below 14");
    }
}

void PoingGodotAdMobMetaFBAdSettings::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_advertiser_tracking_enabled"), &PoingGodotAdMobMetaFBAdSettings::set_advertiser_tracking_enabled);
}

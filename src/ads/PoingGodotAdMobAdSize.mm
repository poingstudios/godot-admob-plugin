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

#import "PoingGodotAdMobAdSize.h"

PoingGodotAdMobAdSize *PoingGodotAdMobAdSize::instance = NULL;

static const int FULL_WIDTH = -1;

PoingGodotAdMobAdSize::PoingGodotAdMobAdSize() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;

}

PoingGodotAdMobAdSize::~PoingGodotAdMobAdSize() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobAdSize *PoingGodotAdMobAdSize::get_singleton() {
    return instance;
};

Dictionary PoingGodotAdMobAdSize::getCurrentOrientationAnchoredAdaptiveBannerAdSize(int width) {
    NSLog(@"calling getCurrentOrientationAnchoredAdaptiveBannerAdSize");
    int currentWidth = (width == FULL_WIDTH) ? getAdWidth() : width;
    NSLog(@"currentWidth: %i", currentWidth);

    GADAdSize adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(currentWidth);
    Dictionary dictionary = [ObjectToGodotDictionary convertGADAdSizeToDictionary:adSize];

    return dictionary;
}

Dictionary PoingGodotAdMobAdSize::getPortraitAnchoredAdaptiveBannerAdSize(int width) {
    NSLog(@"calling getCurrentOrientationAnchoredAdaptiveBannerAdSize");
    int currentWidth = (width == FULL_WIDTH) ? getAdWidth() : width;
    NSLog(@"currentWidth: %i", currentWidth);

    GADAdSize adSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(currentWidth);
    Dictionary dictionary = [ObjectToGodotDictionary convertGADAdSizeToDictionary:adSize];

    return dictionary;
}

Dictionary PoingGodotAdMobAdSize::getLandscapeAnchoredAdaptiveBannerAdSize(int width) {
    NSLog(@"calling getCurrentOrientationAnchoredAdaptiveBannerAdSize");
    int currentWidth = (width == FULL_WIDTH) ? getAdWidth() : width;
    NSLog(@"currentWidth: %i", currentWidth);

    GADAdSize adSize = GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(currentWidth);
    Dictionary dictionary = [ObjectToGodotDictionary convertGADAdSizeToDictionary:adSize];

    return dictionary;
}
Dictionary PoingGodotAdMobAdSize::getSmartBannerAdSize() {
    NSLog(@"calling getCurrentOrientationAnchoredAdaptiveBannerAdSize");

    GADAdSize adSize;

    UIInterfaceOrientation orientation = [DeviceOrientationHelper getDeviceOrientation];

    if (UIInterfaceOrientationIsPortrait(orientation)) { //portrait
        adSize = kGADAdSizeSmartBannerPortrait;
        NSLog(@"UIDeviceOrientation: Portrait");
    }
    else { //landscape
        adSize = kGADAdSizeSmartBannerLandscape;
        NSLog(@"UIDeviceOrientation: Landscape");
    }

    Dictionary dictionary = [ObjectToGodotDictionary convertGADAdSizeToDictionary:adSize];

    return dictionary;
}

void PoingGodotAdMobAdSize::_bind_methods() {
    ClassDB::bind_method(D_METHOD("getCurrentOrientationAnchoredAdaptiveBannerAdSize"), &PoingGodotAdMobAdSize::getCurrentOrientationAnchoredAdaptiveBannerAdSize);
    ClassDB::bind_method(D_METHOD("getPortraitAnchoredAdaptiveBannerAdSize"), &PoingGodotAdMobAdSize::getPortraitAnchoredAdaptiveBannerAdSize);
    ClassDB::bind_method(D_METHOD("getLandscapeAnchoredAdaptiveBannerAdSize"), &PoingGodotAdMobAdSize::getLandscapeAnchoredAdaptiveBannerAdSize);
    ClassDB::bind_method(D_METHOD("getSmartBannerAdSize"), &PoingGodotAdMobAdSize::getSmartBannerAdSize);
};


CGFloat PoingGodotAdMobAdSize::getAdWidth() {
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    CGRect frame = rootView.frame;

    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = rootView.safeAreaInsets;
        frame = UIEdgeInsetsInsetRect(frame, safeAreaInsets);
    }
    
    return frame.size.width;
}

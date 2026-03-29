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

#import "AppOpenAd.h"
#import "../PoingGodotAdMobAppOpenAd.h"
#import "os_ios.h"
#import <UIKit/UIKit.h>

@implementation AppOpenAd

- (instancetype)initWithUID:(int)UID{
    if ((self = [super init])) {
        self.UID = [NSNumber numberWithInt:UID];
    }
    return self;
}

- (void)load:(GADRequest *)request withAdUnitId:(NSString*) adUnitId{
    [GADAppOpenAd loadWithAdUnitID:adUnitId
                                request:request
                      completionHandler:^(GADAppOpenAd *ad, NSError *error) {
        if (error) {
            PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_failed_to_load",
                                                                         [self.UID intValue],
                                                                         [ObjectToGodotDictionary convertNSErrorToDictionaryAsLoadAdError:error]);
            return;
        }
        self.appOpenAd = ad;
        self.appOpenAd.fullScreenContentDelegate = self;
        
        PoingGodotAdMobAppOpenAd::get_singleton()->objectVector.at([self.UID intValue]) = self;
        
        // Handle paid event
        __weak AppOpenAd *weakSelf = self;
        self.appOpenAd.paidEventHandler = ^(GADAdValue *_Nonnull value) {
            AppOpenAd *strongSelf = weakSelf;
            if (strongSelf) {
                Dictionary adValueDictionary = [ObjectToGodotDictionary convertGADAdValueToDictionary:value];
                PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_paid",
                                                                             [strongSelf.UID intValue],
                                                                             adValueDictionary);
            }
        };
        
        PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_loaded", [self.UID intValue]);
    }];
}

- (void)show {
    if (self.appOpenAd){
        [self.appOpenAd presentFromRootViewController:[self getRootViewController]];
    } else {
        NSLog(@"AppOpenAd: Error: self.appOpenAd is nil");
    }
}

/// Tells the delegate that the ad ad clicked.
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad{
    PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_clicked", [self.UID intValue]);
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad{
    PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_dismissed_full_screen_content", [self.UID intValue]);
    OS_IOS::get_singleton()->on_focus_in();
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error{
    PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_failed_to_show_full_screen_content",
                                                                 [self.UID intValue],
                                                                 [ObjectToGodotDictionary convertNSErrorToDictionaryAsAdError:error]);
}

/// Tells the delegate that the ad recorded an impression.
- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad{
    PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_impression", [self.UID intValue]);
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad{
    PoingGodotAdMobAppOpenAd::get_singleton()->emit_signal("on_app_open_ad_showed_full_screen_content", [self.UID intValue]);
}

/// Tells the delegate that the ad will present full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"AppOpenAd: Ad will present full screen content.");
    
    NSLog(@"AppOpenAd: pauseOnBackground %s", StaticVariablesHelper.pauseOnBackground ? "true" : "false");

    if (StaticVariablesHelper.pauseOnBackground){
        OS_IOS::get_singleton()->on_focus_out();
    }
}

@end

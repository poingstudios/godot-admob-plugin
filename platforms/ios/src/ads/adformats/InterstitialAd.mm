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

#import "InterstitialAd.h"
#import "os_ios.h"

@implementation InterstitialAd
- (instancetype)initWithUID:(int)UID{
    if ((self = [super init])) {
        self.UID = [NSNumber numberWithInt:UID];
    }
    return self;
}

- (void)load:(GADRequest *)request withAdUnitId:(NSString*) adUnitId{
    [GADInterstitialAd loadWithAdUnitID:adUnitId
                                request:request
                      completionHandler:^(GADInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"sailed to load interstitial ad with error: %@", [error localizedDescription]);
            PoingGodotAdMobInterstitialAd::get_singleton()->emit_signal("on_interstitial_ad_failed_to_load",
                                                                        [self.UID intValue],
                                                                        [ObjectToGodotDictionary convertNSErrorToDictionaryAsLoadAdError:error]);
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
        
        PoingGodotAdMobInterstitialAd::get_singleton()->objectVector.at([self.UID intValue]) = self;
        NSLog(@"success to load interstitial");
        PoingGodotAdMobInterstitialAd::get_singleton()->emit_signal("on_interstitial_ad_loaded", [self.UID intValue]);
  }];
}

- (void)show {
    if (self.interstitial){
        UIViewController *rootViewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
        [self.interstitial presentFromRootViewController:rootViewController];
    }
    else{
        NSLog(@"interstitial ad wasn't ready");
    }
}


- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"interstitial adDidRecordImpression.");
    PoingGodotAdMobInterstitialAd::get_singleton()->emit_signal("on_interstitial_ad_impression", [self.UID intValue]);
}
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"interstitial adDidRecordClick.");
    PoingGodotAdMobInterstitialAd::get_singleton()->emit_signal("on_interstitial_ad_clicked", [self.UID intValue]);
}
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"interstitial Ad did fail to present full screen content.");
    PoingGodotAdMobInterstitialAd::get_singleton()->emit_signal("on_interstitial_ad_failed_to_show_full_screen_content",
                                                                [self.UID intValue],
                                                                [ObjectToGodotDictionary convertNSErrorToDictionaryAsAdError:error]);
}
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"interstitial Ad will present full screen content.");
    PoingGodotAdMobInterstitialAd::get_singleton()->emit_signal("on_interstitial_ad_showed_full_screen_content",
                                                                [self.UID intValue]);
    
    NSLog(@"pauseOnBackground %s", StaticVariablesHelper.pauseOnBackground ? "true" : "false");

    if (StaticVariablesHelper.pauseOnBackground){
        OS_IOS::get_singleton()->on_focus_out();
    }
}
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"interstitial Ad did dismiss full screen content.");
    PoingGodotAdMobInterstitialAd::get_singleton()->emit_signal("on_interstitial_ad_dismissed_full_screen_content", [self.UID intValue]);
    OS_IOS::get_singleton()->on_focus_in();
}

@end

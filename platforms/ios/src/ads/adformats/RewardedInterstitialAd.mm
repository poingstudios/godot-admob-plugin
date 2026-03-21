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

#import "RewardedInterstitialAd.h"
#include "os_ios.h"

@implementation RewardedInterstitialAd
- (instancetype)initWithUID:(int)UID{
    if ((self = [super init])) {
        self.UID = [NSNumber numberWithInt:UID];
    }
    return self;
}

- (void)load:(GADRequest *)request withAdUnitId:(NSString*) adUnitId{
    [GADRewardedInterstitialAd loadWithAdUnitID:adUnitId
                                request:request
                      completionHandler:^(GADRewardedInterstitialAd *ad, NSError *error) {
        if (error) {
            NSLog(@"Rewarded Interstitial ad failed to load with error: %@", [error localizedDescription]);
            PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_failed_to_load",
                                                                        [self.UID intValue],
                                                                        [ObjectToGodotDictionary convertNSErrorToDictionaryAsLoadAdError:error]);
            return;
        }
        self.rewarded = ad;
        self.rewarded.fullScreenContentDelegate = self;
        
        PoingGodotAdMobRewardedInterstitialAd::get_singleton()->objectVector.at([self.UID intValue]) = self;
        NSLog(@"success to load RewardedInterstitialAd");
        PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_loaded", [self.UID intValue]);
  }];
}

- (void)show {
    if (self.rewarded){
        UIViewController *rootViewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
        [self.rewarded presentFromRootViewController:rootViewController
                               userDidEarnRewardHandler:^{
             GADAdReward *reward = self.rewarded.adReward;
             PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_user_earned_reward",
                                                                     [self.UID intValue],
                                                                     [ObjectToGodotDictionary convertGADAdRewardToDictionary:reward]);
         }];
    }
    else{
        NSLog(@"RewardedInterstitialAd wasn't ready");
    }
}

- (void)setServerSideVerificationOptions:(GADServerSideVerificationOptions *)options{
    if (self.rewarded){
        NSLog(@"RewardedInterstitialAd setServerSideVerificationOptions");
        self.rewarded.serverSideVerificationOptions = options;
    }
}


- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"RewardedInterstitialAd adDidRecordImpression.");
    PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_impression", [self.UID intValue]);
}
- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"RewardedInterstitialAd adDidRecordClick.");
    PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_clicked", [self.UID intValue]);
}
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"RewardedInterstitialAd did fail to present full screen content.");
    PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_failed_to_show_full_screen_content",
                                                                [self.UID intValue],
                                                                [ObjectToGodotDictionary convertNSErrorToDictionaryAsAdError:error]);
}
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"RewardedInterstitialAd will present full screen content.");
    PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_showed_full_screen_content",
                                                                [self.UID intValue]);

    NSLog(@"pauseOnBackground %s", StaticVariablesHelper.pauseOnBackground ? "true" : "false");

    if (StaticVariablesHelper.pauseOnBackground){
        OS_IOS::get_singleton()->on_focus_out();
    }
}
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"RewardedInterstitialAd did dismiss full screen content.");
    PoingGodotAdMobRewardedInterstitialAd::get_singleton()->emit_signal("on_rewarded_interstitial_ad_dismissed_full_screen_content", [self.UID intValue]);
    OS_IOS::get_singleton()->on_focus_in();
}

@end

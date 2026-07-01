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

//
//  Rewarded.mm
//  Rewarded
//
//  Created by Gustavo Maciel on 24/01/21.
//

#import "Rewarded.h"

@implementation Rewarded

- (instancetype)initWithRequestAgent:(NSString*) p_google_request_agent{
    if ((self = [super init])) {
        initialized = true;
        loaded = false;
        google_request_agent = p_google_request_agent;

        rootController = (ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    }
    return self;
}


- (void) load_rewarded:(NSString*) ad_unit_id {
    NSLog(@"Calling load_rewarded");
    
    if (!initialized || loaded) {
        return;
    }
    else{
        NSLog(@"rewarded will load with the id");
        NSLog(@"%@", ad_unit_id);
    }
        
    GADRequest *request = [GADRequest request];
    request.requestAgent = google_request_agent;
    NSLog(@"Rewarded request agent: %@", google_request_agent);
    [GADRewardedAd
         loadWithAdUnitID:ad_unit_id
                  request:request
        completionHandler:^(GADRewardedAd *ad, NSError *error) {
          if (error) {
              self->rewarded = nil;
              self->rewarded.fullScreenContentDelegate = nil;

              NSLog(@"Rewarded ad failed to load with error: %@", [error localizedDescription]);
              NSLog(@"error while creating reward");
              AdMob::get_singleton()->emit_signal("rewarded_ad_failed_to_load", (int) error.code);

            return;
          }
          else{
              self->rewarded = ad;
              self->rewarded.fullScreenContentDelegate = self;

              NSLog(@"reward successfully loaded");
              AdMob::get_singleton()->emit_signal("rewarded_ad_loaded");
              
              self->loaded = true;
          }
        }
     ];
    
}

- (void) show_rewarded {
    if (!initialized) {
        return;
    }
    
    if (rewarded) {
        [rewarded presentFromRootViewController:rootController userDidEarnRewardHandler:^{
            GADAdReward *rewardAd = self->rewarded.adReward;
            NSLog(@"rewardedAd:userDidEarnReward:");
            NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
                                       rewardAd.type, [rewardAd.amount doubleValue]];
            NSLog(@"%@", rewardMessage);

            AdMob::get_singleton()->emit_signal("user_earned_rewarded", [rewardAd.type UTF8String], rewardAd.amount.doubleValue);

          }];

        AdMob::get_singleton()->emit_signal("rewarded_ad_opened");

        #ifdef VERSION_4_0
        OS_IOS::get_singleton()->on_focus_out();
        #endif

        #ifdef VERSION_3_X
        OSIPhone::get_singleton()->on_focus_out();
        #endif
    } else {
        NSLog(@"reward ad wasn't ready");
    }
}

- (bool) get_is_rewarded_loaded {
    return loaded;
}
/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"rewardedAd:didFailToPresentWithError");
    AdMob::get_singleton()->emit_signal("rewarded_ad_failed_to_show", (int) error.code);

}


/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did dismiss full screen content.");
    loaded = false;
    
    AdMob::get_singleton()->emit_signal("rewarded_ad_closed");

    #ifdef VERSION_4_0
    OS_IOS::get_singleton()->on_focus_in();
    #endif

    #ifdef VERSION_3_X
    OSIPhone::get_singleton()->on_focus_in();
    #endif
}

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"rewarded adDidRecordImpression.");
    AdMob::get_singleton()->emit_signal("rewarded_ad_recorded_impression");
}

- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"rewarded clicked.");
    AdMob::get_singleton()->emit_signal("rewarded_ad_clicked");
}


@end

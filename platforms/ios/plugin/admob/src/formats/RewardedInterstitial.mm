//
//  RewardedInterstitial.mm
//  RewardedInterstitial
//
//  Created by Gustavo Maciel on 25/06/21.
//

#import "RewardedInterstitial.h"

@implementation RewardedInterstitial

- (instancetype)initWithRequestAgent:(NSString*) p_google_request_agent{
    if ((self = [super init])) {
        initialized = true;
        loaded = false;
        google_request_agent = p_google_request_agent;

        rootController = (ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    }
    return self;
}


- (void) load_rewarded_interstitial:(NSString*) ad_unit_id {
    NSLog(@"Calling load_rewarded_interstitial");
    
    if (!initialized || loaded) {
        return;
    }
    else{
        NSLog(@"rewarded interstitial will load with the id");
        NSLog(@"%@", ad_unit_id);
    }
        
    GADRequest *request = [GADRequest request];
    request.requestAgent = google_request_agent;
    NSLog(@"Rewarded Interstitial request agent: %@", google_request_agent);
    [GADRewardedInterstitialAd
         loadWithAdUnitID:ad_unit_id
                  request:request
        completionHandler:^(GADRewardedInterstitialAd *ad, NSError *error) {
          if (error) {
              self->rewardedInterstitialAd = nil;
              self->rewardedInterstitialAd.fullScreenContentDelegate = nil;

              NSLog(@"Rewarded interstitial ad failed to load with error: %@", [error localizedDescription]);
              NSLog(@"error while creating rewarded interstitial");
              AdMob::get_singleton()->emit_signal("rewarded_interstitial_ad_failed_to_load", (int) error.code);

              return;
          }
          else{
              self->rewardedInterstitialAd = ad;
              self->rewardedInterstitialAd.fullScreenContentDelegate = self;

              NSLog(@"reward interstitial successfully loaded");
              AdMob::get_singleton()->emit_signal("rewarded_interstitial_ad_loaded");

              self->loaded = true;

          }
        }
     ];
    
}

- (void) show_rewarded_interstitial {
    if (!initialized) {
        return;
    }
    
    if (rewardedInterstitialAd) {
        [rewardedInterstitialAd presentFromRootViewController:rootController userDidEarnRewardHandler:^{
            GADAdReward *rewardAd = self->rewardedInterstitialAd.adReward;
            NSLog(@"rewardedAd:userDidEarnReward:");
            NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf",
                                       rewardAd.type, [rewardAd.amount doubleValue]];
            NSLog(@"%@", rewardMessage);
            AdMob::get_singleton()->emit_signal("user_earned_rewarded", [rewardAd.type UTF8String], rewardAd.amount.doubleValue);


          }];

        AdMob::get_singleton()->emit_signal("rewarded_interstitial_ad_opened");

        #ifdef VERSION_4_0
        OS_IOS::get_singleton()->on_focus_out();
        #endif

        #ifdef VERSION_3_X
        OSIPhone::get_singleton()->on_focus_out();
        #endif

    } else {
        NSLog(@"reward interstitial ad wasn't ready");
    }
}

- (bool) get_is_rewarded_interstitial_loaded{
    return loaded;
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"rewardedAd:didFailToPresentWithError");
    AdMob::get_singleton()->emit_signal("rewarded_interstitial_ad_failed_to_show", (int) error.code);

}


/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"Ad did dismiss full screen content.");
    loaded = false;
    AdMob::get_singleton()->emit_signal("rewarded_interstitial_ad_closed");

    #ifdef VERSION_4_0
    OS_IOS::get_singleton()->on_focus_in();
    #endif

    #ifdef VERSION_3_X
    OSIPhone::get_singleton()->on_focus_in();
    #endif
}


- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"rewarded interstitial adDidRecordImpression.");
    AdMob::get_singleton()->emit_signal("rewarded_interstitial_ad_recorded_impression");
}


- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"rewarded interstitial clicked.");
    AdMob::get_singleton()->emit_signal("rewarded_interstitial_ad_clicked");
}


@end

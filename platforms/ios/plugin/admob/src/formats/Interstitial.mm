//
//  Interstitial.mm
//  Interstitial
//
//  Created by Gustavo Maciel on 24/01/21.
//

#import "Interstitial.h"

@implementation Interstitial

- (void)dealloc {
}

- (instancetype)initWithRequestAgent:(NSString*) p_google_request_agent{
    if ((self = [super init])) {
        initialized = true;
        loaded = false;
        google_request_agent = p_google_request_agent;

        rootController = (ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    }
    return self;
}


- (void) load_interstitial:(NSString*)ad_unit_id {
    NSLog(@"Calling load_interstitial");
    
    if (!initialized || loaded) {
        return;
    }
    else{
        NSLog(@"interstitial will load with the id");
        NSLog(@"%@", ad_unit_id);
    }
    
    
    GADRequest *request = [GADRequest request];
    request.requestAgent = google_request_agent;
    NSLog(@"Interstitial request agent: %@", google_request_agent);
    [GADInterstitialAd loadWithAdUnitID:ad_unit_id
                                    request:request
                          completionHandler:^(GADInterstitialAd *ad, NSError *error) {
      if (error) {
          self->interstitial = nil;
          self->interstitial.fullScreenContentDelegate = nil;

          NSLog(@"interstitial:didFailToReceiveAdWithError: %@", [error localizedDescription]);
          AdMob::get_singleton()->emit_signal("interstitial_failed_to_load", (int) error.code);

          return;
      }
      else{
          self->interstitial = ad;
          self->interstitial.fullScreenContentDelegate = self;

          NSLog(@"interstitial created with the id");
          NSLog(@"interstitialDidReceiveAd");
          AdMob::get_singleton()->emit_signal("interstitial_loaded");
          
          self->loaded = true;
      }

    }];
    
}

- (void) show_interstitial {
    if (!initialized) {
        return;
    }
    
    if (interstitial) {
        [interstitial presentFromRootViewController:rootController];
    } else {
        NSLog(@"Interstitial ad wasn't ready");
    }
}
- (bool) get_is_interstitial_loaded {
    return loaded;
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"interstitial didFailToPresentFullScreenContentWithError.");
    AdMob::get_singleton()->emit_signal("interstitial_failed_to_show", (int) error.code);
}

/// Tells the delegate that the ad presented full screen content.
- (void)adWillPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"interstitial adWillPresentFullScreenContent");
    AdMob::get_singleton()->emit_signal("interstitial_opened");
    #ifdef VERSION_4_0
    OS_IOS::get_singleton()->on_focus_out();
    #endif
    #ifdef VERSION_3_X
    OSIPhone::get_singleton()->on_focus_out();
    #endif
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    NSLog(@"interstitial adDidDismissFullScreenContent.");
    loaded = false;
    AdMob::get_singleton()->emit_signal("interstitial_closed");
    #ifdef VERSION_4_0
    OS_IOS::get_singleton()->on_focus_in();
    #endif

    #ifdef VERSION_3_X
    OSIPhone::get_singleton()->on_focus_in();
    #endif
}

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"interstitial adDidRecordImpression.");
    AdMob::get_singleton()->emit_signal("interstitial_recorded_impression");
}

- (void)adDidRecordClick:(nonnull id<GADFullScreenPresentingAd>)ad{
    NSLog(@"interstitial clicked.");
    AdMob::get_singleton()->emit_signal("interstitial_clicked");
}



@end

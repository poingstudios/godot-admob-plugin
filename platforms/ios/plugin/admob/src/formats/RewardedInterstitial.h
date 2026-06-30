//
//  RewardedInterstitial.h
//  RewardedInterstitial
//
//  Created by Gustavo Maciel on 25/06/21.
//

#import <GoogleMobileAds/GADRewardedAd.h>
#import <GoogleMobileAds/GADExtras.h>
#import "app_delegate.h"
#import "view_controller.h"

#ifdef VERSION_4_0
#include "os_ios.h"
#include "core/object/object.h"
#endif

#ifdef VERSION_3_X
#include "os_iphone.h"
#include "core/object.h"
#endif

#include "../main/admob.h"
#include "version_constants.h"

@class RewardedInterstitial;


@interface RewardedInterstitial: NSObject <GADFullScreenContentDelegate> {
    GADRewardedInterstitialAd *rewardedInterstitialAd;
    bool initialized;
    bool loaded;
    NSString *adUnitId;
    NSString *google_request_agent;
    ViewController *rootController;
}

- (instancetype)initWithRequestAgent:(NSString*) google_request_agent;
- (void)load_rewarded_interstitial: (NSString*) ad_unit_id;
- (void)show_rewarded_interstitial;
- (bool)get_is_rewarded_interstitial_loaded;

@end

//
//  Interstitial.h
//  Interstitial
//
//  Created by Gustavo Maciel on 24/01/21.
//


#import <GoogleMobileAds/GADInterstitialAd.h>
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


@class Interstitial;

@interface Interstitial: NSObject<GADFullScreenContentDelegate> {
    GADInterstitialAd * interstitial;
    bool initialized;
    bool loaded;
    NSString *adUnitId;
    NSString *google_request_agent;
    ViewController *rootController;
}


- (instancetype)initWithRequestAgent:(NSString*) google_request_agent;
- (void)load_interstitial: (NSString*)ad_unit_id;
- (void)show_interstitial;
- (bool)get_is_interstitial_loaded;

@end

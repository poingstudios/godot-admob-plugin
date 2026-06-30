//
//  Rewarded.h
//  Rewarded
//
//  Created by Gustavo Maciel on 24/01/21.
//

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

@class Rewarded;


@interface Rewarded: NSObject <GADFullScreenContentDelegate> {
    GADRewardedAd *rewarded;
    bool initialized;
    bool loaded;
    NSString *adUnitId;
    NSString *google_request_agent;
    ViewController *rootController;
}

- (instancetype)initWithRequestAgent:(NSString*) google_request_agent;
- (void)load_rewarded: (NSString*) ad_unit_id;
- (void)show_rewarded;
- (bool)get_is_rewarded_loaded;

@end

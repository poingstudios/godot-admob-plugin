//
//  Banner.h
//  Banner
//
//  Created by Gustavo Maciel on 24/01/21.
//


#ifdef VERSION_4_0
#include "core/object/object.h"
#endif

#ifdef VERSION_3_X
#include "core/object.h"
#endif

#include "../main/admob.h"
#include "version_constants.h"

#import "app_delegate.h"
#import "view_controller.h"

@class Banner;

@interface Banner: NSObject <GADBannerViewDelegate> {
    GADBannerView *bannerView;
    bool initialized;
    bool loaded;
    bool respectSafeArea;
    int positionBanner;
    NSString *adUnitId;
    NSString *google_request_agent;
    ViewController *rootController;
}

- (instancetype)initWithRequestAgent:(NSString*) p_google_request_agent;
- (void)load_banner: (NSString*) ad_unit_id : (int) position : (NSString*) size : (bool) show_instantly : (bool) respect_safe_area;
- (void)destroy_banner;
- (void)show_banner;
- (void)hide_banner;

- (float) get_banner_width;
- (float) get_banner_height;
- (float) get_banner_width_in_pixels;
- (float) get_banner_height_in_pixels;
- (bool) get_is_banner_loaded;

@end

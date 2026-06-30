//
//  Banner.mm
//  Banner
//
//  Created by Gustavo Maciel on 24/01/21.
//


#import "Banner.h"
@implementation Banner

- (void)dealloc {
    bannerView.delegate = nil;
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

- (float) get_banner_width{
    if (bannerView != Nil){
        NSLog(@"bannerView.bounds.size.width = %f", bannerView.bounds.size.width);
        return bannerView.bounds.size.width;
    }
    NSLog(@"width not found");

    return 0;
}
- (float) get_banner_height{
    if (bannerView != Nil){
        NSLog(@"bannerView.bounds.size.height = %f", bannerView.bounds.size.height);
        return bannerView.bounds.size.height;
    }
    return 0;
}

- (float) get_banner_width_in_pixels{
    if (bannerView != Nil){
        NSLog(@"bannerView.bounds.size.width_pixels = %f", bannerView.bounds.size.width * [UIScreen mainScreen].scale);
        return bannerView.bounds.size.width * [UIScreen mainScreen].scale;
    }
    return 0;
}
- (float) get_banner_height_in_pixels{
    if (bannerView != Nil){
        NSLog(@"bannerView.bounds.size.height_pixels = %f", bannerView.bounds.size.height * [UIScreen mainScreen].scale);
        return bannerView.bounds.size.height * [UIScreen mainScreen].scale;
    }
    return 0;
}


- (void) load_banner:(NSString*)ad_unit_id :(int)position :(NSString*)size : (bool) show_instantly : (bool) respect_safe_area {
    NSLog(@"Calling load_banner");
        
    if (!initialized || (!ad_unit_id.length)) {
        return;
    }
    else{
        NSLog(@"banner will load with the banner id %@", ad_unit_id);
    }
    respectSafeArea = respect_safe_area;
    positionBanner = position;
    NSLog(@"banner position = %i", positionBanner);
    
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];

    if (bannerView != nil) {
        [self destroy_banner];
    }

    NSLog(@"%@ will be created", size);

    if ([size isEqualToString:@"BANNER"]) {
        bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeBanner];
    } else if ([size isEqualToString:@"LARGE_BANNER"]) {
        bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeLargeBanner];
    } else if ([size isEqualToString:@"MEDIUM_RECTANGLE"]) {
        bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeMediumRectangle];
    } else if ([size isEqualToString:@"FULL_BANNER"]) {
        bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFullBanner];
    } else if ([size isEqualToString:@"LEADERBOARD"]) {
        bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeLeaderboard];
    } else if ([size isEqualToString:@"ADAPTIVE"]) {
        CGRect frame = rootController.view.frame;
        // Here safe area is taken into account, hence the view frame is used after
        // the view has been laid out.
        if (@available(iOS 11.0, *)) {
              frame = UIEdgeInsetsInsetRect(rootController.view.frame, rootController.view.safeAreaInsets);
        }
        CGFloat viewWidth = frame.size.width;
        bannerView = [[GADBannerView alloc] initWithAdSize:GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)];
    }
    else { //smart banner
        if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) { //portrait
            bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
            NSLog(@"UIDeviceOrientation: Portrait");
        }
        else { //landscape
            bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerLandscape];
            NSLog(@"UIDeviceOrientation: Landscape");
        }
    }
    
    if (show_instantly){
        [self show_banner];
    }
    else{
        [self hide_banner];
    }
    
    bannerView.adUnitID = ad_unit_id;

    bannerView.delegate = self;
    bannerView.rootViewController = rootController;
    
    GADRequest *request = [GADRequest request];
    request.requestAgent = google_request_agent;
    NSLog(@"Banner request agent: %@", google_request_agent);
    [bannerView loadRequest:request];
}

- (void)addBannerViewToView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootController.view addSubview:bannerView];
    //CENTER ON MIDDLE OF SCREEM
    [rootController.view addConstraint:
        [NSLayoutConstraint constraintWithItem:bannerView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:rootController.view
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1
                                      constant:0]];

    if (positionBanner == 0)//BOTTOM
    {
        [rootController.view addConstraint:
            [NSLayoutConstraint constraintWithItem:bannerView
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                            toItem:respectSafeArea ? rootController.view.safeAreaLayoutGuide : rootController.view
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1
                                        constant:0]];
    }
    else if(positionBanner == 1)//TOP
    {
        [rootController.view addConstraint:
            [NSLayoutConstraint constraintWithItem:bannerView
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                            toItem:respectSafeArea ? rootController.view.safeAreaLayoutGuide : rootController.view
                                        attribute:NSLayoutAttributeTop
                                        multiplier:1
                                        constant:0]];
    }
}


- (void)destroy_banner
{
    if (!initialized)
        return;
    
    if (bannerView != nil)
    {
        [bannerView setHidden:YES];
        [bannerView removeFromSuperview];
        bannerView = nil;
        AdMob::get_singleton()->emit_signal("banner_destroyed");

        loaded = false;
    }
}


- (void)show_banner
{
    if (!initialized)
        return;
    
    if (bannerView != nil)
    {
        [bannerView setHidden:NO];
    }
}

- (void)hide_banner
{
    if (!initialized)
        return;
    
    if (bannerView != nil)
    {
        [bannerView setHidden:YES];
    }
}


- (bool) get_is_banner_loaded{
    return loaded;
}

//LISTENERS

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"bannerViewDidReceiveAd");
    [self addBannerViewToView];
    AdMob::get_singleton()->emit_signal("banner_loaded");
    loaded = true;
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"bannerView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
    AdMob::get_singleton()->emit_signal("banner_failed_to_load", (int) error.code);

}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
    NSLog(@"banner_recorded_impression bannerViewDidRecordImpression");
    AdMob::get_singleton()->emit_signal("banner_recorded_impression");
}

- (void)bannerViewDidRecordClick:(nonnull GADBannerView *)bannerView{
    NSLog(@"banner_clicked bannerViewDidRecordClick");
    AdMob::get_singleton()->emit_signal("banner_clicked");
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"banner_closed bannerViewWillDismissScreen");
    AdMob::get_singleton()->emit_signal("banner_closed");
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"banner_opened bannerViewDidDismissScreen");
    AdMob::get_singleton()->emit_signal("banner_opened");
}

@end

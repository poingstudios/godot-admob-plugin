// MIT License
// Copyright (c) 2023-present Poing Studios

#import "NativeOverlayAd.h"
#import "../helpers/WindowHelper.h"
#import "../PoingGodotAdMobNativeOverlayAd.h"
#import "../helpers/NativeTemplates/GADTMediumTemplateView.h"
#import "../helpers/NativeTemplates/GADTSmallTemplateView.h"

@implementation NativeOverlayAd {
    GADAdLoader *_adLoader;
    GADTTemplateView *_templateView;
    NSMutableArray *_activeConstraints;
    int _adPosition;
    int _customX;
    int _customY;
    BOOL _isHidden;
    NSDictionary *_styleDict;
    GADAdSize _customAdSize;
    BOOL _useCustomAdSize;
}

@synthesize nativeAd = _nativeAd;

- (instancetype)initWithUID:(NSNumber *)uid {
    if ((self = [super init])) {
        self.UID = uid;
        _activeConstraints = [NSMutableArray array];
        _isHidden = NO;
        _adPosition = 0; // TOP
        _useCustomAdSize = NO;
    }
    return self;
}

- (void)loadWithAdUnitId:(NSString *)adUnitId adRequest:(GADRequest *)adRequest options:(NSDictionary *)optionsDict {
    NSMutableArray *adLoaderOptions = [NSMutableArray array];
    
    GADNativeAdViewAdOptions *adViewOptions = [[GADNativeAdViewAdOptions alloc] init];
    if (optionsDict[@"ad_choices_placement"]) {
        adViewOptions.preferredAdChoicesPosition = (GADAdChoicesPosition)[optionsDict[@"ad_choices_placement"] intValue];
    }
    [adLoaderOptions addObject:adViewOptions];

    GADNativeAdMediaAdLoaderOptions *mediaOptions = [[GADNativeAdMediaAdLoaderOptions alloc] init];
    if (optionsDict[@"media_aspect_ratio"]) {
        mediaOptions.mediaAspectRatio = (GADMediaAspectRatio)[optionsDict[@"media_aspect_ratio"] intValue];
    }
    [adLoaderOptions addObject:mediaOptions];
    
    NSDictionary *videoOptionsDict = optionsDict[@"video_options"];
    if (videoOptionsDict) {
        GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
        videoOptions.startMuted = [videoOptionsDict[@"start_muted"] boolValue];
        videoOptions.customControlsRequested = [videoOptionsDict[@"custom_controls_requested"] boolValue];
        videoOptions.clickToExpandRequested = [videoOptionsDict[@"click_to_expand_requested"] boolValue];
        [adLoaderOptions addObject:videoOptions];
    }

    _adLoader = [[GADAdLoader alloc] initWithAdUnitID:adUnitId
                                   rootViewController:[WindowHelper getCurrentRootViewController]
                                              adTypes:@[ GADAdLoaderAdTypeNative ]
                                              options:adLoaderOptions];
    _adLoader.delegate = self;
    [_adLoader loadRequest:adRequest];
}

- (void)renderTemplate:(NSDictionary *)styleDict position:(int)position adSize:(NSDictionary *)adSizeDict {
    _styleDict = styleDict;
    _adPosition = position;
    
    if (adSizeDict && adSizeDict.count > 0) {
        _customAdSize = GADAdSizeFromCGSize(CGSizeMake([adSizeDict[@"width"] floatValue], [adSizeDict[@"height"] floatValue]));
        _useCustomAdSize = YES;
    } else {
        _useCustomAdSize = NO;
    }
    
    [self internalRenderTemplate];
}

- (void)renderTemplateCustomPosition:(NSDictionary *)styleDict x:(int)x y:(int)y adSize:(NSDictionary *)adSizeDict {
    _styleDict = styleDict;
    _adPosition = -1; // Custom
    _customX = x;
    _customY = y;
    
    if (adSizeDict && adSizeDict.count > 0) {
        _customAdSize = GADAdSizeFromCGSize(CGSizeMake([adSizeDict[@"width"] floatValue], [adSizeDict[@"height"] floatValue]));
        _useCustomAdSize = YES;
    } else {
        _useCustomAdSize = NO;
    }
    
    [self internalRenderTemplate];
}

- (void)internalRenderTemplate {
    if (!_nativeAd) return;
    
    if (_templateView) {
        [_templateView removeFromSuperview];
        _templateView = nil;
    }
    
    NSString *templateId = _styleDict[@"template_id"] ?: @"medium";
    NSString *xibName = [templateId isEqualToString:@"small"] ? @"GADTSmallTemplateView" : @"GADTMediumTemplateView";
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSArray *nibObjects = [bundle loadNibNamed:xibName owner:nil options:nil];
    
    for (id object in nibObjects) {
        if ([object isKindOfClass:[GADTTemplateView class]]) {
            _templateView = (GADTTemplateView *)object;
            break;
        }
    }
    
    if (!_templateView) {
        NSLog(@"PoingAdMob: Could not load template view from XIB: %@", xibName);
        return;
    }
    
    [self applyStylesToTemplate];
    
    UIWindow *window = [WindowHelper getCurrentWindow];
    if (window) {
        _templateView.translatesAutoresizingMaskIntoConstraints = YES;
        [window addSubview:_templateView];
        [window bringSubviewToFront:_templateView];
        _templateView.nativeAd = _nativeAd;
        [self updatePositionLogic];
    }
}

- (void)applyStylesToTemplate {
    NSMutableDictionary *styles = [[NSMutableDictionary alloc] init];
    
    UIColor *mainBG = [GADTTemplateView colorFromHexString:_styleDict[@"main_background_color"]];
    if (mainBG) styles[GADTNativeTemplateStyleKeyMainBackgroundColor] = mainBG;
    
    [self addTextStyleToStyles:styles fromDict:_styleDict[@"primary_text"] 
                   bgKey:GADTNativeTemplateStyleKeyPrimaryBackgroundColor 
                 fontKey:GADTNativeTemplateStyleKeyPrimaryFont 
                colorKey:GADTNativeTemplateStyleKeyPrimaryFontColor];
                
    [self addTextStyleToStyles:styles fromDict:_styleDict[@"secondary_text"] 
                   bgKey:GADTNativeTemplateStyleKeySecondaryBackgroundColor 
                 fontKey:GADTNativeTemplateStyleKeySecondaryFont 
                colorKey:GADTNativeTemplateStyleKeySecondaryFontColor];
                
    [self addTextStyleToStyles:styles fromDict:_styleDict[@"tertiary_text"] 
                   bgKey:GADTNativeTemplateStyleKeyTertiaryBackgroundColor 
                 fontKey:GADTNativeTemplateStyleKeyTertiaryFont 
                colorKey:GADTNativeTemplateStyleKeyTertiaryFontColor];
                
    [self addTextStyleToStyles:styles fromDict:_styleDict[@"call_to_action_text"] 
                   bgKey:GADTNativeTemplateStyleKeyCallToActionBackgroundColor 
                 fontKey:GADTNativeTemplateStyleKeyCallToActionFont 
                colorKey:GADTNativeTemplateStyleKeyCallToActionFontColor];
                
    _templateView.styles = styles;
}

- (void)addTextStyleToStyles:(NSMutableDictionary *)styles fromDict:(NSDictionary *)textDict bgKey:(NSString *)bgKey fontKey:(NSString *)fontKey colorKey:(NSString *)colorKey {
    if (![textDict isKindOfClass:[NSDictionary class]]) return;
    
    UIColor *bg = [GADTTemplateView colorFromHexString:textDict[@"background_color"]];
    if (bg) styles[bgKey] = bg;
    
    UIColor *textC = [GADTTemplateView colorFromHexString:textDict[@"text_color"]];
    if (textC) styles[colorKey] = textC;
    
    float size = [textDict[@"font_size"] floatValue];
    int styleInt = [textDict[@"style"] intValue];
    
    if (size > 0) {
        UIFont *font;
        switch (styleInt) {
            case 1: font = [UIFont boldSystemFontOfSize:size]; break;
            case 2: font = [UIFont italicSystemFontOfSize:size]; break;
            case 3: font = [UIFont fontWithName:@"Courier" size:size]; break;
            default: font = [UIFont systemFontOfSize:size]; break;
        }
        styles[fontKey] = font;
    }
}

- (void)updatePositionLogic {
    if (!_templateView) return;
    
    UIWindow *window = [WindowHelper getCurrentWindow];
    if (!window) return;
    
    // Remove any previous constraints just in case
    [NSLayoutConstraint deactivateConstraints:_activeConstraints];
    [_activeConstraints removeAllObjects];

    CGRect parentBounds = window.bounds;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = window.safeAreaInsets;
        parentBounds = UIEdgeInsetsInsetRect(parentBounds, safeAreaInsets);
    }
    
    // Set size
    CGRect adFrame = _templateView.frame;
    if (_useCustomAdSize) {
        adFrame.size = _customAdSize.size;
    } else {
        adFrame.size.width = window.bounds.size.width;
        // Keep original aspect/height from NIB if not specified? 
        // GADTTemplateView usually provides its own height.
    }
    _templateView.frame = adFrame;

    CGFloat centerX = CGRectGetMidX(parentBounds);
    CGFloat centerY = CGRectGetMidY(parentBounds);
    
    CGFloat top = CGRectGetMinY(parentBounds) + CGRectGetMidY(_templateView.bounds);
    CGFloat bottom = CGRectGetMaxY(parentBounds) - CGRectGetMidY(_templateView.bounds);
    CGFloat left = CGRectGetMinX(parentBounds) + CGRectGetMidX(_templateView.bounds);
    CGFloat right = CGRectGetMaxX(parentBounds) - CGRectGetMidX(_templateView.bounds);

    CGPoint center = CGPointMake(centerX, top);

    if (_adPosition == -1) { // Custom
        center = CGPointMake(CGRectGetMinX(window.bounds) + _customX + CGRectGetMidX(_templateView.bounds),
                             CGRectGetMinY(window.bounds) + _customY + CGRectGetMidY(_templateView.bounds));
    } else {
        switch (_adPosition) {
            case 0: center = CGPointMake(centerX, top); break; // TOP
            case 1: center = CGPointMake(centerX, bottom); break; // BOTTOM
            case 2: center = CGPointMake(left, centerY); break; // LEFT
            case 3: center = CGPointMake(right, centerY); break; // RIGHT
            case 4: center = CGPointMake(left, top); break; // TOP_LEFT
            case 5: center = CGPointMake(right, top); break; // TOP_RIGHT
            case 6: center = CGPointMake(left, bottom); break; // BOTTOM_LEFT
            case 7: center = CGPointMake(right, bottom); break; // BOTTOM_RIGHT
            case 8: center = CGPointMake(centerX, centerY); break; // CENTER
        }
    }
    
    _templateView.center = center;
}

- (void)updatePosition:(int)position {
    _adPosition = position;
    [self updatePositionLogic];
}

- (void)updateCustomPosition:(int)x y:(int)y {
    _adPosition = -1;
    _customX = x;
    _customY = y;
    [self updatePositionLogic];
}

- (void)destroy {
    [_templateView removeFromSuperview];
    _templateView = nil;
    _nativeAd = nil;
}

- (void)hide {
    _isHidden = YES;
    _templateView.hidden = YES;
}

- (void)show {
    _isHidden = NO;
    _templateView.hidden = NO;
    [self updatePositionLogic];
}

- (float)getWidthInPixels {
    return _templateView.frame.size.width * [UIScreen mainScreen].scale;
}

- (float)getHeightInPixels {
    return _templateView.frame.size.height * [UIScreen mainScreen].scale;
}

#pragma mark - GADAdLoaderDelegate
- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    PoingGodotAdMobNativeOverlayAd::get_singleton()->emit_signal("on_native_overlay_ad_failed_to_load", [self.UID intValue], [ObjectToGodotDictionary convertNSErrorToDictionaryAsLoadAdError:error]);
}

#pragma mark - GADNativeAdLoaderDelegate
- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    _nativeAd = nativeAd;
    _nativeAd.delegate = self;

    __weak NativeOverlayAd *weakSelf = self;
    _nativeAd.paidEventHandler = ^(GADAdValue *_Nonnull value) {
        NativeOverlayAd *strongSelf = weakSelf;
        if (strongSelf) {
            Dictionary adValueDictionary = [ObjectToGodotDictionary convertGADAdValueToDictionary:value];
            PoingGodotAdMobNativeOverlayAd::get_singleton()->emit_signal("on_native_overlay_ad_paid",
                                                                         [strongSelf.UID intValue],
                                                                         adValueDictionary);
        }
    };

    PoingGodotAdMobNativeOverlayAd::get_singleton()->emit_signal("on_native_overlay_ad_loaded", [self.UID intValue]);
}

#pragma mark - GADNativeAdDelegate
- (void)nativeAdDidRecordImpression:(GADNativeAd *)nativeAd {
    PoingGodotAdMobNativeOverlayAd::get_singleton()->emit_signal("on_native_overlay_ad_impression", [self.UID intValue]);
}

- (void)nativeAdDidRecordClick:(GADNativeAd *)nativeAd {
    PoingGodotAdMobNativeOverlayAd::get_singleton()->emit_signal("on_native_overlay_ad_clicked", [self.UID intValue]);
}

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {
    PoingGodotAdMobNativeOverlayAd::get_singleton()->emit_signal("on_native_overlay_ad_opened", [self.UID intValue]);
}

- (void)nativeAdDidDismissScreen:(GADNativeAd *)nativeAd {
    PoingGodotAdMobNativeOverlayAd::get_singleton()->emit_signal("on_native_overlay_ad_closed", [self.UID intValue]);
}

@end

// MIT License
// Copyright (c) 2023-present Poing Studios

#ifndef NativeOverlayAd_h
#define NativeOverlayAd_h

#import "AdFormatBase.h"
#import "../helpers/NativeTemplates/GADTTemplateView.h"

@interface NativeOverlayAd : AdFormatBase <GADNativeAdLoaderDelegate, GADNativeAdDelegate>

@property (nonatomic, strong, readonly) GADNativeAd *nativeAd;

- (instancetype)initWithUID:(NSNumber *)uid;
- (void)loadWithAdUnitId:(NSString *)adUnitId adRequest:(GADRequest *)adRequest options:(NSDictionary *)optionsDict;
- (void)renderTemplate:(NSDictionary *)styleDict position:(int)position adSize:(NSDictionary *)adSizeDict;
- (void)renderTemplateCustomPosition:(NSDictionary *)styleDict x:(int)x y:(int)y adSize:(NSDictionary *)adSizeDict;
- (void)updatePosition:(int)position;
- (void)updateCustomPosition:(int)x y:(int)y;
- (void)destroy;
- (void)hide;
- (void)show;
- (float)getWidthInPixels;
- (float)getHeightInPixels;

@end

#endif /* NativeOverlayAd_h */

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
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "BannerAd.h"
#import "../helpers/WindowHelper.h"

@implementation BannerAd
- (instancetype)initWithUID:(int)UID
           adViewDictionary:(Dictionary)adViewDictionary {
  if ((self = [super init])) {
    self.UID = [NSNumber numberWithInt:UID];
    self.adPosition =
        [NSNumber numberWithInt:(int)adViewDictionary["ad_position"]];

    String adUnitId = (String)adViewDictionary["ad_unit_id"];
    Dictionary adSizeDictionary = (Dictionary)adViewDictionary["ad_size"];
    GADAdSize adSize =
        [GodotDictionaryToObject convertDictionaryToGADAdSize:adSizeDictionary];

    self.bannerView = [[GADBannerView alloc] initWithAdSize:adSize];
    [self addBannerViewToView:self.bannerView];

    UIViewController *rootViewController =
        [WindowHelper getCurrentRootViewController];

    self.bannerView.adUnitID =
        [NSString stringWithUTF8String:adUnitId.utf8().get_data()];
    self.bannerView.rootViewController = rootViewController;

    self.bannerView.delegate = self;
  }
  return self;
}

- (void)loadAd:(GADRequest *)request {
  [self.bannerView loadRequest:request];
}

- (void)destroy {
  [self.bannerView setHidden:YES];
  [self.bannerView removeFromSuperview];
  self.bannerView = nil;
}

- (void)hide {
  self.isHidden = YES;
  [self.bannerView setHidden:YES];
}

- (void)show {
  self.isHidden = NO;
  [self.bannerView setHidden:NO];
}

- (int)getWidth {
  return self.bannerView.bounds.size.width;
}

- (int)getHeight {
  return self.bannerView.bounds.size.height;
}

- (int)getWidthInPixels {
  CGFloat scale = [[UIScreen mainScreen] scale];
  return (int)(self.bannerView.bounds.size.width * scale);
}

- (int)getHeightInPixels {
  CGFloat scale = [[UIScreen mainScreen] scale];
  return (int)(self.bannerView.bounds.size.height * scale);
}

- (void)addBannerViewToView:(GADBannerView *)bannerView {
  bannerView.translatesAutoresizingMaskIntoConstraints = NO;

  UIWindow *window = [WindowHelper getCurrentWindow];

  if (!window) {
    NSLog(@"PoingGodotAdMob: Window is nil, cannot add banner view.");
    return;
  }

  [window addSubview:bannerView];
  [window bringSubviewToFront:bannerView];

  // CENTER ON MIDDLE OF SCREEN
  [self updateBannerPositionForAdPosition:static_cast<AdPosition>(
                                              [self.adPosition intValue])];
}

- (void)addConstraintForBannerView:(NSLayoutAttribute)attribute
                            toView:(id)toView {
  if (!toView) {
    NSLog(@"PoingGodotAdMob: toView is nil, cannot add constraint.");
    return;
  }

  UIWindow *window = [WindowHelper getCurrentWindow];

  if (!window) {
    return;
  }

  [window
      addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView
                                                 attribute:attribute
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:toView
                                                 attribute:attribute
                                                multiplier:1
                                                  constant:0]];
}

- (void)updateBannerPositionForAdPosition:(AdPosition)adPosition {
  NSLog(@"ADPOSITION: %i", adPosition);

  UIWindow *window = [WindowHelper getCurrentWindow];

  if (!window) {
    NSLog(@"PoingGodotAdMob: Window is nil, cannot update banner position.");
    return;
  }

  [window removeConstraints:self.bannerView.constraints];

  // Use the window's safe area layout guide (iOS 11+)
  UILayoutGuide *safeArea = window.safeAreaLayoutGuide;

  switch (adPosition) {
  case AdPosition::Top:
    [self addConstraintForBannerView:NSLayoutAttributeCenterX toView:window];
    [self addConstraintForBannerView:NSLayoutAttributeTop toView:safeArea];
    break;

  case AdPosition::Bottom:
    [self addConstraintForBannerView:NSLayoutAttributeCenterX toView:window];
    [self addConstraintForBannerView:NSLayoutAttributeBottom toView:safeArea];
    break;

  case AdPosition::Left:
    [self addConstraintForBannerView:NSLayoutAttributeLeft toView:safeArea];
    [self addConstraintForBannerView:NSLayoutAttributeCenterY toView:safeArea];
    break;

  case AdPosition::Right:
    [self addConstraintForBannerView:NSLayoutAttributeRight toView:safeArea];
    [self addConstraintForBannerView:NSLayoutAttributeCenterY toView:safeArea];
    break;

  case AdPosition::TopLeft:
    [self addConstraintForBannerView:NSLayoutAttributeLeft toView:safeArea];
    [self addConstraintForBannerView:NSLayoutAttributeTop toView:safeArea];
    break;

  case AdPosition::TopRight:
    [self addConstraintForBannerView:NSLayoutAttributeRight toView:safeArea];
    [self addConstraintForBannerView:NSLayoutAttributeTop toView:safeArea];
    break;

  case AdPosition::BottomLeft:
    [self addConstraintForBannerView:NSLayoutAttributeLeft toView:safeArea];
    [self addConstraintForBannerView:NSLayoutAttributeBottom toView:safeArea];
    break;

  case AdPosition::BottomRight:
    [self addConstraintForBannerView:NSLayoutAttributeRight toView:safeArea];
    [self addConstraintForBannerView:NSLayoutAttributeBottom toView:safeArea];
    break;

  case AdPosition::Center:
    [self addConstraintForBannerView:NSLayoutAttributeCenterX toView:window];
    [self addConstraintForBannerView:NSLayoutAttributeCenterY toView:window];
    break;

  case AdPosition::Custom:
    [self addConstraintForBannerView:NSLayoutAttributeLeft
                              toView:safeArea
                   attributeConstant:0];
    [self addConstraintForBannerView:NSLayoutAttributeTop
                              toView:safeArea
                   attributeConstant:0];
    break;
  }

  [window layoutIfNeeded];
}

- (void)addConstraintForBannerView:(NSLayoutAttribute)attribute
                            toView:(id)toView
                 attributeConstant:(CGFloat)constant {
  if (!toView) {
    NSLog(@"PoingGodotAdMob: toView is nil, cannot add constraint.");
    return;
  }

  UIViewController *rootViewController =
      [WindowHelper getCurrentRootViewController];

  if (!rootViewController || !rootViewController.view) {
    return;
  }

  [rootViewController.view
      addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView
                                                 attribute:attribute
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:toView
                                                 attribute:attribute
                                                multiplier:1
                                                  constant:constant]];
}

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidReceiveAd %@", self.UID);
  PoingGodotAdMobAdView::get_singleton()->emit_signal("on_ad_loaded",
                                                      [self.UID intValue]);
}

- (void)bannerView:(GADBannerView *)bannerView
    didFailToReceiveAdWithError:(NSError *)error {
  NSLog(@"bannerView:didFailToReceiveAdWithError: %@",
        [error localizedDescription]);

  PoingGodotAdMobAdView::get_singleton()->emit_signal(
      "on_ad_failed_to_load", [self.UID intValue],
      [ObjectToGodotDictionary convertNSErrorToDictionaryAsLoadAdError:error]);
}

- (void)bannerViewDidRecordClick:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordClick");
  PoingGodotAdMobAdView::get_singleton()->emit_signal("on_ad_clicked",
                                                      [self.UID intValue]);
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidRecordImpression");
  PoingGodotAdMobAdView::get_singleton()->emit_signal("on_ad_impression",
                                                      [self.UID intValue]);
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewWillPresentScreen");
  PoingGodotAdMobAdView::get_singleton()->emit_signal("on_ad_opened",
                                                      [self.UID intValue]);
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
  NSLog(@"bannerViewDidDismissScreen");
  PoingGodotAdMobAdView::get_singleton()->emit_signal("on_ad_closed",
                                                      [self.UID intValue]);
}

@end

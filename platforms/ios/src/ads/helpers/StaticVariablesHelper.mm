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
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "StaticVariablesHelper.h"
#include "platform/ios/os_ios.h"

@implementation StaticVariablesHelper

static BOOL _pauseOnBackground = NO;
static NSInteger _activePausedAdsCount = 0;

+ (BOOL)pauseOnBackground {
    return _pauseOnBackground;
}

+ (void)setPauseOnBackground:(BOOL)pause {
    _pauseOnBackground = pause;
}

+ (void)onAdWillPresentFullScreenContent {
    NSLog(@"pauseOnBackground %s", _pauseOnBackground ? "true" : "false");
    if (_pauseOnBackground) {
        _activePausedAdsCount++;
        if (_activePausedAdsCount == 1) {
            OS_IOS::get_singleton()->on_focus_out();
        }
    }
}

+ (void)onAdDidDismissFullScreenContent {
    if (_activePausedAdsCount > 0) {
        _activePausedAdsCount--;
        if (_activePausedAdsCount == 0) {
            OS_IOS::get_singleton()->on_focus_in();
        }
    }
}

@end

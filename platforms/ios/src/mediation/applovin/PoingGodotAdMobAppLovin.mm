// MIT License
//
// Copyright (c) 2026-present Poing Studios
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

#import "PoingGodotAdMobAppLovin.h"

PoingGodotAdMobAppLovin *PoingGodotAdMobAppLovin::instance = NULL;

PoingGodotAdMobAppLovin::PoingGodotAdMobAppLovin() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobAppLovin::~PoingGodotAdMobAppLovin() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobAppLovin *PoingGodotAdMobAppLovin::get_singleton() {
    return instance;
}

void PoingGodotAdMobAppLovin::set_has_user_consent(bool has_user_consent) {
    [ALPrivacySettings setHasUserConsent:has_user_consent];
    NSLog(@"set applovin has user consent: %d", has_user_consent);
}

void PoingGodotAdMobAppLovin::set_do_not_sell(bool do_not_sell) {
    [ALPrivacySettings setDoNotSell:do_not_sell];
    NSLog(@"set applovin do not sell: %d", do_not_sell);
}

void PoingGodotAdMobAppLovin::set_muted(bool muted) {
    [ALSdk shared].settings.muted = muted;
    NSLog(@"set applovin muted: %d", muted);
}

void PoingGodotAdMobAppLovin::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_has_user_consent"), &PoingGodotAdMobAppLovin::set_has_user_consent);
    ClassDB::bind_method(D_METHOD("set_do_not_sell"), &PoingGodotAdMobAppLovin::set_do_not_sell);
    ClassDB::bind_method(D_METHOD("set_muted"), &PoingGodotAdMobAppLovin::set_muted);
}

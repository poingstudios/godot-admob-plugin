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

#import "PoingGodotAdMobDTExchange.h"

PoingGodotAdMobDTExchange *PoingGodotAdMobDTExchange::instance = NULL;

PoingGodotAdMobDTExchange::PoingGodotAdMobDTExchange() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobDTExchange::~PoingGodotAdMobDTExchange() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobDTExchange *PoingGodotAdMobDTExchange::get_singleton() {
    return instance;
}

void PoingGodotAdMobDTExchange::set_gdpr_consent(bool consent) {
    [IASDKCore.sharedInstance setGDPRConsent:consent ? IAGDPRConsentTypeGiven : IAGDPRConsentTypeDenied];
    NSLog(@"set DTExchange GDPR consent: %d", consent);
}

void PoingGodotAdMobDTExchange::set_gdpr_consent_string(String consent_string) {
    NSString *ns_consent_string = [NSString stringWithUTF8String:consent_string.utf8().get_data()];
    [IASDKCore.sharedInstance setGDPRConsentString:ns_consent_string];
    NSLog(@"set DTExchange GDPR consent string");
}

void PoingGodotAdMobDTExchange::set_ccpa_string(String ccpa_string) {
    if (ccpa_string.is_empty()) {
        IASDKCore.sharedInstance.CCPAString = nil;
    } else {
        NSString *ns_ccpa_string = [NSString stringWithUTF8String:ccpa_string.utf8().get_data()];
        IASDKCore.sharedInstance.CCPAString = ns_ccpa_string;
    }
    NSLog(@"set DTExchange CCPA string");
}

void PoingGodotAdMobDTExchange::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_gdpr_consent"), &PoingGodotAdMobDTExchange::set_gdpr_consent);
    ClassDB::bind_method(D_METHOD("set_gdpr_consent_string"), &PoingGodotAdMobDTExchange::set_gdpr_consent_string);
    ClassDB::bind_method(D_METHOD("set_ccpa_string"), &PoingGodotAdMobDTExchange::set_ccpa_string);
}

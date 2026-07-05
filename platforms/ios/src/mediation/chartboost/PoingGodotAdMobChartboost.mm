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

#import "PoingGodotAdMobChartboost.h"

PoingGodotAdMobChartboost *PoingGodotAdMobChartboost::instance = NULL;

PoingGodotAdMobChartboost::PoingGodotAdMobChartboost() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobChartboost::~PoingGodotAdMobChartboost() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobChartboost *PoingGodotAdMobChartboost::get_singleton() {
    return instance;
}

void PoingGodotAdMobChartboost::set_consent(bool consent) {
    CHBGDPRDataUseConsent *dataUseConsent = [CHBGDPRDataUseConsent gdprConsent:consent ? CHBGDPRConsentBehavioral : CHBGDPRConsentNonBehavioral];
    [Chartboost addDataUseConsent:dataUseConsent];
    
    NSLog(@"set chartboost consent: %d", consent);
}

void PoingGodotAdMobChartboost::set_ccpa_consent(bool consent) {
    CHBCCPADataUseConsent *dataUseConsent = [CHBCCPADataUseConsent ccpaConsent:consent ? CHBCCPAConsentOptInSale : CHBCCPAConsentOptOutSale];
    [Chartboost addDataUseConsent:dataUseConsent];
    
    NSLog(@"set chartboost ccpa consent: %d", consent);
}

void PoingGodotAdMobChartboost::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_consent"), &PoingGodotAdMobChartboost::set_consent);
    ClassDB::bind_method(D_METHOD("set_ccpa_consent"), &PoingGodotAdMobChartboost::set_ccpa_consent);
}

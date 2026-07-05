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

#import "PoingGodotAdMobBidMachine.h"
#import <BidMachine/BidMachine-Swift.h>

PoingGodotAdMobBidMachine *PoingGodotAdMobBidMachine::instance = NULL;

PoingGodotAdMobBidMachine::PoingGodotAdMobBidMachine() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobBidMachine::~PoingGodotAdMobBidMachine() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobBidMachine *PoingGodotAdMobBidMachine::get_singleton() {
    return instance;
}

void PoingGodotAdMobBidMachine::set_subject_to_gdpr(bool subject_to_gdpr) {
    [[BidMachineSdk shared].regulationInfo populate:^(id<BidMachineRegulationInfoBuilderProtocol> builder) {
        [builder withGDPRZone:subject_to_gdpr];
    }];
    NSLog(@"set bidmachine subject to gdpr: %d", subject_to_gdpr);
}

void PoingGodotAdMobBidMachine::set_consent_status(bool consent_status) {
    [[BidMachineSdk shared].regulationInfo populate:^(id<BidMachineRegulationInfoBuilderProtocol> builder) {
        [builder withGDPRConsent:consent_status];
    }];
    NSLog(@"set bidmachine consent status: %d", consent_status);
}

void PoingGodotAdMobBidMachine::set_us_privacy_string(String us_privacy_string) {
    NSString *usPrivacyString = [NSString stringWithUTF8String:us_privacy_string.utf8().get_data()];
    [[BidMachineSdk shared].regulationInfo populate:^(id<BidMachineRegulationInfoBuilderProtocol> builder) {
        [builder withUSPrivacyString:usPrivacyString];
    }];
    NSLog(@"set bidmachine us privacy string: %@", usPrivacyString);
}

void PoingGodotAdMobBidMachine::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_subject_to_gdpr"), &PoingGodotAdMobBidMachine::set_subject_to_gdpr);
    ClassDB::bind_method(D_METHOD("set_consent_status"), &PoingGodotAdMobBidMachine::set_consent_status);
    ClassDB::bind_method(D_METHOD("set_us_privacy_string"), &PoingGodotAdMobBidMachine::set_us_privacy_string);
}

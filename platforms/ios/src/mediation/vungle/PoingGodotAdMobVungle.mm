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

#import "PoingGodotAdMobVungle.h"

PoingGodotAdMobVungle *PoingGodotAdMobVungle::instance = NULL;

PoingGodotAdMobVungle::PoingGodotAdMobVungle() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobVungle::~PoingGodotAdMobVungle() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobVungle *PoingGodotAdMobVungle::get_singleton() {
    return instance;
};

void PoingGodotAdMobVungle::update_consent_status(int status, String consent_message_version) {
    NSString* consentMessageVersionNS = [NSString stringWithCString:consent_message_version.utf8().get_data() encoding: NSUTF8StringEncoding];

    [VunglePrivacySettings setGDPRStatus:status];
    [VunglePrivacySettings setGDPRMessageVersion:consentMessageVersionNS];

    NSLog(@"set vungle consent status, message: %@ status: %i", consentMessageVersionNS, status);
}

void PoingGodotAdMobVungle::update_ccpa_status(int status) {
    [VunglePrivacySettings setCCPAStatus:status];

    NSLog(@"set vungle ccpa status status: %i", status);
}


void PoingGodotAdMobVungle::_bind_methods() {
    ClassDB::bind_method(D_METHOD("update_consent_status"), &PoingGodotAdMobVungle::update_consent_status);
    ClassDB::bind_method(D_METHOD("update_ccpa_status"), &PoingGodotAdMobVungle::update_ccpa_status);
}

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

#import "PoingGodotAdMobUserMessagingPlatform.h"

PoingGodotAdMobUserMessagingPlatform *PoingGodotAdMobUserMessagingPlatform::instance = NULL;

PoingGodotAdMobUserMessagingPlatform::PoingGodotAdMobUserMessagingPlatform() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobUserMessagingPlatform::~PoingGodotAdMobUserMessagingPlatform() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobUserMessagingPlatform *PoingGodotAdMobUserMessagingPlatform::get_singleton() {
    return instance;
};

void PoingGodotAdMobUserMessagingPlatform::load_consent_form() {
    [UMPConsentForm loadWithCompletionHandler:^(UMPConsentForm * _Nullable consentForm, NSError * _Nullable error) {
        if (error){
            Dictionary errorDictionary = [ObjectToGodotDictionary convertNSErrorToDictionaryAsFormError:error];
            emit_signal("on_consent_form_load_failure_listener", errorDictionary);
            return;
        }
        int uid = (int)objectVector.size();
        PoingGodotAdMobConsentForm *PGADConsentForm = [[PoingGodotAdMobConsentForm alloc] initWithUID:uid umpConsentForm:consentForm];
        objectVector.push_back(PGADConsentForm);

        emit_signal("on_consent_form_load_success_listener", uid);
    }];
}

void PoingGodotAdMobUserMessagingPlatform::show(int uid) {
    PoingGodotAdMobConsentForm* PGADConsentForm = getObject(uid);

    if (PGADConsentForm) {
        [PGADConsentForm show];
    }
}

void PoingGodotAdMobUserMessagingPlatform::_bind_methods() {
    ADD_SIGNAL(MethodInfo("on_consent_form_dismissed", PropertyInfo(Variant::INT, "UID"), PropertyInfo(Variant::DICTIONARY, "formErrorDictionary")));
    
    ADD_SIGNAL(MethodInfo("on_consent_form_load_success_listener", PropertyInfo(Variant::INT, "UID")));
    ADD_SIGNAL(MethodInfo("on_consent_form_load_failure_listener", PropertyInfo(Variant::DICTIONARY, "formErrorDictionary")));
    
    ClassDB::bind_method(D_METHOD("load_consent_form"), &PoingGodotAdMobUserMessagingPlatform::load_consent_form);
    ClassDB::bind_method(D_METHOD("show"), &PoingGodotAdMobUserMessagingPlatform::show);
};

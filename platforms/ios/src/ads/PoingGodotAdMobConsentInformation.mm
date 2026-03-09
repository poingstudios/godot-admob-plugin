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

#import "PoingGodotAdMobConsentInformation.h"

PoingGodotAdMobConsentInformation *PoingGodotAdMobConsentInformation::instance = NULL;

PoingGodotAdMobConsentInformation::PoingGodotAdMobConsentInformation() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobConsentInformation::~PoingGodotAdMobConsentInformation() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobConsentInformation *PoingGodotAdMobConsentInformation::get_singleton() {
    return instance;
};

int PoingGodotAdMobConsentInformation::get_consent_status() {
    UMPConsentStatus status = [UMPConsentInformation.sharedInstance consentStatus];
    switch (status) {
        case UMPConsentStatusUnknown:
            return 0;
        case UMPConsentStatusNotRequired:
            return 1;
        case UMPConsentStatusRequired:
            return 2;
        case UMPConsentStatusObtained:
            return 3;
        default:
            return 0;
    }
}

bool PoingGodotAdMobConsentInformation::get_is_consent_form_available() {
    return [UMPConsentInformation.sharedInstance formStatus] == UMPFormStatusAvailable;
}

void PoingGodotAdMobConsentInformation::update(Dictionary consentRequestParametersDictionary) {
    UMPRequestParameters* parameters = [GodotDictionaryToObject convertDictionaryToUMPRequestParameters:consentRequestParametersDictionary];
    [UMPConsentInformation.sharedInstance
        requestConsentInfoUpdateWithParameters:parameters
            completionHandler:^(NSError *_Nullable requestConsentError) {
                if (requestConsentError) {
                    Dictionary formErrorDictionary = [ObjectToGodotDictionary convertNSErrorToDictionaryAsFormError:requestConsentError];
                    emit_signal("on_consent_info_updated_failure",formErrorDictionary);
                    return;
                }
                emit_signal("on_consent_info_updated_success");
            }];
}
void PoingGodotAdMobConsentInformation::reset() {
    [UMPConsentInformation.sharedInstance reset];
}

void PoingGodotAdMobConsentInformation::_bind_methods() {
    ADD_SIGNAL(MethodInfo("on_consent_info_updated_success"));
    ADD_SIGNAL(MethodInfo("on_consent_info_updated_failure", PropertyInfo(Variant::DICTIONARY, "formErrorDictionary")));

    ClassDB::bind_method(D_METHOD("get_consent_status"), &PoingGodotAdMobConsentInformation::get_consent_status);
    ClassDB::bind_method(D_METHOD("get_is_consent_form_available"), &PoingGodotAdMobConsentInformation::get_is_consent_form_available);
    ClassDB::bind_method(D_METHOD("update"), &PoingGodotAdMobConsentInformation::update);
    ClassDB::bind_method(D_METHOD("reset"), &PoingGodotAdMobConsentInformation::reset);
};

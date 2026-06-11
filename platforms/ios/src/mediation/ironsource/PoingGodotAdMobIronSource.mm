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
// A DISPUTE, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
#import "PoingGodotAdMobIronSource.h"
#import <IronSource/IronSource.h>

PoingGodotAdMobIronSource *PoingGodotAdMobIronSource::instance = NULL;

PoingGodotAdMobIronSource::PoingGodotAdMobIronSource() {
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
}

PoingGodotAdMobIronSource::~PoingGodotAdMobIronSource() {
    if (instance == this) {
        instance = NULL;
    }
}

PoingGodotAdMobIronSource *PoingGodotAdMobIronSource::get_singleton() {
    return instance;
};

void PoingGodotAdMobIronSource::set_consent(bool consent) {
    [LevelPlay setConsent:consent];
}

void PoingGodotAdMobIronSource::set_metadata(String key, String value) {
    NSString *keyNS = [NSString stringWithCString:key.utf8().get_data() encoding:NSUTF8StringEncoding];
    NSString *valueNS = [NSString stringWithCString:value.utf8().get_data() encoding:NSUTF8StringEncoding];
    [LevelPlay setMetaDataWithKey:keyNS value:valueNS];
}

void PoingGodotAdMobIronSource::set_user_id(String user_id) {
    NSString *userIdNS = [NSString stringWithCString:user_id.utf8().get_data() encoding:NSUTF8StringEncoding];
    [LevelPlay setDynamicUserId:userIdNS];
}

void PoingGodotAdMobIronSource::_bind_methods() {
    ClassDB::bind_method(D_METHOD("set_consent"), &PoingGodotAdMobIronSource::set_consent);
    ClassDB::bind_method(D_METHOD("set_metadata"), &PoingGodotAdMobIronSource::set_metadata);
    ClassDB::bind_method(D_METHOD("set_user_id"), &PoingGodotAdMobIronSource::set_user_id);
}

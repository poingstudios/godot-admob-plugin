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

#import "GodotDictionaryToObject.h"

@implementation GodotDictionaryToObject

+ (GADAdSize)convertDictionaryToGADAdSize:(Dictionary)adSizeDictionary{
    int width = (int) adSizeDictionary["width"];
    int height = (int) adSizeDictionary["height"];
    if (width == 0 && height == 0) { // as the size of smart banner is (0, 0)
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        CGRect safeFrame = [UIApplication sharedApplication].keyWindow.safeAreaLayoutGuide.layoutFrame;
        if (!CGSizeEqualToSize(safeFrame.size, CGSizeZero)) {
          screenBounds = safeFrame;
        }
        width = (int)CGRectGetWidth(screenBounds);
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width);
    } else {
        return GADAdSizeFromCGSize(CGSizeMake(width, height));
    }
}

+ (GADRequest *)convertDictionaryToGADRequest:(Dictionary)adRequestDictionary withKeywords:(PackedStringArray)keywords{
    GADRequest *request = [GADRequest request];
    String googleRequestAgent = adRequestDictionary["google_request_agent"];

    NSString *requestAgentNSString = [NSString stringWithUTF8String:googleRequestAgent.utf8().get_data()];
        
    request.requestAgent = requestAgentNSString;
    NSLog(@"requestAgentNSString: %@", requestAgentNSString);

    Dictionary mediationExtras = adRequestDictionary["mediation_extras"];

    for (int i = 0; i < mediationExtras.size(); i++) {
        Dictionary extraDictionary = mediationExtras[i];
        String className = extraDictionary["class_name"];

        id<AdNetworkExtras> extra = [[NSClassFromString([NSString stringWithUTF8String:className.utf8().get_data()]) alloc] init];
        if (extra){
            Dictionary extras = extraDictionary["extras"];
            [request registerAdNetworkExtras:[extra buildExtras:extras]];
            NSLog(@"successful added mediation extras for class_name: %@", [NSString stringWithUTF8String:className.utf8().get_data()]);
        }
        else{
            NSLog(@"mediation class_name doesn't exists: %@", [NSString stringWithUTF8String:className.utf8().get_data()]);
        }
    }
    
    Dictionary extrasDictionary = adRequestDictionary["extras"];

    GADExtras *extras = [[GADExtras alloc] init];
    extras.additionalParameters = [GodotDictionaryToObject convertDictionaryToNSDictionary:extrasDictionary];
    [request registerAdNetworkExtras:extras];
    
    NSMutableArray<NSString *> *keywordsNSArray = [NSMutableArray array];

    for (int i = 0; i < keywords.size(); ++i) {
        String keyword = keywords[i];
        NSString *nsKeyword = [NSString stringWithUTF8String:keyword.utf8().get_data()]; // Converte para NSString
        [keywordsNSArray addObject:nsKeyword]; // Adiciona o NSString no NSMutableArray
    }
    
    request.keywords = keywordsNSArray;

    return request;
}

+ (NSDictionary *)convertDictionaryToNSDictionary:(Dictionary)extrasParameters{
    NSMutableDictionary *nsDictionary = [NSMutableDictionary dictionary];

    Array keys = extrasParameters.keys();
    int size = keys.size();
    for (int i = 0; i < size; ++i) {
        String key = keys[i];
        String value = extrasParameters[key];
        NSString *nsKey = [NSString stringWithUTF8String:key.utf8().get_data()];
        NSString *nsValue = [NSString stringWithUTF8String:value.utf8().get_data()];

        [nsDictionary setValue:nsValue forKey:nsKey];
    }

    return nsDictionary;
    
}

+ (GADServerSideVerificationOptions *)convertDictionaryToGADServerSideVerificationOptions:(Dictionary)serverSideVerificationOptionsDictionary {
    GADServerSideVerificationOptions *options = [[GADServerSideVerificationOptions alloc] init];

    String custom_data = serverSideVerificationOptionsDictionary["custom_data"];
    String user_id = serverSideVerificationOptionsDictionary["user_id"];

    NSString *customData = [NSString stringWithUTF8String:custom_data.utf8().get_data()];
    NSString *userId = [NSString stringWithUTF8String:user_id.utf8().get_data()];

    if (customData && ![customData isEqualToString:@""]) {
        options.customRewardString = customData;
    }

    if (userId && ![userId isEqualToString:@""]) {
        options.userIdentifier = userId;
    }

    return options;
}

+ (UMPRequestParameters *)convertDictionaryToUMPRequestParameters:(Dictionary)umpRequestParametersDictionary {
    UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];

    bool tagForUnderAgeOfConsent = umpRequestParametersDictionary["tag_for_under_age_of_consent"];
    parameters.tagForUnderAgeOfConsent = tagForUnderAgeOfConsent;

    Dictionary consentDebugSettingsDictionary = umpRequestParametersDictionary["consent_debug_settings"];

    if (!consentDebugSettingsDictionary.is_empty()) {
        parameters.debugSettings = [GodotDictionaryToObject convertDictionaryToUMPDebugSettings:consentDebugSettingsDictionary];
    }
    
    return parameters;
}

+ (UMPDebugSettings *)convertDictionaryToUMPDebugSettings:(Dictionary)umpDebugSettingsDictionary {
    UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
    
    int debugGeographyValue = umpDebugSettingsDictionary["debug_geography"];
    debugSettings.geography = (UMPDebugGeography) debugGeographyValue;

    Dictionary testDeviceHashedIds = umpDebugSettingsDictionary["test_device_hashed_ids"];
    Array testDeviceIds = testDeviceHashedIds.values();

    NSMutableArray<NSString *> *convertedArray = [NSMutableArray array];
    for (int i = 0; i < testDeviceIds.size(); i++) {
        String item = testDeviceIds[i];
        [convertedArray addObject:[NSString stringWithUTF8String:item.utf8().get_data()]];
    }
    
    debugSettings.testDeviceIdentifiers = convertedArray;

    return debugSettings;
}

@end

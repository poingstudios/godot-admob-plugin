//
//  admob.m
//  admob
//
//  Created by Gustavo Maciel on 16/01/21.
//


#import <Foundation/Foundation.h>
#import <AdSupport/ASIdentifierManager.h>
#include <CommonCrypto/CommonDigest.h>
#include <UserMessagingPlatform/UserMessagingPlatform.h>

#ifdef VERSION_4_0
#include "core/config/project_settings.h"
#include "core/object/class_db.h"
#endif

#ifdef VERSION_3_X
#include "core/project_settings.h"
#include "core/class_db.h"
#endif


#include "admob.h"
#include "version_constants.h"

AdMob *AdMob::instance = NULL;

AdMob::AdMob() {
    initialized = false;
    bannerObj = NULL;
    interstitialObj = NULL;
    rewardedObj = NULL;
    rewardedInterstitialObj = NULL;
    self_max_ad_content_rating = "";
    is_for_child_directed_treatment = false;
    is_test_europe_user_consent = false;
    
    ERR_FAIL_COND(instance != NULL);
    
    instance = this;
    NSLog(@"initialize admob");
    NSLog(@"Poing AdMob Plugin version: %@", PLUGIN_VERSION);
}

AdMob::~AdMob() {
    if (instance == this) {
        instance = NULL;
    }
    NSLog(@"deinitialize admob");
}

AdMob *AdMob::get_singleton() {
    return instance;
};


void AdMob::loadConsentForm()
{
    [UMPConsentForm
        loadWithCompletionHandler:^(UMPConsentForm *form, NSError *loadError)
        {
            if (loadError)
            {
                emit_signal("consent_form_load_failure", (int) loadError.code, [loadError.localizedDescription UTF8String]);
            }
            else
            {
                String consentStatusMsg = "";

                if (UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatusRequired)
                {
                    [form
                        presentFromViewController:(ViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController
                        completionHandler:^(NSError *_Nullable dismissError)
                        {
                            emit_signal("consent_form_dismissed");
                            if (UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatusObtained)
                            {
                                emit_signal("consent_status_changed", "User consent obtained. Personalization not defined.");
                            }
                        }
                     ];
                    consentStatusMsg = "User consent required but not yet obtained.";
                }

                if (UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatusUnknown)
                {
                    consentStatusMsg = "Unknown consent status.";
                }
                else if (UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatusNotRequired)
                {
                    consentStatusMsg = "User consent not required. For example, the user is not in the EEA or the UK.";
                }
                else if (UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatusObtained)
                {
                    consentStatusMsg = "User consent obtained. Personalization not defined.";
                }
                emit_signal("consent_status_changed", consentStatusMsg);
            }
         }
    ];
}

void AdMob::reset_consent_state(){
    NSLog(@"Reseting consent state");
    [UMPConsentInformation.sharedInstance reset];
}

void AdMob::request_user_consent()
{
    UMPRequestParameters *parameters = [[UMPRequestParameters alloc] init];
    parameters.tagForUnderAgeOfConsent = this -> is_for_child_directed_treatment;
    
    if (this -> is_test_europe_user_consent)
    {
        NSLog(@"Testing the UMP");
        NSLog(@"UUID: %@", [[[UIDevice currentDevice] identifierForVendor] UUIDString] );
        NSLog(@"device ID: %@", [NSString stringWithCString: getDeviceId() encoding: NSUTF8StringEncoding] );
        UMPDebugSettings *debugSettings = [[UMPDebugSettings alloc] init];
        debugSettings.testDeviceIdentifiers = @[ [[[UIDevice currentDevice] identifierForVendor] UUIDString] ];
        debugSettings.geography = UMPDebugGeographyEEA;
        parameters.debugSettings = debugSettings;
    }

    // Request an update to the consent information.
    [UMPConsentInformation.sharedInstance requestConsentInfoUpdateWithParameters: parameters
        completionHandler:^(NSError *_Nullable error)
        {
            if (error)
            {
                emit_signal("consent_info_update_failure", (int) error.code, [error.localizedDescription UTF8String]);
            }
            else
            {
                UMPFormStatus formStatus = UMPConsentInformation.sharedInstance.formStatus;
                if (formStatus == UMPFormStatusAvailable)
                {
                    loadConsentForm();
                    emit_signal("consent_info_update_success", "Consent Form Available");
                }
                else
                {
                    emit_signal("consent_info_update_success", "Consent Form not Available");
                }
            }
        }
    ];
}

void AdMob::initialize(bool is_for_child_directed_treatment, const String &max_ad_content_rating, bool is_real, bool is_test_europe_user_consent, const String &google_request_agent)
{
    if (instance != this || initialized)
    {
        NSLog(@"AdMob Module already initialized");
        return;
    }
    NSLog(@"AdMob Module will try to initialize now");

    self_max_ad_content_rating = max_ad_content_rating;
    this -> is_test_europe_user_consent = is_test_europe_user_consent;
    
    if (!is_real){
        #if TARGET_IPHONE_SIMULATOR
            NSLog(@"on Testing Simulator: %@", @"Simulator are now testing devices by default");
        #else
            GADMobileAds.sharedInstance.requestConfiguration.testDeviceIdentifiers = @ [ [NSString stringWithCString: getDeviceId() encoding: NSUTF8StringEncoding] ];
            NSLog(@"on Testing Real Device: testDeviceIdentifiers: %@", [NSString stringWithCString: getDeviceId() encoding: NSUTF8StringEncoding]);
        #endif
    }
    
    if (is_for_child_directed_treatment) {
        GADMobileAds.sharedInstance.requestConfiguration.tagForChildDirectedTreatment = @YES;
    } else {
        GADMobileAds.sharedInstance.requestConfiguration.tagForChildDirectedTreatment = @NO;
    }
    
    NSLog(@"tagForChildDirectedTreatment = %@", is_for_child_directed_treatment ? @"YES" : @"NO");
    
    if (self_max_ad_content_rating == "G") {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating = GADMaxAdContentRatingGeneral;
        NSLog(@"maxAdContentRating = GADMaxAdContentRatingGeneral");
    }
    else if (self_max_ad_content_rating == "PG") {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating = GADMaxAdContentRatingParentalGuidance;
        NSLog(@"maxAdContentRating = GADMaxAdContentRatingParentalGuidance");
    }
    else if (self_max_ad_content_rating == "T") {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating = GADMaxAdContentRatingTeen;
        NSLog(@"maxAdContentRating = GADMaxAdContentRatingTeen");
    }
    else if (self_max_ad_content_rating == "MA") {
        GADMobileAds.sharedInstance.requestConfiguration.maxAdContentRating = GADMaxAdContentRatingMatureAudience;
        NSLog(@"maxAdContentRating = GADMaxAdContentRatingMatureAudience");
    }

    GADInitialize();
    NSString *requestAgentNSString = [NSString stringWithUTF8String:google_request_agent.utf8().get_data()];

    bannerObj = [[Banner alloc] initWithRequestAgent:requestAgentNSString];
    interstitialObj = [[Interstitial alloc] initWithRequestAgent:requestAgentNSString];
    rewardedObj = [[Rewarded alloc] initWithRequestAgent:requestAgentNSString];
    rewardedInterstitialObj = [[RewardedInterstitial alloc] initWithRequestAgent:requestAgentNSString];

}

void AdMob::GADInitialize(){
    [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus *_Nonnull status)
    {
        NSDictionary<NSString *, GADAdapterStatus *>* states = [status adapterStatusesByClassName];
        GADAdapterStatus * adapterStatus = states[@"GADMobileAds"];
        NSLog(@"%s : %s", "GADMobileAds", adapterStatus.state ? "True" : "False");

        initialized = adapterStatus.state;
        if (adapterStatus.state == 0){
            NSLog(@"AdMob Module couldn't be initialized, check your configurations");
        }
        else if (adapterStatus.state == 1){
            NSLog(@"AdMob Module has been initialized");
        }
        
        emit_signal("initialization_complete", (int) adapterStatus.state, "GADMobileAds");
    }];
}

void AdMob::load_banner(const String &ad_unit_id, int position, const String &size, bool show_instantly, bool respect_safe_area) {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return;
    }
    
    NSString *ad_unit_id_NSString = [NSString stringWithCString:ad_unit_id.utf8().get_data() encoding: NSUTF8StringEncoding];
    NSString *size_NSString       = [NSString stringWithCString:size.utf8().get_data() encoding: NSUTF8StringEncoding];
    [bannerObj load_banner: ad_unit_id_NSString : position: size_NSString: show_instantly: respect_safe_area];
    
}

void AdMob::destroy_banner() {
    if (!initialized) return;
    
    [bannerObj destroy_banner];
}

void AdMob::show_banner() {
    if (!initialized) return;
    
    [bannerObj show_banner];
}

void AdMob::hide_banner() {
    if (!initialized) return;
    
    [bannerObj hide_banner];
}

float AdMob::get_banner_width() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return 0;
    }
    return [bannerObj get_banner_width];

}

float AdMob::get_banner_height() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return 0;
    }
    return [bannerObj get_banner_height];
}

float AdMob::get_banner_width_in_pixels() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return 0;
    }
    return [bannerObj get_banner_width_in_pixels];
}

float AdMob::get_banner_height_in_pixels() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return 0;
    }
    return [bannerObj get_banner_height_in_pixels];
}

bool AdMob::get_is_initialized() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
    }
    return initialized;
}

bool AdMob::get_is_banner_loaded() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return false;
    }
    return [bannerObj get_is_banner_loaded];
}

bool AdMob::get_is_interstitial_loaded() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return false;
    }
    return [interstitialObj get_is_interstitial_loaded];
}

bool AdMob::get_is_rewarded_loaded() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return false;
    }
    return [rewardedObj get_is_rewarded_loaded];
}

bool AdMob::get_is_rewarded_interstitial_loaded() {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return false;
    }
    return [rewardedInterstitialObj get_is_rewarded_interstitial_loaded];
}


void AdMob::load_interstitial(const String &ad_unit_id) {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return;
    }
    
    NSString *ad_unit_id_NSString = [NSString stringWithCString:ad_unit_id.utf8().get_data() encoding: NSUTF8StringEncoding];
    [interstitialObj load_interstitial: ad_unit_id_NSString];
    
}

void AdMob::show_interstitial() {
    if (!initialized) return;
    
    [interstitialObj show_interstitial];
}

void AdMob::load_rewarded(const String &ad_unit_id) {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return;
    }
    
    NSString *ad_unit_id_NSString = [NSString stringWithCString:ad_unit_id.utf8().get_data() encoding: NSUTF8StringEncoding];
    [rewardedObj load_rewarded: ad_unit_id_NSString];
    
}

void AdMob::show_rewarded() {
    if (!initialized) return;
    
    [rewardedObj show_rewarded];
}


void AdMob::load_rewarded_interstitial(const String &ad_unit_id) {
    if (!initialized) {
        NSLog(@"AdMob Module not initialized");
        return;
    }
    
    NSString *ad_unit_id_NSString = [NSString stringWithCString:ad_unit_id.utf8().get_data() encoding: NSUTF8StringEncoding];
    [rewardedInterstitialObj load_rewarded_interstitial: ad_unit_id_NSString];
    
}

void AdMob::show_rewarded_interstitial() {
    if (!initialized) return;
    
    [rewardedInterstitialObj show_rewarded_interstitial];
}


void AdMob::_bind_methods() {
    ADD_SIGNAL(MethodInfo("initialization_complete", PropertyInfo(Variant::INT, "id"), PropertyInfo(Variant::STRING, "description")));
    ADD_SIGNAL(MethodInfo("consent_form_dismissed"));
    ADD_SIGNAL(MethodInfo("consent_status_changed", PropertyInfo(Variant::STRING, "description")));
    ADD_SIGNAL(MethodInfo("consent_form_load_failure", PropertyInfo(Variant::INT, "id"), PropertyInfo(Variant::STRING, "description")));
    ADD_SIGNAL(MethodInfo("consent_info_update_success", PropertyInfo(Variant::STRING, "description")));
    ADD_SIGNAL(MethodInfo("consent_info_update_failure", PropertyInfo(Variant::INT, "id"), PropertyInfo(Variant::STRING, "description")));

    ADD_SIGNAL(MethodInfo("banner_loaded"));
    ADD_SIGNAL(MethodInfo("banner_closed"));
    ADD_SIGNAL(MethodInfo("banner_opened"));
    ADD_SIGNAL(MethodInfo("banner_failed_to_load", PropertyInfo(Variant::INT, "id")));
    ADD_SIGNAL(MethodInfo("banner_destroyed"));
    ADD_SIGNAL(MethodInfo("banner_recorded_impression"));
    ADD_SIGNAL(MethodInfo("banner_clicked"));

    ADD_SIGNAL(MethodInfo("interstitial_loaded"));
    ADD_SIGNAL(MethodInfo("interstitial_closed"));
    ADD_SIGNAL(MethodInfo("interstitial_failed_to_show", PropertyInfo(Variant::INT, "id")));
    ADD_SIGNAL(MethodInfo("interstitial_opened"));
    ADD_SIGNAL(MethodInfo("interstitial_failed_to_load", PropertyInfo(Variant::INT, "id")));
    ADD_SIGNAL(MethodInfo("interstitial_recorded_impression"));
    ADD_SIGNAL(MethodInfo("interstitial_clicked"));

    ADD_SIGNAL(MethodInfo("rewarded_ad_loaded"));
    ADD_SIGNAL(MethodInfo("rewarded_ad_closed"));
    ADD_SIGNAL(MethodInfo("rewarded_ad_failed_to_show", PropertyInfo(Variant::INT, "id")));
    ADD_SIGNAL(MethodInfo("rewarded_ad_opened"));
    ADD_SIGNAL(MethodInfo("rewarded_ad_failed_to_load", PropertyInfo(Variant::INT, "id")));
    ADD_SIGNAL(MethodInfo("rewarded_ad_recorded_impression"));
    ADD_SIGNAL(MethodInfo("rewarded_ad_clicked"));

    ADD_SIGNAL(MethodInfo("rewarded_interstitial_ad_failed_to_load", PropertyInfo(Variant::INT, "id")));
    ADD_SIGNAL(MethodInfo("rewarded_interstitial_ad_loaded"));
    ADD_SIGNAL(MethodInfo("rewarded_interstitial_ad_opened"));
    ADD_SIGNAL(MethodInfo("rewarded_interstitial_ad_failed_to_show", PropertyInfo(Variant::INT, "id")));
    ADD_SIGNAL(MethodInfo("rewarded_interstitial_ad_closed"));
    ADD_SIGNAL(MethodInfo("rewarded_interstitial_ad_recorded_impression"));
    ADD_SIGNAL(MethodInfo("rewarded_interstitial_ad_clicked"));

    ADD_SIGNAL(MethodInfo("user_earned_rewarded", PropertyInfo(Variant::STRING, "description"), PropertyInfo(Variant::INT, "id")));
    
    ClassDB::bind_method("initialize", &AdMob::initialize);

    ClassDB::bind_method("reset_consent_state", &AdMob::reset_consent_state);
    ClassDB::bind_method("request_user_consent", &AdMob::request_user_consent);

    ClassDB::bind_method("get_banner_width", &AdMob::get_banner_width);
    ClassDB::bind_method("get_banner_height", &AdMob::get_banner_height);
    ClassDB::bind_method("get_banner_width_in_pixels", &AdMob::get_banner_width_in_pixels);
    ClassDB::bind_method("get_banner_height_in_pixels", &AdMob::get_banner_height_in_pixels);

    ClassDB::bind_method("get_is_initialized", &AdMob::get_is_initialized);
    ClassDB::bind_method("get_is_banner_loaded", &AdMob::get_is_banner_loaded);
    ClassDB::bind_method("get_is_interstitial_loaded", &AdMob::get_is_interstitial_loaded);
    ClassDB::bind_method("get_is_rewarded_loaded", &AdMob::get_is_rewarded_loaded);
    ClassDB::bind_method("get_is_rewarded_interstitial_loaded", &AdMob::get_is_rewarded_interstitial_loaded);

    ClassDB::bind_method("load_banner", &AdMob::load_banner);
    ClassDB::bind_method("destroy_banner", &AdMob::destroy_banner);

    ClassDB::bind_method("show_banner", &AdMob::show_banner);
    ClassDB::bind_method("hide_banner", &AdMob::hide_banner);

    ClassDB::bind_method("load_interstitial", &AdMob::load_interstitial);
    ClassDB::bind_method("show_interstitial", &AdMob::show_interstitial);

    ClassDB::bind_method("load_rewarded", &AdMob::load_rewarded);
    ClassDB::bind_method("show_rewarded", &AdMob::show_rewarded);

    ClassDB::bind_method("load_rewarded_interstitial", &AdMob::load_rewarded_interstitial);
    ClassDB::bind_method("show_rewarded_interstitial", &AdMob::show_rewarded_interstitial);
}



const char * AdMob::getDeviceId()
{
    NSUUID* adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    const char *cStr = [adid.UUIDString UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }

    return [output UTF8String];
}

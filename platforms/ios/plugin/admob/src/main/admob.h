//
//  admob.h
//  admob
//
//  Created by Gustavo Maciel on 16/01/21.
//

#ifndef admob_plugin_implementation_h
    #define admob_plugin_implementation_h

    #ifdef VERSION_4_0
    #include "core/object/object.h"
    #endif

    #ifdef VERSION_3_X
    #include "core/object.h"
    #endif
    
    @import GoogleMobileAds;

    #ifdef __OBJC__
        #include "../formats/Banner.h"
        #include "../formats/Interstitial.h"
        #include "../formats/Rewarded.h"
        #include "../formats/RewardedInterstitial.h"

        @class Banner;
        @class Interstitial;
        @class Rewarded;
        @class RewardedInterstitial;

        typedef Banner *banner;
        typedef Interstitial *interstitial;
        typedef Rewarded *rewarded;
        typedef RewardedInterstitial *rewardedInterstitial;
    #else
        typedef void *banner;
        typedef void *interstitial;
        typedef void *rewarded;
        typedef void *rewardedInterstitial;
    #endif

    class AdMob : public Object {
        GDCLASS(AdMob, Object);
        
        bool initialized;
        bool is_for_child_directed_treatment;
        bool is_test_europe_user_consent;
        String self_max_ad_content_rating;
        static AdMob *instance;

        banner bannerObj;
        interstitial interstitialObj;
        rewarded rewardedObj;
        rewardedInterstitial rewardedInterstitialObj;

    protected:
        static void _bind_methods();
        
    public:
        void initialize(bool is_for_child_directed_treatment,
                        const String &max_ad_content_rating,
                        bool is_real,
                        bool is_test_europe_user_consent,
                        const String &google_request_agent);
        
        void load_banner(const String &ad_unit_id,
                         int gravity,
                         const String &size,
                         bool show_instantly,
                         bool respect_safe_area);
        
        void destroy_banner();
        
        void show_banner();
        void hide_banner();
        
        float get_banner_width();
        float get_banner_height();
        float get_banner_width_in_pixels();
        float get_banner_height_in_pixels();

        bool get_is_initialized();
        bool get_is_banner_loaded();
        bool get_is_interstitial_loaded();
        bool get_is_rewarded_loaded();
        bool get_is_rewarded_interstitial_loaded();
        
        void load_interstitial(const String &ad_unit_id);
        void show_interstitial();
        
        void load_rewarded(const String &ad_unit_id);
        void show_rewarded();

        void load_rewarded_interstitial(const String &ad_unit_id);
        void show_rewarded_interstitial();

        void request_user_consent();
        void reset_consent_state();

        AdMob();
        ~AdMob();

        static AdMob *get_singleton();
    private:
        const char* getDeviceId();
        void GADInitialize();
       
        void loadConsentForm();

    };


#endif /* admob_plugin_implementation_h */

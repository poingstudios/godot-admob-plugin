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

package com.poing.admob;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.SignalInfo;

import com.google.android.gms.ads.AdError;
import com.google.android.gms.ads.FullScreenContentCallback;
import com.google.android.gms.ads.MobileAds; //used for initialize
import com.google.android.gms.ads.LoadAdError;
import com.google.android.gms.ads.AdRequest; //used for make requests of ads

import com.google.android.gms.ads.AdView; //used to banner ads
import com.google.android.gms.ads.AdSize; //used to set/get size banner ads
import com.google.android.gms.ads.AdListener; //used to get events of ads (banner, interstitial)

import com.google.android.gms.ads.initialization.AdapterStatus;
import com.google.android.gms.ads.interstitial.InterstitialAd; //interstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback;

import com.google.android.gms.ads.RequestConfiguration;
import com.google.android.gms.ads.rewarded.RewardedAd; //rewardedAd
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

import com.google.android.gms.ads.rewardedinterstitial.RewardedInterstitialAd;
import com.google.android.gms.ads.rewardedinterstitial.RewardedInterstitialAdLoadCallback;
import com.google.android.ump.ConsentDebugSettings;
import com.google.android.ump.ConsentInformation;
import com.google.android.ump.ConsentRequestParameters;
import com.google.android.ump.UserMessagingPlatform;

import android.app.Activity;
import android.graphics.Rect;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.DisplayCutout;
import android.view.Gravity;
import android.view.WindowInsets;
import android.widget.FrameLayout; //get Godot Layout
import android.view.View;
import android.provider.Settings;
import androidx.annotation.NonNull;
import androidx.collection.ArraySet;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.Set;

public class AdMob extends org.godotengine.godot.plugin.GodotPlugin {
    private static final String PLUGIN_VERSION = "2.1.8";
    private static final String LOG_TAG_NAME = "poing-godot-admob";
    private boolean aIsInitialized = false;
    private String aInitializationDesc = "";
    private String aGoogleRequestAgent = "";
    private Activity aActivity;

    private ConsentInformation aConsentInformation;
    private boolean aIsTestEuropeUserConsent;

    private boolean aIsForChildDirectedTreatment;

    private boolean aIsBannerLoaded = false;
    private boolean aIsInterstitialLoaded = false;
    private boolean aIsRewardedLoaded = false;
    private boolean aIsRewardedInterstitialLoaded = false;

    private FrameLayout aGodotLayout; // store the godot layout
    private FrameLayout.LayoutParams aGodotLayoutParams; // Store the godot layout params

    private AdView aAdView; //view of banner
    private AdSize aAdSize; //adSize of banner
    private InterstitialAd aInterstitialAd;
    private RewardedAd aRewardedAd;
    private RewardedInterstitialAd aRewardedInterstitialAd;

    public AdMob(Godot godot) {
        super(godot);
    }

    @NonNull
    @Override
    public List<String> getPluginMethods() {
        return Arrays.asList(
                "initialize",
                "load_banner",
                "destroy_banner",
                "show_banner",
                "hide_banner",
                "load_interstitial",
                "show_interstitial",
                "load_rewarded",
                "show_rewarded",
                "load_rewarded_interstitial",
                "show_rewarded_interstitial",
                "request_user_consent",
                "reset_consent_state",
                "get_banner_width",
                "get_banner_height",
                "get_banner_width_in_pixels",
                "get_banner_height_in_pixels",
                "get_is_initialized",
                "get_initialization_description",
                "get_is_banner_loaded",
                "get_is_interstitial_loaded",
                "get_is_rewarded_loaded",
                "get_is_rewarded_interstitial_loaded"
        );
    }

    public boolean get_is_initialized() {
        return aIsInitialized;
    }
    public boolean get_is_banner_loaded() {
        return aIsBannerLoaded;
    }
    public boolean get_is_interstitial_loaded() {
        return aIsInterstitialLoaded;
    }
    public boolean get_is_rewarded_loaded() {
        return aIsRewardedLoaded;
    }
    public boolean get_is_rewarded_interstitial_loaded() {
        return aIsRewardedInterstitialLoaded;
    }
    public String get_initialization_description() { 
        return aInitializationDesc; 
    }

    @Override
    public View onMainCreate(Activity pActivity) {
        aActivity = pActivity;
        aGodotLayout = new FrameLayout(pActivity);
        return aGodotLayout;
    }

    @NonNull
    @Override
    public String getPluginName() {
        return getClass().getSimpleName();
    }

    @NonNull
    @Override
    public Set<SignalInfo> getPluginSignals() {
        Set<SignalInfo> signals = new ArraySet<>();

        signals.add(new SignalInfo("initialization_complete", Integer.class, String.class));

        signals.add(new SignalInfo("consent_form_dismissed"));
        signals.add(new SignalInfo("consent_status_changed", String.class));
        signals.add(new SignalInfo("consent_form_load_failure", Integer.class, String.class));
        signals.add(new SignalInfo("consent_info_update_success", String.class));
        signals.add(new SignalInfo("consent_info_update_failure", Integer.class, String.class));

        signals.add(new SignalInfo("banner_loaded"));
        signals.add(new SignalInfo("banner_failed_to_load", Integer.class));
        signals.add(new SignalInfo("banner_opened"));
        signals.add(new SignalInfo("banner_clicked"));
        signals.add(new SignalInfo("banner_closed"));
        signals.add(new SignalInfo("banner_recorded_impression"));
        signals.add(new SignalInfo("banner_destroyed"));

        signals.add(new SignalInfo("interstitial_failed_to_load", Integer.class));
        signals.add(new SignalInfo("interstitial_loaded"));
        signals.add(new SignalInfo("interstitial_failed_to_show", Integer.class));
        signals.add(new SignalInfo("interstitial_opened"));
        signals.add(new SignalInfo("interstitial_clicked"));
        signals.add(new SignalInfo("interstitial_closed"));
        signals.add(new SignalInfo("interstitial_recorded_impression"));

        signals.add(new SignalInfo("rewarded_ad_failed_to_load", Integer.class));
        signals.add(new SignalInfo("rewarded_ad_loaded"));
        signals.add(new SignalInfo("rewarded_ad_failed_to_show", Integer.class));
        signals.add(new SignalInfo("rewarded_ad_opened"));
        signals.add(new SignalInfo("rewarded_ad_clicked"));
        signals.add(new SignalInfo("rewarded_ad_closed"));
        signals.add(new SignalInfo("rewarded_ad_recorded_impression"));

        signals.add(new SignalInfo("rewarded_interstitial_ad_failed_to_load", Integer.class));
        signals.add(new SignalInfo("rewarded_interstitial_ad_loaded"));
        signals.add(new SignalInfo("rewarded_interstitial_ad_failed_to_show", Integer.class));
        signals.add(new SignalInfo("rewarded_interstitial_ad_opened"));
        signals.add(new SignalInfo("rewarded_interstitial_ad_clicked"));
        signals.add(new SignalInfo("rewarded_interstitial_ad_closed"));
        signals.add(new SignalInfo("rewarded_interstitial_ad_recorded_impression"));

        signals.add(new SignalInfo("user_earned_rewarded", String.class, Integer.class));

        return signals;
    }


    public void initialize(boolean pIsForChildDirectedTreatment,
                           String pMaxAdContentRating,
                           boolean pIsReal,
                           boolean pIsTestEuropeUserConsent,
                           String googleRequestAgent) {
        if (!aIsInitialized){
            aIsForChildDirectedTreatment = pIsForChildDirectedTreatment;
            aConsentInformation = UserMessagingPlatform.getConsentInformation(aActivity);
            aIsTestEuropeUserConsent = pIsTestEuropeUserConsent;
            aGoogleRequestAgent = googleRequestAgent;

            setMobileAdsRequestConfiguration(aIsForChildDirectedTreatment, pMaxAdContentRating, pIsReal); //First call MobileAds.setRequestConfiguration https://groups.google.com/g/google-admob-ads-sdk/c/17oVu0sABjs
            MobileAds.initialize(aActivity, initializationStatus -> {
                AdapterStatus status = Objects.requireNonNull(initializationStatus.getAdapterStatusMap().get("com.google.android.gms.ads.MobileAds"));
                aInitializationDesc = status.getDescription();
                int statusGADMobileAds = status.getInitializationState().ordinal();

                if (statusGADMobileAds == 0) {
                    aIsInitialized = false;
                }
                else if (statusGADMobileAds == 1){
                    aIsInitialized = true;
                }

                emitSignal("initialization_complete",statusGADMobileAds, "GADMobileAds");
            }); //initializes the admob
        }
    }

    private void loadConsentForm() {
        UserMessagingPlatform.loadConsentForm(
                aActivity,
                consentForm -> {
                    String consentStatusMsg = "";
                    if (aConsentInformation.getConsentStatus() == ConsentInformation.ConsentStatus.REQUIRED) {
                        consentForm.show(
                                aActivity,
                                formError -> {
                                    loadConsentForm();
                                    emitSignal("consent_form_dismissed");
                                }
                        );
                        consentStatusMsg = "User consent required but not yet obtained.";
                    }
                    switch (aConsentInformation.getConsentStatus()) {
                        case ConsentInformation.ConsentStatus.UNKNOWN:
                            consentStatusMsg = "Unknown consent status.";
                            break;
                        case ConsentInformation.ConsentStatus.NOT_REQUIRED:
                            consentStatusMsg = "User consent not required. For example, the user is not in the EEA or the UK.";
                            break;
                        case ConsentInformation.ConsentStatus.OBTAINED:
                            consentStatusMsg = "User consent obtained. Personalization not defined.";
                            break;
                    }
                    emitSignal("consent_status_changed", consentStatusMsg);
                },
                formError -> emitSignal("consent_form_load_failure", formError.getErrorCode(), formError.getMessage())
        );
    }

    public void request_user_consent() {
        aConsentInformation = UserMessagingPlatform.getConsentInformation(aActivity);

        ConsentRequestParameters.Builder paramsBuilder = new ConsentRequestParameters.Builder().setTagForUnderAgeOfConsent(aIsForChildDirectedTreatment);

        ConsentRequestParameters params;
        if (aIsTestEuropeUserConsent) //https://developers.google.com/admob/ump/android/quick-start#testing
        {
            ConsentDebugSettings debugSettings = new ConsentDebugSettings.Builder(aActivity)
                    .setDebugGeography(ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_EEA)
                    .addTestDeviceHashedId(getDeviceId())
                    .build();
            params = paramsBuilder.setConsentDebugSettings(debugSettings).build();
        } else {
            params = paramsBuilder.build();
        }

        aConsentInformation.requestConsentInfoUpdate(aActivity, params,
                () -> {
                    if (aConsentInformation.isConsentFormAvailable()) {
                        emitSignal("consent_info_update_success", "Consent Form Available");
                        loadConsentForm();
                    } else {
                        emitSignal("consent_info_update_success", "Consent Form not Available");
                    }
                },
                formError -> emitSignal("consent_info_update_failure", formError.getErrorCode(), formError.getMessage())
        );
    }

    public void reset_consent_state() {
        aConsentInformation.reset(); //https://developers.google.com/admob/ump/android/quick-start#reset_consent_state
    }

    private void setMobileAdsRequestConfiguration(boolean pIsForChildDirectedTreatment, String pMaxAdContentRating, boolean pIsReal) {
        RequestConfiguration requestConfiguration;
        RequestConfiguration.Builder requestConfigurationBuilder = new RequestConfiguration.Builder();

        if (!pIsReal) {
            requestConfigurationBuilder.setTestDeviceIds(Collections.singletonList(getDeviceId()));
        }

        requestConfigurationBuilder.setTagForChildDirectedTreatment(pIsForChildDirectedTreatment ? 1 : 0);

        if (pIsForChildDirectedTreatment) {
            requestConfigurationBuilder.setMaxAdContentRating(RequestConfiguration.MAX_AD_CONTENT_RATING_G);
        } else {
            switch (pMaxAdContentRating) {
                case RequestConfiguration.MAX_AD_CONTENT_RATING_G:
                case RequestConfiguration.MAX_AD_CONTENT_RATING_MA:
                case RequestConfiguration.MAX_AD_CONTENT_RATING_PG:
                case RequestConfiguration.MAX_AD_CONTENT_RATING_T:
                case RequestConfiguration.MAX_AD_CONTENT_RATING_UNSPECIFIED:
                    requestConfigurationBuilder.setMaxAdContentRating(pMaxAdContentRating);
                    break;
            }
        }

        requestConfiguration = requestConfigurationBuilder.build();

        MobileAds.setRequestConfiguration(requestConfiguration);
    }

    private AdRequest getAdRequest() {
        AdRequest.Builder adRequestBuilder = new AdRequest.Builder();

        if (!aGoogleRequestAgent.isEmpty()){
            adRequestBuilder.setRequestAgent(aGoogleRequestAgent);
            Log.d(LOG_TAG_NAME, aGoogleRequestAgent);
        }
        return adRequestBuilder.build();
    }

    private Rect getSafeArea() {
        final Rect safeInsetRect = new Rect();
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
            return safeInsetRect;
        }

        final WindowInsets windowInsets = aActivity.getWindow().getDecorView().getRootWindowInsets();
        if (windowInsets == null) {
            return safeInsetRect;
        }

        final DisplayCutout displayCutout = windowInsets.getDisplayCutout();
        if (displayCutout != null) {
            safeInsetRect.set(displayCutout.getSafeInsetLeft(), displayCutout.getSafeInsetTop(), displayCutout.getSafeInsetRight(), displayCutout.getSafeInsetBottom());
        }

        return safeInsetRect;
    }

    //BANNER only one is allowed, please do not try to place more than one, as your ads on the app may have the chance to be banned!
    public void load_banner(final String pAdUnitId, final int pPosition, final String pSize, final boolean pShowInstantly, final boolean pRespectSafeArea) {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized) {
                if (aAdView != null) destroy_banner();
                aAdView = new AdView(aActivity);

                aAdView.setAdUnitId(pAdUnitId);
                switch (pSize) {
                    case "BANNER":
                        aAdView.setAdSize(AdSize.BANNER);
                        break;
                    case "LARGE_BANNER":
                        aAdView.setAdSize(AdSize.LARGE_BANNER);
                        break;
                    case "MEDIUM_RECTANGLE":
                        aAdView.setAdSize(AdSize.MEDIUM_RECTANGLE);
                        break;
                    case "FULL_BANNER":
                        aAdView.setAdSize(AdSize.FULL_BANNER);
                        break;
                    case "LEADERBOARD":
                        aAdView.setAdSize(AdSize.LEADERBOARD);
                        break;
                    case "ADAPTIVE":
                        aAdView.setAdSize(getAdSizeAdaptive());
                        break;
                    default:
                        aAdView.setAdSize(AdSize.SMART_BANNER);
                        break;
                }
                aAdSize = aAdView.getAdSize(); //store AdSize of banner due a bug (throws error when do aAdView.getAdSize(); called by Godot)
                aAdView.setAdListener(new AdListener() {
                    @Override
                    public void onAdLoaded() {
                        // Code to be executed when an ad finishes loading.
                        emitSignal("banner_loaded");

                        if (pShowInstantly){
                            show_banner();
                        }
                        else{
                            hide_banner();
                        }
                        aIsBannerLoaded = true;
                    }

                    @Override
                    public void onAdFailedToLoad(@NonNull LoadAdError adError) {
                        // Code to be executed when an ad request fails.
                        emitSignal("banner_failed_to_load", adError.getCode());
                    }

                    @Override
                    public void onAdOpened() {
                        // Code to be executed when an ad opens an overlay that
                        // covers the screen.
                        emitSignal("banner_opened");
                    }

                    @Override
                    public void onAdClicked() {
                        // Code to be executed when the native ad is closed.
                        emitSignal("banner_clicked");
                    }

                    @Override
                    public void onAdClosed() {
                        // Code to be executed when the user is about to return
                        // to the app after tapping on an ad.
                        emitSignal("banner_closed");
                    }

                    @Override
                    public void onAdImpression() {
                        // Code to be executed when the user is about to return
                        // to the app after tapping on an ad.
                        emitSignal("banner_recorded_impression");
                    }
                });

                aGodotLayoutParams = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.WRAP_CONTENT);
                if (pPosition == 0)//BOTTOM
                {
                    aGodotLayoutParams.gravity = Gravity.BOTTOM;
                    if (pRespectSafeArea)
                        aAdView.setY(-getSafeArea().bottom); //Need to validate if this value will be positive or negative
                } else if (pPosition == 1)//TOP
                {
                    aGodotLayoutParams.gravity = Gravity.TOP;
                    if (pRespectSafeArea)
                        aAdView.setY(getSafeArea().top);
                }
                aGodotLayout.addView(aAdView, aGodotLayoutParams);

                aAdView.loadAd(getAdRequest());

            }
        });
    }
    private AdSize getAdSizeAdaptive() {
        // Determine the screen width (less decorations) to use for the ad width.
        Display display = aActivity.getWindowManager().getDefaultDisplay();
        DisplayMetrics outMetrics = new DisplayMetrics();
        display.getMetrics(outMetrics);

        float density = outMetrics.density;

        float adWidthPixels = outMetrics.widthPixels;

        int adWidth = (int) (adWidthPixels / density);
        return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(aActivity, adWidth);
    }

    public void destroy_banner()//IF THIS METHOD IS CALLED ON GODOT, THE BANNER WILL ONLY APPEAR AGAIN IF THE BANNER IS LOADED AGAIN
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized && aAdView != null) {
                aGodotLayout.removeView(aAdView);
                aAdView.destroy();
                aAdView = null;

                emitSignal("banner_destroyed");
                aIsBannerLoaded = false;
            }
        });
    }
    public void show_banner()
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized && aAdView != null) {
                if (aAdView.getVisibility() != View.VISIBLE){
                    aAdView.setVisibility(View.VISIBLE);
                    aAdView.resume();
                }
            }
        });
    }
    public void hide_banner()
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized && aAdView != null) {
                if (aAdView.getVisibility() != View.GONE){
                    aAdView.setVisibility(View.GONE);
                    aAdView.pause();
                }
            }
        });
    }

    public int get_banner_width() {
        if (aIsInitialized && aAdSize != null) {
            return aAdSize.getWidth();
        }
        return 0;
    }

    public int get_banner_height() {
        if (aIsInitialized && aAdSize != null) {
            return aAdSize.getHeight();
        }
        return 0;
    }

    public int get_banner_width_in_pixels() {
        if (aIsInitialized && aAdSize != null) {
            return aAdSize.getWidthInPixels(aActivity);
        }
        return 0;
    }

    public int get_banner_height_in_pixels() {
        if (aIsInitialized && aAdSize != null) {
            return aAdSize.getHeightInPixels(aActivity);
        }
        return 0;
    }


    //BANNER
    //INTERSTITIAL
    public void load_interstitial(final String pAdUnitId)
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized) {
                InterstitialAd.load(aActivity, pAdUnitId, getAdRequest(), new InterstitialAdLoadCallback() {
                    @Override
                    public void onAdLoaded(@NonNull InterstitialAd interstitialAd) {
                        // Code to be executed when an ad finishes loading.
                        aInterstitialAd = interstitialAd;

                        emitSignal("interstitial_loaded");
                        aIsInterstitialLoaded = true;
                    }

                    @Override
                    public void onAdFailedToLoad(@NonNull LoadAdError adError) {
                        // Code to be executed when an ad request fails.
                        aInterstitialAd = null;
                        emitSignal("interstitial_failed_to_load", adError.getCode());
                    }
                });
            }
        });
    }
    public void show_interstitial()
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized) {
                if (aInterstitialAd != null) {
                    aInterstitialAd.setFullScreenContentCallback(new FullScreenContentCallback() {
                        @Override
                        public void onAdClicked() {
                            // Called when a click is recorded for an ad.
                            emitSignal("interstitial_clicked");
                        }

                        @Override
                        public void onAdDismissedFullScreenContent() {
                            // Called when fullscreen content is dismissed.
                            aInterstitialAd = null;
                            emitSignal("interstitial_closed");
                            aIsInterstitialLoaded = false;
                        }

                        @Override
                        public void onAdFailedToShowFullScreenContent(@NonNull AdError adError) {
                            // Called when fullscreen content failed to show.
                            aInterstitialAd = null;
                            emitSignal("interstitial_failed_to_show", adError.getCode());
                            aIsInterstitialLoaded = false;
                        }

                        @Override
                        public void onAdImpression() {
                            // Called when an impression is recorded for an ad.
                            emitSignal("interstitial_recorded_impression");
                        }

                        @Override
                        public void onAdShowedFullScreenContent() {
                            // Called when fullscreen content is shown.
                            emitSignal("interstitial_opened");
                        }
                    });

                    aInterstitialAd.show(aActivity);
                }
            }
        });
    }
    //INTERSTITIAL
    //REWARDED
    public void load_rewarded(final String pAdUnitId)
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized) {
                RewardedAd.load(aActivity, pAdUnitId, getAdRequest(), new RewardedAdLoadCallback(){
                    @Override
                    public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
                        // Handle the error.
                        aRewardedAd = null;
                        emitSignal("rewarded_ad_failed_to_load", loadAdError.getCode());

                    }

                    @Override
                    public void onAdLoaded(@NonNull RewardedAd rewardedAd) {
                        aRewardedAd = rewardedAd;
                        emitSignal("rewarded_ad_loaded");

                        aIsRewardedLoaded = true;
                    }
                });
            }
        });
    }

    public void show_rewarded()
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized) {
                if (aRewardedAd != null) {
                    aRewardedAd.setFullScreenContentCallback(new FullScreenContentCallback() {
                        @Override
                        public void onAdClicked() {
                            // Called when a click is recorded for an ad.
                            emitSignal("rewarded_ad_clicked");
                        }

                        @Override
                        public void onAdDismissedFullScreenContent() {
                            // Called when ad is dismissed.
                            aRewardedAd = null;
                            emitSignal("rewarded_ad_closed");
                            aIsRewardedLoaded = false;
                        }

                        @Override
                        public void onAdFailedToShowFullScreenContent(@NonNull AdError adError) {
                            // Called when ad fails to show.
                            aRewardedAd = null;
                            emitSignal("rewarded_ad_failed_to_show", adError.getCode());
                        }

                        @Override
                        public void onAdImpression() {
                            // Called when an impression is recorded for an ad.
                            emitSignal("rewarded_ad_recorded_impression");
                        }

                        @Override
                        public void onAdShowedFullScreenContent() {
                            // Called when ad is shown.
                            emitSignal("rewarded_ad_opened");
                        }
                    });

                    aRewardedAd.show(aActivity, rewardItem -> {
                        // Handle the reward.
                        emitSignal("user_earned_rewarded", rewardItem.getType(), rewardItem.getAmount());
                    });
                }
            }
        });
    }
    //

    public void load_rewarded_interstitial(final String pAdUnitId)
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized) {
                RewardedInterstitialAd.load(aActivity, pAdUnitId, getAdRequest(), new RewardedInterstitialAdLoadCallback(){
                    @Override
                    public void onAdFailedToLoad(@NonNull LoadAdError loadAdError) {
                        // Handle the error.
                        aRewardedInterstitialAd = null;
                        emitSignal("rewarded_interstitial_ad_failed_to_load", loadAdError.getCode());
                    }

                    @Override
                    public void onAdLoaded(@NonNull RewardedInterstitialAd rewardedInterstitialAd) {
                        aRewardedInterstitialAd = rewardedInterstitialAd;
                        emitSignal("rewarded_interstitial_ad_loaded");
                        aIsRewardedInterstitialLoaded = true;
                    }
                });
            }
        });
    }


    public void show_rewarded_interstitial()
    {
        aActivity.runOnUiThread(() -> {
            if (aIsInitialized) {
                if (aRewardedInterstitialAd != null) {
                    aRewardedInterstitialAd.setFullScreenContentCallback(new FullScreenContentCallback() {
                        @Override
                        public void onAdClicked() {
                            // Called when a click is recorded for an ad.
                            emitSignal("rewarded_interstitial_ad_clicked");
                        }

                        @Override
                        public void onAdDismissedFullScreenContent() {
                            // Called when ad is dismissed.
                            aRewardedInterstitialAd = null;
                            emitSignal("rewarded_interstitial_ad_closed");
                            aIsRewardedInterstitialLoaded = false;
                        }

                        @Override
                        public void onAdFailedToShowFullScreenContent(@NonNull AdError adError) {
                            // Called when ad fails to show.
                            aRewardedInterstitialAd = null;
                            emitSignal("rewarded_interstitial_ad_failed_to_show", adError.getCode());
                            aIsRewardedInterstitialLoaded = false;
                        }

                        @Override
                        public void onAdImpression() {
                            // Called when an impression is recorded for an ad.
                            emitSignal("rewarded_interstitial_ad_recorded_impression");
                        }

                        @Override
                        public void onAdShowedFullScreenContent() {
                            // Called when ad is shown.
                            emitSignal("rewarded_interstitial_ad_opened");
                        }
                    });

                    aRewardedInterstitialAd.show(aActivity, rewardItem -> {
                        // Handle the reward.
                        emitSignal("user_earned_rewarded", rewardItem.getType(), rewardItem.getAmount());
                    });
                }
            }
        });
    }

    /**
     * Generate MD5 for the deviceID
     * @param  s The string to generate de MD5
     * @return String The MD5 generated
     */
    private String md5(final String s)
    {
        try
        {
            // Create MD5 Hash
            MessageDigest digest = MessageDigest.getInstance("MD5");
            digest.update(s.getBytes());
            byte[] messageDigest = digest.digest();

            // Create Hex String
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                StringBuilder h = new StringBuilder(Integer.toHexString(0xFF & b));
                while (h.length() < 2) h.insert(0, "0");
                hexString.append(h);
            }
            return hexString.toString();
        }
        catch(NoSuchAlgorithmException e)
        {
            //Logger.logStackTrace(TAG,e);
        }
        return "";
    }

    /**
     * Get the Device ID for AdMob
     * @return String Device ID
     */
    private String getDeviceId()
    {
        String android_id = Settings.Secure.getString(aActivity.getContentResolver(), Settings.Secure.ANDROID_ID);
        return md5(android_id).toUpperCase(Locale.US);
    }
}
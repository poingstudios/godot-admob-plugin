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

package com.poingstudios.godot.admob.ads.converters

import android.app.Activity
import android.os.Bundle
import com.google.android.libraries.ads.mobile.sdk.common.AdRequest
import com.google.android.libraries.ads.mobile.sdk.banner.AdSize
import com.google.android.libraries.ads.mobile.sdk.banner.BannerAdRequest
import com.google.android.libraries.ads.mobile.sdk.common.AdChoicesPlacement
import com.google.android.libraries.ads.mobile.sdk.common.RequestConfiguration
import com.google.android.libraries.ads.mobile.sdk.common.VideoOptions
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAd
import com.google.android.libraries.ads.mobile.sdk.nativead.NativeAdRequest
import com.google.android.libraries.ads.mobile.sdk.rewarded.ServerSideVerificationOptions
import com.google.android.ump.ConsentDebugSettings
import com.google.android.ump.ConsentRequestParameters
import com.poingstudios.godot.admob.core.AdNetworkExtras
import com.poingstudios.godot.admob.core.utils.Logger
import com.poingstudios.godot.admob.core.utils.getBool
import com.poingstudios.godot.admob.core.utils.getDictionary
import com.poingstudios.godot.admob.core.utils.getInt
import org.godotengine.godot.Dictionary

fun Dictionary.convertToAdSize(activity: Activity): AdSize {
    var width = getInt("width")
    val height = getInt("height")

    if (width == -1 && height == -1) {
        val displayMetrics = activity.resources.displayMetrics
        val deviceWidth = (displayMetrics.widthPixels / displayMetrics.density).toInt()
        return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(activity, deviceWidth)
    }

    if (width <= 0) {
        val displayMetrics = activity.resources.displayMetrics
        width = (displayMetrics.widthPixels / displayMetrics.density).toInt()
    }

    return AdSize(width, height)
}

fun Dictionary.convertToConsentDebugSettings(activity: Activity): ConsentDebugSettings {
    val debugSettingsBuilder = ConsentDebugSettings.Builder(activity)

    val debugGeography =
            getInt("debug_geography", ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_DISABLED)
    debugSettingsBuilder.setDebugGeography(debugGeography)

    val testDeviceHashedIds = this["test_device_hashed_ids"] as? Dictionary
    if (testDeviceHashedIds != null) {
        for (value in testDeviceHashedIds.values) {
            debugSettingsBuilder.addTestDeviceHashedId(value as String)
        }
    }
    return debugSettingsBuilder.build()
}

fun Dictionary.convertToConsentRequestParameters(activity: Activity): ConsentRequestParameters {
    val consentRequestParametersBuilder = ConsentRequestParameters.Builder()
    val tagForUnderAgeOfConsent = this["tag_for_under_age_of_consent"]
    if (tagForUnderAgeOfConsent is Boolean) {
        consentRequestParametersBuilder.setTagForUnderAgeOfConsent(tagForUnderAgeOfConsent)
    }

    val consentDebugSettingsDictionary = this["consent_debug_settings"] as Dictionary?
    val consentDebugSettings =
            consentDebugSettingsDictionary?.convertToConsentDebugSettings(activity)
    if (consentDebugSettings != null) {
        consentRequestParametersBuilder.setConsentDebugSettings(consentDebugSettings)
    }

    return consentRequestParametersBuilder.build()
}

fun Dictionary.convertToAdRequest(keywords: Array<String>, adUnitId: String): AdRequest {
    val adRequestBuilder = AdRequest.Builder(adUnitId)
    val adsExtras = this["extras"] as Dictionary

    val googleRequestAgent = this["google_request_agent"] as String?

    if (!googleRequestAgent.isNullOrEmpty()) {
        Logger.debug(googleRequestAgent)
        adRequestBuilder.setRequestAgent(googleRequestAgent)
    }

    val mediationExtras = this["mediation_extras"] as Dictionary
    for ((key) in mediationExtras) {
        val extra = mediationExtras[key] as Dictionary
        val className = extra["class_name"] as String

        try {
            val objectClass =
                    Class.forName(className).getDeclaredConstructor().newInstance() as
                            AdNetworkExtras
            val extras = extra["extras"] as Dictionary

            val bundle = objectClass.buildExtras(extras.toMap())
            if (bundle != null) {
                adRequestBuilder.putAdSourceExtrasBundle(objectClass.getAdapterClass(), bundle)
            } else {
                Logger.debug("bundle is null: $className")
            }
        } catch (e: Exception) {
            Logger.debug(
                    "Error creating instance of $className: ${e.message}, check if you mark the Mediation when export the plugin"
            )
        }
    }

    for (keyword in keywords) {
        adRequestBuilder.addKeyword(keyword)
    }

    val networkExtrasBundle = Bundle()

    if (adsExtras.isNotEmpty()) {
        for (key in adsExtras.keys) {
            val keyString = key.toString()
            when (val value = adsExtras[key]) {
                is String -> networkExtrasBundle.putString(keyString, value)
                is Number -> networkExtrasBundle.putInt(keyString, value.toInt())
                is Boolean -> networkExtrasBundle.putBoolean(keyString, value)
                else -> networkExtrasBundle.putString(keyString, value.toString())
            }
        }
    }
    adRequestBuilder.setGoogleExtrasBundle(networkExtrasBundle)

    return adRequestBuilder.build()
}

fun Dictionary.convertToBannerAdRequest(keywords: Array<String>, adUnitId: String, adSize: AdSize): BannerAdRequest {
    val adRequestBuilder = BannerAdRequest.Builder(adUnitId, adSize)
    val adsExtras = this["extras"] as Dictionary

    val googleRequestAgent = this["google_request_agent"] as String?

    if (!googleRequestAgent.isNullOrEmpty()) {
        Logger.debug(googleRequestAgent)
        adRequestBuilder.setRequestAgent(googleRequestAgent)
    }

    val mediationExtras = this["mediation_extras"] as Dictionary
    for ((key) in mediationExtras) {
        val extra = mediationExtras[key] as Dictionary
        val className = extra["class_name"] as String

        try {
            val objectClass =
                    Class.forName(className).getDeclaredConstructor().newInstance() as
                            AdNetworkExtras
            val extras = extra["extras"] as Dictionary

            val bundle = objectClass.buildExtras(extras.toMap())
            if (bundle != null) {
                adRequestBuilder.putAdSourceExtrasBundle(objectClass.getAdapterClass(), bundle)
            } else {
                Logger.debug("bundle is null: $className")
            }
        } catch (e: Exception) {
            Logger.debug(
                    "Error creating instance of $className: ${e.message}, check if you mark the Mediation when export the plugin"
            )
        }
    }

    for (keyword in keywords) {
        adRequestBuilder.addKeyword(keyword)
    }

    val networkExtrasBundle = Bundle()

    if (adsExtras.isNotEmpty()) {
        for (key in adsExtras.keys) {
            val keyString = key.toString()
            when (val value = adsExtras[key]) {
                is String -> networkExtrasBundle.putString(keyString, value)
                is Number -> networkExtrasBundle.putInt(keyString, value.toInt())
                is Boolean -> networkExtrasBundle.putBoolean(keyString, value)
                else -> networkExtrasBundle.putString(keyString, value.toString())
            }
        }
    }
    adRequestBuilder.setGoogleExtrasBundle(networkExtrasBundle)

    return adRequestBuilder.build()
}

fun Dictionary.convertToNativeAdRequest(keywords: Array<String>, adUnitId: String, optionsDict: Dictionary): NativeAdRequest {
    val adRequestBuilder = NativeAdRequest.Builder(adUnitId, listOf(NativeAd.NativeAdType.NATIVE))
    val adsExtras = this["extras"] as Dictionary

    val googleRequestAgent = this["google_request_agent"] as String?

    if (!googleRequestAgent.isNullOrEmpty()) {
        Logger.debug(googleRequestAgent)
        adRequestBuilder.setRequestAgent(googleRequestAgent)
    }

    val mediationExtras = this["mediation_extras"] as Dictionary
    for ((key) in mediationExtras) {
        val extra = mediationExtras[key] as Dictionary
        val className = extra["class_name"] as String

        try {
            val objectClass =
                    Class.forName(className).getDeclaredConstructor().newInstance() as
                            AdNetworkExtras
            val extras = extra["extras"] as Dictionary

            val bundle = objectClass.buildExtras(extras.toMap())
            if (bundle != null) {
                adRequestBuilder.putAdSourceExtrasBundle(objectClass.getAdapterClass(), bundle)
            } else {
                Logger.debug("bundle is null: $className")
            }
        } catch (e: Exception) {
            Logger.debug(
                    "Error creating instance of $className: ${e.message}, check if you mark the Mediation when export the plugin"
            )
        }
    }

    for (keyword in keywords) {
        adRequestBuilder.addKeyword(keyword)
    }

    val networkExtrasBundle = Bundle()

    if (adsExtras.isNotEmpty()) {
        for (key in adsExtras.keys) {
            val keyString = key.toString()
            when (val value = adsExtras[key]) {
                is String -> networkExtrasBundle.putString(keyString, value)
                is Number -> networkExtrasBundle.putInt(keyString, value.toInt())
                is Boolean -> networkExtrasBundle.putBoolean(keyString, value)
                else -> networkExtrasBundle.putString(keyString, value.toString())
            }
        }
    }
    adRequestBuilder.setGoogleExtrasBundle(networkExtrasBundle)

    val mediaAspectRatio = optionsDict.getInt("media_aspect_ratio")
    if (mediaAspectRatio > 0) {
        val aspectRatio = when (mediaAspectRatio) {
            1 -> NativeAd.NativeMediaAspectRatio.LANDSCAPE
            2 -> NativeAd.NativeMediaAspectRatio.PORTRAIT
            3 -> NativeAd.NativeMediaAspectRatio.SQUARE
            else -> NativeAd.NativeMediaAspectRatio.ANY
        }
        adRequestBuilder.setMediaAspectRatio(aspectRatio)
    }

    val adChoicesPlacementValue = optionsDict.getInt("ad_choices_placement")
    if (adChoicesPlacementValue > 0) {
        val placement = when (adChoicesPlacementValue) {
            1 -> AdChoicesPlacement.TOP_LEFT
            2 -> AdChoicesPlacement.TOP_RIGHT
            3 -> AdChoicesPlacement.BOTTOM_RIGHT
            4 -> AdChoicesPlacement.BOTTOM_LEFT
            else -> AdChoicesPlacement.TOP_RIGHT
        }
        adRequestBuilder.setAdChoicesPlacement(placement)
    }

    val videoOptionsDict = optionsDict.getDictionary("video_options")
    val videoOptions = VideoOptions.Builder()
            .setStartMuted(videoOptionsDict.getBool("start_muted", true))
            .setCustomControlsRequested(videoOptionsDict.getBool("custom_controls_requested", false))
            .setClickToExpandRequested(videoOptionsDict.getBool("click_to_expand_requested", false))
            .build()
    adRequestBuilder.setVideoOptions(videoOptions)

    return adRequestBuilder.build()
}

//TODO: Remove when iOS gets GAM Next-Gen
@Suppress("DEPRECATION")
fun Dictionary.convertToRequestConfiguration(testDeviceIds: Array<String>): RequestConfiguration {
    val maxAdContentRating = this["max_ad_content_rating"] as? String ?: ""
    val tagForChildDirectedTreatment = getInt("tag_for_child_directed_treatment", -1)
    val tagForUnderAgeOfConsent = getInt("tag_for_under_age_of_consent", -1)

    val coppaEnum = when (tagForChildDirectedTreatment) {
        1 -> RequestConfiguration.TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_TRUE
        0 -> RequestConfiguration.TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_FALSE
        else -> RequestConfiguration.TagForChildDirectedTreatment.TAG_FOR_CHILD_DIRECTED_TREATMENT_UNSPECIFIED
    }

    val gdprEnum = when (tagForUnderAgeOfConsent) {
        1 -> RequestConfiguration.TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_TRUE
        0 -> RequestConfiguration.TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_FALSE
        else -> RequestConfiguration.TagForUnderAgeOfConsent.TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED
    }

    val maxAdContentRatingEnum = when (maxAdContentRating.uppercase()) {
        "G" -> RequestConfiguration.MaxAdContentRating.MAX_AD_CONTENT_RATING_G
        "PG" -> RequestConfiguration.MaxAdContentRating.MAX_AD_CONTENT_RATING_PG
        "T" -> RequestConfiguration.MaxAdContentRating.MAX_AD_CONTENT_RATING_T
        "MA" -> RequestConfiguration.MaxAdContentRating.MAX_AD_CONTENT_RATING_MA
        else -> RequestConfiguration.MaxAdContentRating.MAX_AD_CONTENT_RATING_UNSPECIFIED
    }

    return RequestConfiguration.Builder()
            .setMaxAdContentRating(maxAdContentRatingEnum)
            .setTagForChildDirectedTreatment(coppaEnum)
            .setTagForUnderAgeOfConsent(gdprEnum)
            .setTestDeviceIds(testDeviceIds.toList())
            .build()
}

fun Dictionary.convertToServerSideVerificationOptions(): ServerSideVerificationOptions {
    val customData = this["custom_data"] as String? ?: ""
    val userId = this["user_id"] as String? ?: ""

    return ServerSideVerificationOptions(userId, customData)
}

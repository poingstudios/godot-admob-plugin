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
import com.google.ads.mediation.admob.AdMobAdapter
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.rewarded.ServerSideVerificationOptions
import com.google.android.ump.ConsentDebugSettings
import com.google.android.ump.ConsentRequestParameters
import com.poingstudios.godot.admob.core.AdNetworkExtras
import com.poingstudios.godot.admob.core.utils.Logger
import com.poingstudios.godot.admob.core.utils.getInt
import org.godotengine.godot.Dictionary

fun Dictionary.convertToAdSize(): AdSize {
    val width = getInt("width")
    val height = getInt("height")
    return AdSize(width, height)
}

fun Dictionary.convertToConsentDebugSettings(activity: Activity) : ConsentDebugSettings {
    val debugSettingsBuilder = ConsentDebugSettings.Builder(activity)

    val debugGeography = getInt("debug_geography", ConsentDebugSettings.DebugGeography.DEBUG_GEOGRAPHY_DISABLED)
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
    val consentDebugSettings = consentDebugSettingsDictionary?.convertToConsentDebugSettings(activity)
    if (consentDebugSettings != null){
        consentRequestParametersBuilder.setConsentDebugSettings(consentDebugSettings)
    }

    return consentRequestParametersBuilder.build()
}

fun Dictionary.convertToAdRequest(keywords : Array<String>) : AdRequest{
    val adRequestBuilder = AdRequest.Builder()

    val googleRequestAgent = this["google_request_agent"] as String?

    if (!googleRequestAgent.isNullOrEmpty()){
        Logger.debug(googleRequestAgent)
        adRequestBuilder.setRequestAgent(googleRequestAgent)
    }

    val mediationExtras = this["mediation_extras"] as Dictionary
    for ((key) in mediationExtras) {
        val extra = mediationExtras[key] as Dictionary
        val className = extra["class_name"] as String

        try {
            val objectClass = Class.forName(className).getDeclaredConstructor().newInstance() as AdNetworkExtras
            val extras = extra["extras"] as Dictionary

            val bundle = objectClass.buildExtras(extras.toMap())
            if (bundle != null){
                adRequestBuilder.addNetworkExtrasBundle(objectClass.getAdapterClass(), bundle)
            }
            else{
                Logger.debug("bundle is null: $className")
            }
        } catch (e: Exception) {
            Logger.debug("Error creating instance of $className: ${e.message}, check if you mark the Mediation when export the plugin")
        }
    }
    val extras = this["extras"] as Dictionary

    for ((key) in extras) {
        val networkExtrasBundle = Bundle()
        when (val value = extras[key]) {
            is String -> networkExtrasBundle.putString(key, value)
            is Number -> networkExtrasBundle.putInt(key, value.toInt())
        }
        adRequestBuilder.addNetworkExtrasBundle(AdMobAdapter::class.java, networkExtrasBundle)
    }

    for (keyword in keywords) {
        adRequestBuilder.addKeyword(keyword)
    }

    return adRequestBuilder.build()
}

fun Dictionary.convertToServerSideVerificationOptions() : ServerSideVerificationOptions{
    val options = ServerSideVerificationOptions.Builder()

    val customData = this["custom_data"] as String?
    val userId = this["user_id"] as String?

    if (!customData.isNullOrEmpty()){
        options.setCustomData(customData)
    }
    if (!userId.isNullOrEmpty()){
        options.setUserId(userId)
    }

    return options.build()
}
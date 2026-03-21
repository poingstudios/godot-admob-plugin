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
@file:Suppress("FunctionName")

package com.poingstudios.godot.admob.ads

import android.app.Activity
import android.util.ArraySet
import android.view.View
import android.widget.FrameLayout
import com.google.android.gms.ads.*
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.core.utils.getInt
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("unused") // Instantiated by Android via AndroidManifest (AAR / Godot plugin)
class PoingGodotAdMob(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot) {
    private lateinit var aActivity: Activity
    private lateinit var aGodotLayout : FrameLayout

    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    override fun onMainCreate(activity: Activity?): View {
        aActivity = super.getActivity()!!
        aGodotLayout = FrameLayout(aActivity)
        return aGodotLayout
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo("on_initialization_complete", Dictionary::class.java))
        return signals
    }

    @UsedByGodot
    fun initialize() {
        Thread {
            MobileAds.initialize(aActivity) { initializationStatus ->
                val initializationStatusDictionary = initializationStatus.convertToGodotDictionary()
                emitSignal("on_initialization_complete", initializationStatusDictionary)
            }
        }.start()
    }

    @UsedByGodot
    fun set_request_configuration(requestConfigurationDictionary: Dictionary, testDeviceIds : Array<String>) {
        val maxAdContentRating = requestConfigurationDictionary["max_ad_content_rating"] as String
        val tagForChildDirectedTreatment = requestConfigurationDictionary.getInt("tag_for_child_directed_treatment", RequestConfiguration.TAG_FOR_CHILD_DIRECTED_TREATMENT_UNSPECIFIED)
        val tagForUnderAgeOfConsent = requestConfigurationDictionary.getInt("tag_for_under_age_of_consent", RequestConfiguration.TAG_FOR_UNDER_AGE_OF_CONSENT_UNSPECIFIED)

        val requestConfiguration = RequestConfiguration.Builder()
            .setMaxAdContentRating(maxAdContentRating)
            .setTagForChildDirectedTreatment(tagForChildDirectedTreatment)
            .setTagForUnderAgeOfConsent(tagForUnderAgeOfConsent)
            .setTestDeviceIds(testDeviceIds.toList())
            .build()

        MobileAds.setRequestConfiguration(requestConfiguration)
    }

    @UsedByGodot
    fun get_initialization_status(): Dictionary {
        return MobileAds.getInitializationStatus()!!.convertToGodotDictionary()
    }

    @UsedByGodot
    fun set_app_volume(volume: Float) {
        MobileAds.setAppVolume(clampAppVolume(volume))
    }

    @UsedByGodot
    fun set_app_muted(muted: Boolean) {
        MobileAds.setAppMuted(muted)
    }
}
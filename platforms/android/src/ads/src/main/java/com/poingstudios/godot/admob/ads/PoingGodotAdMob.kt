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
import android.content.pm.PackageManager
import android.preference.PreferenceManager
import androidx.core.content.edit
import com.google.android.libraries.ads.mobile.sdk.MobileAds
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationConfig
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.ads.converters.convertToRequestConfiguration
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
        signals.add(SignalInfo("on_ad_inspector_closed", Dictionary::class.java))
        return signals
    }

    @UsedByGodot
    fun initialize() {
        val appId = runCatching {
            val applicationInfo = aActivity.packageManager.getApplicationInfo(aActivity.packageName, PackageManager.GET_META_DATA)
            applicationInfo.metaData?.getString("com.google.android.gms.ads.APPLICATION_ID")
        }.getOrNull()

        if (appId.isNullOrEmpty()) {
            throw IllegalStateException("AdMob App ID (com.google.android.gms.ads.APPLICATION_ID) is missing or empty in AndroidManifest.xml. Please add it to your project export settings.")
        }

        Thread {
            val config = InitializationConfig.Builder(appId).build()
            MobileAds.initialize(aActivity, config) { initializationStatus ->
                val initializationStatusDictionary = initializationStatus.convertToGodotDictionary()
                emitSignal("on_initialization_complete", initializationStatusDictionary)
            }
        }.start()
    }

    @UsedByGodot
    fun set_request_configuration(requestConfigurationDictionary: Dictionary, testDeviceIds : Array<String>) {
        val requestConfiguration = requestConfigurationDictionary.convertToRequestConfiguration(testDeviceIds)
        MobileAds.setRequestConfiguration(requestConfiguration)
    }

    @UsedByGodot
    fun get_initialization_status(): Dictionary {
        return MobileAds.getInitializationStatus().convertToGodotDictionary()
    }

    @UsedByGodot
    fun set_app_volume(volume: Float) {
        MobileAds.setUserControlledAppVolume(clampAppVolume(volume))
    }

    @UsedByGodot
    fun set_app_muted(muted: Boolean) {
        MobileAds.setUserMutedApp(muted)
    }

    @Suppress("DEPRECATION")
    @UsedByGodot
    fun set_gad_has_consent_for_cookies(enabled: Boolean) {
        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(aActivity)
        sharedPrefs.edit {
            putInt("gad_has_consent_for_cookies", if (enabled) 1 else 0)
        }
    }

    @Suppress("DEPRECATION")
    @UsedByGodot
    fun get_gad_has_consent_for_cookies(): Boolean {
        val sharedPrefs = PreferenceManager.getDefaultSharedPreferences(aActivity)
        return sharedPrefs.getInt("gad_has_consent_for_cookies", 1) == 1
    }

    @UsedByGodot
    fun set_publisher_first_party_id_enabled(enabled: Boolean) {
        MobileAds.putPublisherFirstPartyIdEnabled(enabled)
    }

    @UsedByGodot
    fun get_platform_version(): String {
        return MobileAds.getVersion().toString()
    }

    @UsedByGodot
    fun open_ad_inspector() {
        aActivity.runOnUiThread {
            MobileAds.openAdInspector { adInspectorError ->
                val resultDictionary = Dictionary()
                if (adInspectorError != null) {
                    resultDictionary["code"] = adInspectorError.code
                    resultDictionary["message"] = adInspectorError.message
                    resultDictionary["domain"] = ""
                }
                emitSignal("on_ad_inspector_closed", resultDictionary)
            }
        }
    }
}
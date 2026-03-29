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

package com.poingstudios.godot.admob.ads

import android.app.Activity
import android.util.ArraySet
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.FullScreenContentCallback
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.appopen.AppOpenAd
import com.google.android.gms.ads.appopen.AppOpenAd.AppOpenAdLoadCallback
import com.poingstudios.godot.admob.ads.converters.convertToAdRequest
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.core.utils.Logger
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("PLATFORM_CLASS_MAPPED_TO_KOTLIN", "unused")
class PoingGodotAdMobAppOpenAd(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot) {
    private lateinit var aActivity: Activity
    private val appOpenAds = mutableListOf<AppOpenAd?>()

    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    override fun onMainCreate(activity: Activity?): android.view.View? {
        aActivity = super.getActivity()!!
        return null
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo("on_app_open_ad_failed_to_load", Integer::class.java, Dictionary::class.java))
        signals.add(SignalInfo("on_app_open_ad_loaded", Integer::class.java))

        signals.add(SignalInfo("on_app_open_ad_clicked", Integer::class.java))
        signals.add(SignalInfo("on_app_open_ad_dismissed_full_screen_content", Integer::class.java))
        signals.add(SignalInfo("on_app_open_ad_failed_to_show_full_screen_content", Integer::class.java, Dictionary::class.java))
        signals.add(SignalInfo("on_app_open_ad_impression", Integer::class.java))
        signals.add(SignalInfo("on_app_open_ad_showed_full_screen_content", Integer::class.java))
        signals.add(SignalInfo("on_app_open_ad_paid", Integer::class.java, Dictionary::class.java))
        return signals
    }

    @UsedByGodot
    fun create() : Int {
        val uid = appOpenAds.size
        appOpenAds.add(null)
        return uid
    }

    @UsedByGodot
    fun load(adUnitId : String, adRequestDictionary : Dictionary, keywords : Array<String>, uid: Int){
        aActivity.runOnUiThread {
            Logger.debug("loading app open ad")
            val adRequest = adRequestDictionary.convertToAdRequest(keywords)

            AppOpenAd.load(aActivity, adUnitId, adRequest, object : AppOpenAdLoadCallback() {
                override fun onAdLoaded(ad: AppOpenAd) {
                    appOpenAds[uid] = ad
                    ad.setOnPaidEventListener { adValue ->
                        val adValueDictionary = adValue.convertToGodotDictionary()
                        emitSignal("on_app_open_ad_paid", uid, adValueDictionary)
                    }
                    ad.fullScreenContentCallback = object : FullScreenContentCallback() {
                        override fun onAdDismissedFullScreenContent() {
                            Logger.debug("Ad dismissed fullscreen content.")
                            appOpenAds[uid] = null
                            emitSignal("on_app_open_ad_dismissed_full_screen_content", uid)
                        }

                        override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                            Logger.debug("Ad failed to show fullscreen content.")
                            appOpenAds[uid] = null
                            emitSignal("on_app_open_ad_failed_to_show_full_screen_content", uid, adError.convertToGodotDictionary())
                        }

                        override fun onAdShowedFullScreenContent() {
                            Logger.debug("Ad showed fullscreen content.")
                            emitSignal("on_app_open_ad_showed_full_screen_content", uid)
                        }

                        override fun onAdClicked() {
                            Logger.debug("Ad was clicked.")
                            emitSignal("on_app_open_ad_clicked", uid)
                        }

                        override fun onAdImpression() {
                            Logger.debug("Ad recorded an impression.")
                            emitSignal("on_app_open_ad_impression", uid)
                        }
                    }
                    emitSignal("on_app_open_ad_loaded", uid)
                }

                override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                    Logger.debug("Ad failed to load: ${loadAdError.message}")
                    emitSignal("on_app_open_ad_failed_to_load", uid, loadAdError.convertToGodotDictionary())
                }
            })
        }
    }

    @UsedByGodot
    fun show(uid : Int){
        aActivity.runOnUiThread {
            val ad = appOpenAds[uid]
            ad?.setImmersiveMode(true)
            ad?.show(aActivity)
        }
    }

    @UsedByGodot
    fun get_ad_unit_id(uid: Int) : String {
        return appOpenAds[uid]?.adUnitId ?: ""
    }

    @UsedByGodot
    fun get_response_info(uid: Int) : Dictionary {
        return appOpenAds[uid]?.responseInfo?.convertToGodotDictionary() ?: Dictionary()
    }

    @UsedByGodot
    fun set_placement_id(uid: Int, placementId: Long) {
        appOpenAds[uid]?.placementId = placementId
    }

    @UsedByGodot
    fun get_placement_id(uid: Int) : Long {
        return appOpenAds[uid]?.placementId ?: 0
    }

    @UsedByGodot
    fun destroy(uid : Int){
        Logger.debug("DESTROYING ${javaClass.simpleName}")
        appOpenAds[uid] = null
    }
}

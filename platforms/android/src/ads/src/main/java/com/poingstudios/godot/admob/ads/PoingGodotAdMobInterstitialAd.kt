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
import com.google.android.gms.ads.interstitial.InterstitialAd
import com.google.android.gms.ads.interstitial.InterstitialAdLoadCallback
import com.poingstudios.godot.admob.ads.converters.convertToAdRequest
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.core.utils.Logger
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("PLATFORM_CLASS_MAPPED_TO_KOTLIN", "unused")
// Godot expects Java types, not Kotlin ones (e.g. Integer)
// Instantiated by Android via AndroidManifest (AAR / Godot plugin)
class PoingGodotAdMobInterstitialAd(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot) {
    private lateinit var aActivity: Activity
    private val interstitials = mutableListOf<InterstitialAd?>()
    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    override fun onMainCreate(activity: Activity?): android.view.View? {
        aActivity = super.getActivity()!!
        return null
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo("on_interstitial_ad_failed_to_load", Integer::class.java, Dictionary::class.java))
        signals.add(SignalInfo("on_interstitial_ad_loaded", Integer::class.java))

        signals.add(SignalInfo("on_interstitial_ad_clicked", Integer::class.java))
        signals.add(SignalInfo("on_interstitial_ad_dismissed_full_screen_content", Integer::class.java))
        signals.add(SignalInfo("on_interstitial_ad_failed_to_show_full_screen_content", Integer::class.java, Dictionary::class.java))
        signals.add(SignalInfo("on_interstitial_ad_impression", Integer::class.java))
        signals.add(SignalInfo("on_interstitial_ad_showed_full_screen_content", Integer::class.java))
        signals.add(SignalInfo("on_interstitial_ad_paid", Integer::class.java, Dictionary::class.java))
        return signals
    }

    @UsedByGodot
    fun create() : Int{
        val uid = interstitials.size
        interstitials.add(null)
        return uid
    }

    @UsedByGodot
    fun load(adUnitId : String, adRequestDictionary : Dictionary, keywords : Array<String>, uid: Int){
        aActivity.runOnUiThread{
            Logger.debug("loading interstitial ad")
            val adRequest = adRequestDictionary.convertToAdRequest(keywords)

            InterstitialAd.load(aActivity,
                adUnitId, adRequest, object : InterstitialAdLoadCallback() {
                    override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                        emitSignal("on_interstitial_ad_failed_to_load", uid, loadAdError.convertToGodotDictionary())
                    }
                    override fun onAdLoaded(interstitialAd: InterstitialAd) {
                        interstitials[uid] = interstitialAd
                        interstitialAd.setOnPaidEventListener { adValue ->
                            val adValueDictionary = adValue.convertToGodotDictionary()
                            emitSignal("on_interstitial_ad_paid", uid, adValueDictionary)
                        }
                        interstitialAd.fullScreenContentCallback = object: FullScreenContentCallback() {
                            override fun onAdClicked() {
                                Logger.debug("Ad was clicked.")
                                emitSignal("on_interstitial_ad_clicked", uid)
                            }

                            override fun onAdDismissedFullScreenContent() {
                                Logger.debug("Ad dismissed fullscreen content.")
                                interstitials[uid] = null
                                emitSignal("on_interstitial_ad_dismissed_full_screen_content", uid)
                            }

                            override fun onAdFailedToShowFullScreenContent(adError: AdError) {
                                Logger.debug("Ad failed to show fullscreen content.")
                                interstitials[uid] = null
                                emitSignal("on_interstitial_ad_failed_to_show_full_screen_content", uid, adError.convertToGodotDictionary())
                            }

                            override fun onAdImpression() {
                                Logger.debug("Ad recorded an impression.")
                                emitSignal("on_interstitial_ad_impression", uid)
                            }

                            override fun onAdShowedFullScreenContent() {
                                Logger.debug("Ad showed fullscreen content.")
                                emitSignal("on_interstitial_ad_showed_full_screen_content", uid)
                            }
                        }
                        emitSignal("on_interstitial_ad_loaded", uid)
                    }
                }
            )
        }
    }

    @UsedByGodot
    fun show(uid : Int){
        aActivity.runOnUiThread {
            interstitials[uid]?.show(aActivity)
        }
    }

    @UsedByGodot
    fun destroy(uid : Int){
        Logger.debug("DESTROYING ${javaClass.simpleName}")
        interstitials[uid] = null //just set to null in order to try to clean up memory
    }


    @UsedByGodot
    fun get_response_info(uid: Int) : Dictionary {
        return interstitials[uid]?.responseInfo?.convertToGodotDictionary() ?: Dictionary()
    }

}
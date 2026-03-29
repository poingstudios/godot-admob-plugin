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
import com.poingstudios.godot.admob.ads.adformats.NativeOverlayAd
import com.poingstudios.godot.admob.ads.converters.convertToAdRequest
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("unused")
class PoingGodotAdMobNativeOverlayAd(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot)  {
    private lateinit var aActivity: Activity
    private val nativeAds = mutableListOf<NativeOverlayAd?>()
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
        signals.add(NativeOverlayAd.SignalInfos.onNativeOverlayAdLoaded)
        signals.add(NativeOverlayAd.SignalInfos.onNativeOverlayAdFailedToLoad)
        signals.add(NativeOverlayAd.SignalInfos.onAdClicked)
        signals.add(NativeOverlayAd.SignalInfos.onAdClosed)
        signals.add(NativeOverlayAd.SignalInfos.onAdImpression)
        signals.add(NativeOverlayAd.SignalInfos.onAdOpened)
        signals.add(NativeOverlayAd.SignalInfos.onAdPaid)
        return signals
    }

    @UsedByGodot
    fun create() : Int{
        val uid = nativeAds.size
        nativeAds.add(null)
        return uid
    }

    @UsedByGodot
    fun load(adUnitId: String, adRequestDictionary: Dictionary, keywords: Array<String>, optionsDictionary: Dictionary, uid: Int){
        val adRequest = adRequestDictionary.convertToAdRequest(keywords)
        if (nativeAds[uid] == null) {
            nativeAds[uid] = NativeOverlayAd(uid, aActivity, aGodotLayout, godot, pluginName)
        }
        nativeAds[uid]?.load(adUnitId, adRequest, optionsDictionary)
    }

    @UsedByGodot
    fun render_template(uid: Int, styleDictionary: Dictionary, position: Int, adSizeDictionary: Dictionary?) {
        nativeAds[uid]?.renderTemplate(styleDictionary, position, adSizeDictionary)
    }

    @UsedByGodot
    fun render_template_custom_position(uid: Int, styleDictionary: Dictionary, x: Int, y: Int, adSizeDictionary: Dictionary?) {
        nativeAds[uid]?.renderTemplateCustomPosition(styleDictionary, x, y, adSizeDictionary)
    }

    @UsedByGodot
    fun destroy(uid : Int){
        nativeAds[uid]?.destroy()
        nativeAds[uid] = null
    }

    @UsedByGodot
    fun hide(uid : Int){
        nativeAds[uid]?.hide()
    }

    @UsedByGodot
    fun show(uid : Int){
        nativeAds[uid]?.show()
    }

    @UsedByGodot
    fun update_position(uid: Int, position: Int) {
        nativeAds[uid]?.updatePosition(position)
    }

    @UsedByGodot
    fun update_custom_position(uid: Int, x: Int, y: Int) {
        nativeAds[uid]?.updateCustomPosition(x, y)
    }

    @UsedByGodot
    fun get_width(uid : Int) : Int{
        return nativeAds[uid]?.getWidth() ?: -1
    }

    @UsedByGodot
    fun get_height(uid : Int) : Int {
        return nativeAds[uid]?.getHeight() ?: -1
    }

    @UsedByGodot
    fun get_width_in_pixels(uid : Int) : Int {
        return nativeAds[uid]?.getWidthInPixels() ?: -1
    }

    @UsedByGodot
    fun get_height_in_pixels(uid : Int) : Int {
        return nativeAds[uid]?.getHeightInPixels() ?: -1
    }


    @UsedByGodot
    fun get_response_info(uid: Int) : Dictionary {
        return nativeAds[uid]?.getResponseInfo() ?: Dictionary()
    }

}
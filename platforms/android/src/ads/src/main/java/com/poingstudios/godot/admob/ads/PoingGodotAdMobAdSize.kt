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
import android.util.DisplayMetrics
import android.view.Display
import com.google.android.gms.ads.AdSize
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.core.utils.Logger
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("unused") // Instantiated by Android via AndroidManifest (AAR / Godot plugin)
class PoingGodotAdMobAdSize(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot) {
    private lateinit var aActivity: Activity

    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    override fun onMainCreate(activity: Activity?): android.view.View? {
        aActivity = super.getActivity()!!
        return null
    }

    @UsedByGodot
    fun getCurrentOrientationAnchoredAdaptiveBannerAdSize(width: Int): Dictionary {
        Logger.debug("calling getCurrentOrientationAnchoredAdaptiveBannerAdSize")
        val currentWidth = if (width == AdSize.FULL_WIDTH) getAdWidth() else width
        Logger.debug("currentWidth: $currentWidth")

        val adSize =
                AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(aActivity, currentWidth)
        return adSize.convertToGodotDictionary()
    }

    @UsedByGodot
    fun getPortraitAnchoredAdaptiveBannerAdSize(width: Int): Dictionary {
        Logger.debug("calling getPortraitAnchoredAdaptiveBannerAdSize")
        val currentWidth = if (width == AdSize.FULL_WIDTH) getAdWidth() else width
        Logger.debug("currentWidth: $currentWidth")

        val adSize = AdSize.getPortraitAnchoredAdaptiveBannerAdSize(aActivity, currentWidth)
        return adSize.convertToGodotDictionary()
    }

    @UsedByGodot
    fun getLandscapeAnchoredAdaptiveBannerAdSize(width: Int): Dictionary {
        Logger.debug("calling getLandscapeAnchoredAdaptiveBannerAdSize")
        val currentWidth = if (width == AdSize.FULL_WIDTH) getAdWidth() else width
        Logger.debug("currentWidth: $currentWidth")

        val adSize = AdSize.getLandscapeAnchoredAdaptiveBannerAdSize(aActivity, currentWidth)
        return adSize.convertToGodotDictionary()
    }

    @UsedByGodot
    fun getSmartBannerAdSize(): Dictionary {
        Logger.debug("calling getSmartBannerAdSize")

        return AdSize.SMART_BANNER.convertToGodotDictionary()
    }

    private fun getAdWidth(): Int {
        val display: Display = aActivity.windowManager.defaultDisplay
        val outMetrics = DisplayMetrics()
        display.getMetrics(outMetrics)

        val density = outMetrics.density

        val adWidthPixels = outMetrics.widthPixels.toFloat()

        return (adWidthPixels / density).toInt()
    }
}

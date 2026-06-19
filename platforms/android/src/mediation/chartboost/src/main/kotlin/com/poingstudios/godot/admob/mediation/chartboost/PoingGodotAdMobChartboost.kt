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
package com.poingstudios.godot.admob.mediation.chartboost

import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.UsedByGodot
import org.godotengine.godot.plugin.GodotPlugin
import android.util.Log
import com.chartboost.sdk.Chartboost
import com.chartboost.sdk.privacy.model.GDPR
import com.chartboost.sdk.privacy.model.CCPA
import android.content.Context

@Suppress("unused") // Instantiated by Android via AndroidManifest (AAR / Godot plugin)
class PoingGodotAdMobChartboost(godot: Godot?) : GodotPlugin(godot) {
    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    @UsedByGodot
    fun set_consent(consent: Boolean) {
        val gdprConsent = if (consent) GDPR.GDPR_CONSENT.BEHAVIORAL else GDPR.GDPR_CONSENT.NON_BEHAVIORAL
        val dataUseConsent = GDPR(gdprConsent)
        activity?.applicationContext?.let {
            Chartboost.addDataUseConsent(it, dataUseConsent)
        }
        Log.d("Chartboost", "Chartboost consent set to: $consent")
    }

    @UsedByGodot
    fun set_ccpa_consent(consent: Boolean) {
        val ccpaConsent = if (consent) CCPA.CCPA_CONSENT.OPT_IN_SALE else CCPA.CCPA_CONSENT.OPT_OUT_SALE
        val dataUseConsent = CCPA(ccpaConsent)
        activity?.applicationContext?.let {
            Chartboost.addDataUseConsent(it, dataUseConsent)
        }
        Log.d("Chartboost", "Chartboost CCPA consent set to: $consent")
    }
}
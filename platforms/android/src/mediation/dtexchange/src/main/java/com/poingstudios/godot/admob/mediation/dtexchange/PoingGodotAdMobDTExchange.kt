// MIT License
//
// Copyright (c) 2026-present Poing Studios
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
package com.poingstudios.godot.admob.mediation.dtexchange

import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.UsedByGodot
import org.godotengine.godot.plugin.GodotPlugin
import android.util.Log
import com.fyber.inneractive.sdk.external.InneractiveAdManager

@Suppress("unused") // Instantiated by Android via AndroidManifest (AAR / Godot plugin)
class PoingGodotAdMobDTExchange(godot: Godot?) : GodotPlugin(godot) {
    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    @UsedByGodot
    fun set_gdpr_consent(consent: Boolean) {
        InneractiveAdManager.setGdprConsent(consent)
        Log.d("DTExchange", "DT Exchange GDPR consent set to: $consent")
    }

    @UsedByGodot
    fun set_gdpr_consent_string(consentString: String) {
        InneractiveAdManager.setGdprConsentString(consentString)
        Log.d("DTExchange", "DT Exchange GDPR consent string set")
    }

    @UsedByGodot
    fun set_ccpa_string(ccpaString: String) {
        InneractiveAdManager.setUSPrivacyString(ccpaString)
        Log.d("DTExchange", "DT Exchange US Privacy/CCPA string set")
    }
}

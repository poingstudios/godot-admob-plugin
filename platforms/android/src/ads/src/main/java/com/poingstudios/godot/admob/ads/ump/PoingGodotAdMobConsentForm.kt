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

package com.poingstudios.godot.admob.ads.ump

import android.app.Activity
import com.google.android.ump.ConsentForm
import com.google.android.ump.UserMessagingPlatform
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.core.utils.Logger
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin.emitSignal
import org.godotengine.godot.plugin.SignalInfo

@Suppress("PLATFORM_CLASS_MAPPED_TO_KOTLIN") // Godot expects Java types, not Kotlin ones (e.g. Integer)
class PoingGodotAdMobConsentForm(val uid: Int,
                                 private val consentForm: ConsentForm,
                                 private val activity: Activity,
                                 private val godot: Godot,
                                 private val pluginName: String) {

    object SignalInfos {
        val onConsentFormDismissed = SignalInfo("on_consent_form_dismissed", Integer::class.java, Dictionary::class.java)
    }

    fun show(){
        activity.runOnUiThread {
            consentForm.show(activity)
            {

                Logger.debug("consentStatus: ${UserMessagingPlatform.getConsentInformation(activity).consentStatus}")
                emitSignal(godot, pluginName, SignalInfos.onConsentFormDismissed, uid, it?.convertToGodotDictionary()?: Dictionary())
            }
        }
    }
}

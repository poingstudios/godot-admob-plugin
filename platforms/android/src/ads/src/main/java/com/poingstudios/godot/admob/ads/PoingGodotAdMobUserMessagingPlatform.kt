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
import com.google.android.ump.UserMessagingPlatform
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.ads.ump.PoingGodotAdMobConsentForm
import com.poingstudios.godot.admob.core.utils.Logger
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("PLATFORM_CLASS_MAPPED_TO_KOTLIN", "unused") // Godot expects Java types, not Kotlin ones (e.g. Integer)
class PoingGodotAdMobUserMessagingPlatform(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot){
    private lateinit var aActivity: Activity
    private val consentForms = mutableListOf<PoingGodotAdMobConsentForm?>()

    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    override fun onMainCreate(activity: Activity?): android.view.View? {
        aActivity = super.getActivity()!!
        return null
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo("on_consent_form_load_success_listener", Integer::class.java))
        signals.add(SignalInfo("on_consent_form_load_failure_listener", Dictionary::class.java))
        signals.add(PoingGodotAdMobConsentForm.SignalInfos.onConsentFormDismissed)
        return signals
    }

    @UsedByGodot
    fun load_consent_form(){
        aActivity.runOnUiThread {
            Logger.debug("load_consent_form")
            UserMessagingPlatform.loadConsentForm(
                aActivity,
                {
                    val consentForm = PoingGodotAdMobConsentForm(consentForms.size, it, aActivity, godot, pluginName).apply {
                        consentForms.add(this)
                    }
                    emitSignal("on_consent_form_load_success_listener", consentForm.uid)
                },
                {
                    emitSignal("on_consent_form_load_failure_listener", it.convertToGodotDictionary())
                }
            )
        }
    }

    @UsedByGodot
    fun show(uid : Int){
        consentForms[uid]?.show()
    }
}
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
import com.poingstudios.godot.admob.ads.converters.convertToConsentRequestParameters
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("unused") // Instantiated by Android via AndroidManifest (AAR / Godot plugin)
class PoingGodotAdMobConsentInformation(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot){
    private lateinit var aActivity: Activity
    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    override fun onMainCreate(activity: Activity?): android.view.View? {
        aActivity = super.getActivity()!!
        return null
    }

    override fun getPluginSignals(): MutableSet<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo("on_consent_info_updated_success"))
        signals.add(SignalInfo("on_consent_info_updated_failure", Dictionary::class.java))
        return signals
    }


    @UsedByGodot
    fun get_consent_status() : Int{
        return UserMessagingPlatform.getConsentInformation(aActivity).consentStatus
    }

    @UsedByGodot
    fun get_is_consent_form_available() : Boolean{
        return UserMessagingPlatform.getConsentInformation(aActivity).isConsentFormAvailable
    }

    @UsedByGodot
    fun update(consentRequestParametersDictionary: Dictionary){
        val consentRequestParameters = consentRequestParametersDictionary.convertToConsentRequestParameters(aActivity)

        val consentInformation = UserMessagingPlatform.getConsentInformation(aActivity)

        consentInformation.requestConsentInfoUpdate(
            aActivity,
            consentRequestParameters,
            {
                emitSignal("on_consent_info_updated_success")
            },
            {
                emitSignal("on_consent_info_updated_failure", it.convertToGodotDictionary())
            }
        )
    }

    @UsedByGodot
    fun reset(){
        UserMessagingPlatform.getConsentInformation(aActivity).reset()
    }
}
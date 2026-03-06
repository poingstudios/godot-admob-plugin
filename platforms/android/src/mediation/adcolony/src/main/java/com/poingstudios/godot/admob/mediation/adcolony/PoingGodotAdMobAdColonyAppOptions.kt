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
package com.poingstudios.godot.admob.mediation.adcolony

import com.adcolony.sdk.AdColonyAppOptions
import com.google.ads.mediation.adcolony.AdColonyMediationAdapter
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.UsedByGodot

@Suppress("unused") // Instantiated by Android via reflection in AdRequest
class PoingGodotAdMobAdColonyAppOptions(godot: Godot?) : org.godotengine.godot.plugin.GodotPlugin(godot) {
    private val appOptions: AdColonyAppOptions = AdColonyMediationAdapter.getAppOptions()

    override fun getPluginName(): String {
        return this::class.simpleName.toString()
    }

    @UsedByGodot
    fun set_privacy_framework_required(type : String, required : Boolean){
        appOptions.setPrivacyFrameworkRequired(type, required)
    }
    @UsedByGodot
    fun get_privacy_framework_required(type : String) : Boolean {
        return appOptions.getPrivacyFrameworkRequired(type)
    }
    @UsedByGodot
    fun set_privacy_consent_string(type : String, consentString : String){
        appOptions.setPrivacyConsentString(type, consentString)
    }
    @UsedByGodot
    fun get_privacy_consent_string(type : String) : String {
        return appOptions.getPrivacyConsentString(type)
    }
    @UsedByGodot
    fun set_user_id(userId : String){
        appOptions.userID = userId
    }
    @UsedByGodot
    fun get_user_id() : String{
        return appOptions.userID
    }
    @UsedByGodot
    fun set_test_mode(enabled : Boolean){
        appOptions.testModeEnabled = enabled
    }
    @UsedByGodot
    fun get_test_mode() : Boolean{
        return appOptions.testModeEnabled
    }

}
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
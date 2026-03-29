// MIT License
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

package com.poingstudios.godot.admob.ads.adformats

import android.app.Activity
import android.graphics.Rect
import android.view.Gravity
import android.view.View.OnLayoutChangeListener
import android.widget.FrameLayout
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdLoader
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdOptions
import com.google.android.gms.ads.VideoOptions
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.ads.converters.convertToNativeTemplateStyle
import com.poingstudios.godot.admob.ads.nativetemplates.TemplateView
import com.poingstudios.godot.admob.core.utils.Logger
import com.poingstudios.godot.admob.core.utils.getBool
import com.poingstudios.godot.admob.core.utils.getDictionary
import com.poingstudios.godot.admob.core.utils.getInt
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin.emitSignal
import org.godotengine.godot.plugin.SignalInfo

class NativeOverlayAd(
        uid: Int,
        activity: Activity,
        private val godotLayout: FrameLayout,
        godot: Godot,
        private val pluginName: String
) : AdFormatsBase(uid, activity, godot) {

    private var mNativeAd: NativeAd? = null
    private var mTemplateView: TemplateView? = null
    private var isHidden: Boolean = false
    private var mPosition: Position = Position(null, 0, 0)
    private var mAdSize: com.google.android.gms.ads.AdSize? = null
    private var safeArea: Rect = getSafeArea()

    object SignalInfos {
        val onNativeOverlayAdLoaded = SignalInfo("on_native_overlay_ad_loaded", Integer::class.java)
        val onNativeOverlayAdFailedToLoad =
                SignalInfo(
                        "on_native_overlay_ad_failed_to_load",
                        Integer::class.java,
                        Dictionary::class.java
                )
        val onAdClicked = SignalInfo("on_native_overlay_ad_clicked", Integer::class.java)
        val onAdClosed = SignalInfo("on_native_overlay_ad_closed", Integer::class.java)
        val onAdImpression = SignalInfo("on_native_overlay_ad_impression", Integer::class.java)
        val onAdOpened = SignalInfo("on_native_overlay_ad_opened", Integer::class.java)
        val onAdPaid = SignalInfo("on_native_overlay_ad_paid", Integer::class.java, Dictionary::class.java)
    }

    private val mLayoutChangeListener = OnLayoutChangeListener { _, _, _, _, _, _, _, _, _ ->
        val newSafeArea = getSafeArea()
        if (newSafeArea == safeArea) return@OnLayoutChangeListener
        safeArea = newSafeArea
        if (!isHidden && mTemplateView != null) {
            activity.runOnUiThread { updatePositionLogic() }
        }
    }

    fun load(adUnitId: String, adRequest: AdRequest, optionsDict: Dictionary) {
        activity.runOnUiThread {
            val builder = AdLoader.Builder(activity, adUnitId)

            val optionsBuilder = NativeAdOptions.Builder()
            val mediaAspectRatio = optionsDict.getInt("media_aspect_ratio")
            if (mediaAspectRatio != 0) { // 0 is UNKNOWN
                optionsBuilder.setMediaAspectRatio(mediaAspectRatio)
            }
            val adChoicesPlacement = optionsDict.getInt("ad_choices_placement")
            optionsBuilder.setAdChoicesPlacement(adChoicesPlacement)

            val videoOptionsDict = optionsDict.getDictionary("video_options")
            val videoOptions = VideoOptions.Builder()
                    .setStartMuted(videoOptionsDict.getBool("start_muted", true))
                    .setCustomControlsRequested(videoOptionsDict.getBool("custom_controls_requested", false))
                    .setClickToExpandRequested(videoOptionsDict.getBool("click_to_expand_requested", false))
                    .build()
            optionsBuilder.setVideoOptions(videoOptions)

            builder.withNativeAdOptions(optionsBuilder.build())
            builder.forNativeAd { nativeAd ->
                if (mNativeAd != null) {
                    mNativeAd?.destroy()
                }
                mNativeAd = nativeAd
                nativeAd.setOnPaidEventListener { adValue ->
                    val adValueDictionary = adValue.convertToGodotDictionary()
                    emitSignal(godot, pluginName, SignalInfos.onAdPaid, uid, adValueDictionary)
                }
            }

            builder.withAdListener(
                    object : AdListener() {
                        override fun onAdFailedToLoad(adError: LoadAdError) {
                            emitSignal(
                                    godot,
                                    pluginName,
                                    SignalInfos.onNativeOverlayAdFailedToLoad,
                                    uid,
                                    adError.convertToGodotDictionary()
                            )
                        }

                        override fun onAdClicked() {
                            emitSignal(godot, pluginName, SignalInfos.onAdClicked, uid)
                        }

                        override fun onAdClosed() {
                            emitSignal(godot, pluginName, SignalInfos.onAdClosed, uid)
                        }

                        override fun onAdImpression() {
                            emitSignal(godot, pluginName, SignalInfos.onAdImpression, uid)
                        }

                        override fun onAdOpened() {
                            emitSignal(godot, pluginName, SignalInfos.onAdOpened, uid)
                        }

                        override fun onAdLoaded() {
                            emitSignal(godot, pluginName, SignalInfos.onNativeOverlayAdLoaded, uid)
                        }
                    }
            )

            val adLoader = builder.build()
            adLoader.loadAd(adRequest)
        }
    }

    fun renderTemplate(styleDict: Dictionary, position: Int, adSizeDict: Dictionary?) {
        mPosition = Position(position, 0, 0)
        mAdSize = if (adSizeDict != null && !adSizeDict.isEmpty()) {
            com.google.android.gms.ads.AdSize(adSizeDict.getInt("width"), adSizeDict.getInt("height"))
        } else {
            null
        }
        internalRenderTemplate(styleDict)
    }

    fun renderTemplateCustomPosition(styleDict: Dictionary, x: Int, y: Int, adSizeDict: Dictionary?) {
        mPosition = Position(null, x, y)
        mAdSize = if (adSizeDict != null && !adSizeDict.isEmpty()) {
            com.google.android.gms.ads.AdSize(adSizeDict.getInt("width"), adSizeDict.getInt("height"))
        } else {
            null
        }
        internalRenderTemplate(styleDict)
    }

    private fun internalRenderTemplate(styleDict: Dictionary) {
        activity.runOnUiThread {
            if (mNativeAd == null) return@runOnUiThread

            if (mTemplateView != null) {
                godotLayout.removeView(mTemplateView)
                godotLayout.removeOnLayoutChangeListener(mLayoutChangeListener)
            }

            val templateId = styleDict["template_id"] as? String ?: "medium"
            val layoutResId = if (templateId == "small") {
                activity.resources.getIdentifier("small_template_view_layout", "layout", activity.packageName)
            } else {
                activity.resources.getIdentifier("medium_template_view_layout", "layout", activity.packageName)
            }

            if (layoutResId == 0) {
                Logger.error("Native Template Layout not found. Check if Native Templates are properly integrated.")
                return@runOnUiThread
            }

            mTemplateView = activity.layoutInflater.inflate(layoutResId, null) as TemplateView
            mTemplateView?.styles = styleDict.convertToNativeTemplateStyle()
            mTemplateView?.setNativeAd(mNativeAd)

            godotLayout.addView(mTemplateView)
            godotLayout.addOnLayoutChangeListener(mLayoutChangeListener)
            updatePositionLogic()
        }
    }

    fun hide() {
        activity.runOnUiThread {
            isHidden = true
            mTemplateView?.visibility = android.view.View.GONE
        }
    }

    fun show() {
        activity.runOnUiThread {
            isHidden = false
            mTemplateView?.visibility = android.view.View.VISIBLE
            updatePositionLogic()
        }
    }

    fun destroy() {
        activity.runOnUiThread {
            mTemplateView?.destroyNativeAd()
            godotLayout.removeView(mTemplateView)
            godotLayout.removeOnLayoutChangeListener(mLayoutChangeListener)
            mTemplateView = null
            mNativeAd?.destroy()
            mNativeAd = null
        }
    }

    fun updatePosition(position: Int) {
        mPosition = Position(position, 0, 0)
        activity.runOnUiThread { updatePositionLogic() }
    }

    fun updateCustomPosition(x: Int, y: Int) {
        mPosition = Position(null, x, y)
        activity.runOnUiThread { updatePositionLogic() }
    }

    private fun getGravity(adPosition: Int?): Int {
        val gravity = when (adPosition) {
            AdPosition.TOP.value -> Gravity.TOP or Gravity.CENTER_HORIZONTAL
            AdPosition.BOTTOM.value -> Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL
            AdPosition.LEFT.value -> Gravity.BOTTOM or Gravity.START
            AdPosition.RIGHT.value -> Gravity.BOTTOM or Gravity.END
            AdPosition.TOP_LEFT.value -> Gravity.TOP or Gravity.START
            AdPosition.TOP_RIGHT.value -> Gravity.TOP or Gravity.END
            AdPosition.BOTTOM_LEFT.value -> Gravity.BOTTOM or Gravity.START
            AdPosition.BOTTOM_RIGHT.value -> Gravity.BOTTOM or Gravity.END
            AdPosition.CENTER.value -> Gravity.CENTER_HORIZONTAL or Gravity.CENTER_VERTICAL
            null -> Gravity.TOP or Gravity.START
            else -> throw IllegalArgumentException("Invalid AdPosition: $adPosition")
        }
        return gravity
    }

    private fun updatePositionLogic() {
        val view = mTemplateView ?: return
        val density = activity.resources.displayMetrics.density

        val width = if (mAdSize != null) (mAdSize!!.width * density).toInt() else FrameLayout.LayoutParams.MATCH_PARENT
        val height = if (mAdSize != null) (mAdSize!!.height * density).toInt() else FrameLayout.LayoutParams.WRAP_CONTENT

        val layoutParams = FrameLayout.LayoutParams(width, height)

        layoutParams.gravity = getGravity(mPosition.value)
        val safeArea = getSafeArea()

        val leftInset = safeArea.left
        val topInset = safeArea.top
        val rightInset = activity.window.decorView.width - safeArea.right
        val bottomInset = activity.window.decorView.height - safeArea.bottom

        if (mPosition.value == null) {
            layoutParams.leftMargin = (mPosition.customX * density).toInt()
            layoutParams.topMargin = (mPosition.customY * density).toInt()
            layoutParams.rightMargin = 0
            layoutParams.bottomMargin = 0
        } else {
            layoutParams.bottomMargin = bottomInset
            layoutParams.rightMargin = rightInset
            layoutParams.leftMargin = leftInset
            layoutParams.topMargin = topInset
        }

        view.layoutParams = layoutParams
    }

    fun getWidth() = mTemplateView?.width ?: -1
    fun getHeight() = mTemplateView?.height ?: -1
    fun getWidthInPixels() = getWidth()
    fun getHeightInPixels() = getHeight()

    fun getResponseInfo(): Dictionary {
        return mNativeAd?.responseInfo?.convertToGodotDictionary() ?: Dictionary()
    }
}

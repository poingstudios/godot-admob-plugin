// MIT License

// Copyright (c) 2023-present Poing Studios

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

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
import android.view.ViewGroup
import android.widget.FrameLayout
import com.google.ads.mediation.admob.AdMobAdapter
import com.google.android.gms.ads.AdListener
import com.google.android.gms.ads.AdRequest
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdView
import com.google.android.gms.ads.LoadAdError
import com.poingstudios.godot.admob.ads.converters.convertToAdSize
import com.poingstudios.godot.admob.ads.converters.convertToGodotDictionary
import com.poingstudios.godot.admob.core.utils.Logger
import com.poingstudios.godot.admob.core.utils.getInt
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin.emitSignal
import org.godotengine.godot.plugin.SignalInfo

class Banner(
        uid: Int,
        activity: Activity,
        godotLayout: FrameLayout,
        godot: Godot,
        private val pluginName: String,
        adViewDictionary: Dictionary
) : AdFormatsBase(uid, activity, godot) {
    private var safeArea: Rect = getSafeArea()
    private var mPosition: Position = extractPosition(adViewDictionary)
    private lateinit var mAdView: AdView
    private var mAdSize: AdSize = (adViewDictionary["ad_size"] as Dictionary).convertToAdSize(activity)
    private var isHidden: Boolean = false

    private fun extractPosition(dict: Dictionary): Position {
        val value =
                if (dict.getInt("ad_position") == AdPosition.CUSTOM.value) null
                else dict.getInt("ad_position")
        val customPos = dict["custom_position"] as Dictionary
        return Position(value, customPos.getInt("x"), customPos.getInt("y"))
    }

    private val mLayoutChangeListener = OnLayoutChangeListener { _, _, _, _, _, _, _, _, _ ->
        val newSafeArea = getSafeArea()
        if (newSafeArea == safeArea) {
            return@OnLayoutChangeListener
        }
        safeArea = newSafeArea
        if (!isHidden) { // only update if is not hidden to improve performance
            activity.runOnUiThread { updatePosition() }
        }
    }

    object SignalInfos {
        val onAdClicked = SignalInfo("on_ad_clicked", Integer::class.java)
        val onAdClosed = SignalInfo("on_ad_closed", Integer::class.java)
        val onAdFailedToLoad =
                SignalInfo("on_ad_failed_to_load", Integer::class.java, Dictionary::class.java)
        val onAdImpression = SignalInfo("on_ad_impression", Integer::class.java)
        val onAdLoaded = SignalInfo("on_ad_loaded", Integer::class.java)
        val onAdOpened = SignalInfo("on_ad_opened", Integer::class.java)
        val onAdPaid = SignalInfo("on_ad_view_paid", Integer::class.java, Dictionary::class.java)
    }

    init {
        val adUnitId = adViewDictionary["ad_unit_id"] as String
        activity.runOnUiThread {
            mAdView = AdView(activity)
            mAdView.adUnitId = adUnitId
            mAdView.setAdSize(mAdSize)
            mAdView.adListener =
                    object : AdListener() {
                        override fun onAdClicked() {
                            emitSignal(godot, pluginName, SignalInfos.onAdClicked, uid)
                        }

                        override fun onAdClosed() {
                            emitSignal(godot, pluginName, SignalInfos.onAdClosed, uid)
                        }

                        override fun onAdFailedToLoad(loadAdError: LoadAdError) {
                            emitSignal(
                                    godot,
                                    pluginName,
                                    SignalInfos.onAdFailedToLoad,
                                    uid,
                                    loadAdError.convertToGodotDictionary()
                            )
                        }

                        override fun onAdImpression() {
                            emitSignal(godot, pluginName, SignalInfos.onAdImpression, uid)
                        }

                        override fun onAdLoaded() {
                            emitSignal(godot, pluginName, SignalInfos.onAdLoaded, uid)
                        }

                        override fun onAdOpened() {
                            emitSignal(godot, pluginName, SignalInfos.onAdOpened, uid)
                        }
                    }

            mAdView.setOnPaidEventListener { adValue ->
                val adValueDictionary = adValue.convertToGodotDictionary()
                emitSignal(godot, pluginName, SignalInfos.onAdPaid, uid, adValueDictionary)
            }

            godotLayout.addView(mAdView)
            godotLayout.addOnLayoutChangeListener(mLayoutChangeListener)
            updatePosition()
        }
    }

    private fun getGravity(adPosition: Int?): Int {
        val gravity =
                when (adPosition) {
                    AdPosition.TOP.value -> Gravity.TOP or Gravity.CENTER_HORIZONTAL
                    AdPosition.BOTTOM.value -> Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL
                    AdPosition.LEFT.value -> Gravity.START or Gravity.CENTER_VERTICAL
                    AdPosition.RIGHT.value -> Gravity.END or Gravity.CENTER_VERTICAL
                    AdPosition.TOP_LEFT.value -> Gravity.TOP or Gravity.START
                    AdPosition.TOP_RIGHT.value -> Gravity.TOP or Gravity.END
                    AdPosition.BOTTOM_LEFT.value -> Gravity.BOTTOM or Gravity.START
                    AdPosition.BOTTOM_RIGHT.value -> Gravity.BOTTOM or Gravity.END
                    AdPosition.CENTER.value -> Gravity.CENTER_HORIZONTAL or Gravity.CENTER_VERTICAL
                    else ->
                            Gravity.TOP or
                                    Gravity.START // Default base for custom coordinates (adPosition
                // == null)
                }
        return gravity
    }

    private fun getLayoutParams(): FrameLayout.LayoutParams {
        val layoutParams =
                FrameLayout.LayoutParams(
                        ViewGroup.LayoutParams.WRAP_CONTENT,
                        ViewGroup.LayoutParams.WRAP_CONTENT
                )

        layoutParams.gravity = getGravity(mPosition.value)
        val safeArea = getSafeArea() // Refresh to ensure we have valid bounds

        // Calculate insets from coordinates
        val leftInset = safeArea.left
        val topInset = safeArea.top
        val rightInset = activity.window.decorView.width - safeArea.right
        val bottomInset = activity.window.decorView.height - safeArea.bottom

        if (mPosition.value == null) {
            val density = activity.resources.displayMetrics.density
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

        return layoutParams
    }

    private fun updatePosition() {
        val layoutParams = getLayoutParams()
        mAdView.layoutParams = layoutParams
    }

    fun updatePosition(newPosition: Int) {
        mPosition = Position(newPosition, 0, 0)
        activity.runOnUiThread { updatePosition() }
    }

    fun updateCustomPosition(x: Int, y: Int) {
        mPosition = Position(null, x, y)
        activity.runOnUiThread { updatePosition() }
    }

    fun loadAd(adRequest: AdRequest) {
        activity.runOnUiThread { mAdView.loadAd(adRequest) }
    }
    fun destroy() {
        activity.runOnUiThread {
            (mAdView.parent as? ViewGroup)?.removeView(mAdView)
            mAdView.destroy()
        }
    }

    fun hide() {
        activity.runOnUiThread {
            mAdView.visibility = FrameLayout.GONE
            mAdView.pause()
            isHidden = true
        }
    }

    fun show() {
        activity.runOnUiThread {
            mAdView.visibility = FrameLayout.VISIBLE
            mAdView.resume()
            isHidden = false
            updatePosition()
        }
    }

    fun getWidth(): Int {
        return mAdSize.width
    }

    fun getHeight(): Int {
        return mAdSize.height
    }

    fun getWidthInPixels(): Int {
        return mAdSize.getWidthInPixels(activity)
    }

    fun getHeightInPixels(): Int {
        return mAdSize.getHeightInPixels(activity)
    }

    fun getResponseInfo(): Dictionary {
        return mAdView.responseInfo?.convertToGodotDictionary() ?: Dictionary()
    }

    fun isCollapsible(): Boolean {
        return mAdView.isCollapsible
    }
}

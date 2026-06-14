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

package com.poingstudios.godot.admob.ads.nativetemplates

import android.content.Context
import android.text.TextUtils
import android.util.AttributeSet
import android.util.Log
import android.view.LayoutInflater
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import com.poingstudios.godot.admob.ads.R

class TemplateView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0,
    defStyleRes: Int = 0
) : FrameLayout(context, attrs, defStyleAttr, defStyleRes) {

    private var templateType: Int = 0
    var styles: NativeTemplateStyle? = null
        set(value) {
            field = value
            applyStyles()
        }
    private var nativeAd: NativeAd? = null
    var nativeAdView: NativeAdView? = null
        private set

    private var primaryView: TextView? = null
    private var secondaryView: TextView? = null
    private var ratingBar: RatingBar? = null
    private var tertiaryView: TextView? = null
    private var iconView: ImageView? = null
    private var mediaView: MediaView? = null
    private var callToActionView: Button? = null
    private var backgroundLayout: ConstraintLayout? = null
    private var layoutInflater: LayoutInflater? = null

    init {
        initView(context, attrs)
    }

    private fun initView(context: Context, attributeSet: AttributeSet?) {
        if (attributeSet == null) return

        val typedArray = context.theme.obtainStyledAttributes(attributeSet, R.styleable.TemplateView, 0, 0)
        val templateTypeResource = R.styleable.TemplateView_gnt_template_type
        val templateViewResource = R.layout.gnt_medium_template_view

        try {
            templateType = typedArray.getResourceId(templateTypeResource, templateViewResource)
        } catch (e: RuntimeException) {
            Log.e("TemplateView", "Failed to get template type", e)
            throw e
        } finally {
            typedArray.recycle()
        }

        if (layoutInflater == null) {
            layoutInflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        }
        layoutInflater?.inflate(templateType, this)
    }

    private fun applyStyles() {
        val currentStyles = styles ?: return

        currentStyles.mainBackgroundColor?.let {
            backgroundLayout?.background = it
            primaryView?.background = it
            secondaryView?.background = it
            tertiaryView?.background = it
        }

        currentStyles.primaryTextTypeface?.let { primaryView?.typeface = it }
        currentStyles.secondaryTextTypeface?.let { secondaryView?.typeface = it }
        currentStyles.tertiaryTextTypeface?.let { tertiaryView?.typeface = it }
        currentStyles.callToActionTextTypeface?.let { callToActionView?.typeface = it }

        currentStyles.primaryTextTypefaceColor?.let { primaryView?.setTextColor(it) }
        currentStyles.secondaryTextTypefaceColor?.let { secondaryView?.setTextColor(it) }
        currentStyles.tertiaryTextTypefaceColor?.let { tertiaryView?.setTextColor(it) }
        currentStyles.callToActionTypefaceColor?.let { callToActionView?.setTextColor(it) }

        if (currentStyles.callToActionTextSize > 0) callToActionView?.textSize = currentStyles.callToActionTextSize
        if (currentStyles.primaryTextSize > 0) primaryView?.textSize = currentStyles.primaryTextSize
        if (currentStyles.secondaryTextSize > 0) secondaryView?.textSize = currentStyles.secondaryTextSize
        if (currentStyles.tertiaryTextSize > 0) tertiaryView?.textSize = currentStyles.tertiaryTextSize

        currentStyles.callToActionBackgroundColor?.let { callToActionView?.background = it }
        currentStyles.primaryTextBackgroundColor?.let { primaryView?.background = it }
        currentStyles.secondaryTextBackgroundColor?.let { secondaryView?.background = it }
        currentStyles.tertiaryTextBackgroundColor?.let { tertiaryView?.background = it }

        invalidate()
        requestLayout()
    }

    private fun areAllViewsInitialized(): Boolean {
        return nativeAdView != null && callToActionView != null &&
                primaryView != null && secondaryView != null && iconView != null
    }

    private fun adHasOnlyStore(nativeAd: NativeAd): Boolean {
        val store = nativeAd.store
        val advertiser = nativeAd.advertiser
        return !TextUtils.isEmpty(store) && TextUtils.isEmpty(advertiser)
    }

    fun setNativeAd(nativeAd: NativeAd?) {
        this.nativeAd = nativeAd
        if (nativeAd == null || !areAllViewsInitialized()) return

        val store = nativeAd.store
        val advertiser = nativeAd.advertiser
        val headline = nativeAd.headline
        val body = nativeAd.body
        val cta = nativeAd.callToAction
        val starRating = nativeAd.starRating
        val icon = nativeAd.icon

        nativeAdView?.callToActionView = callToActionView
        nativeAdView?.headlineView = primaryView
        nativeAdView?.mediaView = mediaView
        secondaryView?.visibility = VISIBLE

        var secondaryText = ""
        if (adHasOnlyStore(nativeAd)) {
            nativeAdView?.storeView = secondaryView
            secondaryText = store ?: ""
        } else if (!TextUtils.isEmpty(advertiser)) {
            nativeAdView?.advertiserView = secondaryView
            secondaryText = advertiser ?: ""
        }

        primaryView?.text = headline
        callToActionView?.text = cta

        if (starRating != null && starRating > 0) {
            secondaryView?.visibility = GONE
            ratingBar?.visibility = VISIBLE
            ratingBar?.rating = starRating.toFloat()
            nativeAdView?.starRatingView = ratingBar
        } else {
            secondaryView?.text = secondaryText
            secondaryView?.visibility = VISIBLE
            ratingBar?.visibility = GONE
        }

        if (icon != null) {
            iconView?.visibility = VISIBLE
            iconView?.setImageDrawable(icon.drawable)
            nativeAdView?.iconView = iconView
        } else {
            iconView?.visibility = GONE
        }

        if (tertiaryView != null) {
            tertiaryView?.text = body
            nativeAdView?.bodyView = tertiaryView
        }

        nativeAdView?.setNativeAd(nativeAd)
    }

    fun destroyNativeAd() {
        nativeAd?.destroy()
    }

    override fun onFinishInflate() {
        super.onFinishInflate()
        nativeAdView = findViewById(R.id.native_ad_view)
        primaryView = findViewById(R.id.primary)
        secondaryView = findViewById(R.id.secondary)
        tertiaryView = findViewById(R.id.body)
        ratingBar = findViewById(R.id.rating_bar)
        ratingBar?.isEnabled = false
        callToActionView = findViewById(R.id.cta)
        iconView = findViewById(R.id.ad_icon)
        mediaView = findViewById(R.id.media_view)
        backgroundLayout = findViewById(R.id.ad_background)
    }

    fun pause() {
        // Additional pause logic if necessary
    }

    fun resume() {
        // Additional resume logic if necessary
    }
}

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

import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable

class NativeTemplateStyle private constructor(
    val callToActionTextTypeface: Typeface?,
    val callToActionTextSize: Float,
    val callToActionTypefaceColor: Int?,
    val callToActionBackgroundColor: ColorDrawable?,
    val primaryTextTypeface: Typeface?,
    val primaryTextSize: Float,
    val primaryTextTypefaceColor: Int?,
    val primaryTextBackgroundColor: ColorDrawable?,
    val secondaryTextTypeface: Typeface?,
    val secondaryTextSize: Float,
    val secondaryTextTypefaceColor: Int?,
    val secondaryTextBackgroundColor: ColorDrawable?,
    val tertiaryTextTypeface: Typeface?,
    val tertiaryTextSize: Float,
    val tertiaryTextTypefaceColor: Int?,
    val tertiaryTextBackgroundColor: ColorDrawable?,
    val mainBackgroundColor: ColorDrawable?
) {
    class Builder {
        private var callToActionTextTypeface: Typeface? = null
        private var callToActionTextSize: Float = 0f
        private var callToActionTypefaceColor: Int? = null
        private var callToActionBackgroundColor: ColorDrawable? = null
        private var primaryTextTypeface: Typeface? = null
        private var primaryTextSize: Float = 0f
        private var primaryTextTypefaceColor: Int? = null
        private var primaryTextBackgroundColor: ColorDrawable? = null
        private var secondaryTextTypeface: Typeface? = null
        private var secondaryTextSize: Float = 0f
        private var secondaryTextTypefaceColor: Int? = null
        private var secondaryTextBackgroundColor: ColorDrawable? = null
        private var tertiaryTextTypeface: Typeface? = null
        private var tertiaryTextSize: Float = 0f
        private var tertiaryTextTypefaceColor: Int? = null
        private var tertiaryTextBackgroundColor: ColorDrawable? = null
        private var mainBackgroundColor: ColorDrawable? = null

        fun withCallToActionTextTypeface(typeface: Typeface) = apply { callToActionTextTypeface = typeface }
        fun withCallToActionTextSize(size: Float) = apply { callToActionTextSize = size }
        fun withCallToActionTypefaceColor(color: Int) = apply { callToActionTypefaceColor = color }
        fun withCallToActionBackgroundColor(color: ColorDrawable) = apply { callToActionBackgroundColor = color }
        fun withPrimaryTextTypeface(typeface: Typeface) = apply { primaryTextTypeface = typeface }
        fun withPrimaryTextSize(size: Float) = apply { primaryTextSize = size }
        fun withPrimaryTextTypefaceColor(color: Int) = apply { primaryTextTypefaceColor = color }
        fun withPrimaryTextBackgroundColor(color: ColorDrawable) = apply { primaryTextBackgroundColor = color }
        fun withSecondaryTextTypeface(typeface: Typeface) = apply { secondaryTextTypeface = typeface }
        fun withSecondaryTextSize(size: Float) = apply { secondaryTextSize = size }
        fun withSecondaryTextTypefaceColor(color: Int) = apply { secondaryTextTypefaceColor = color }
        fun withSecondaryTextBackgroundColor(color: ColorDrawable) = apply { secondaryTextBackgroundColor = color }
        fun withTertiaryTextTypeface(typeface: Typeface) = apply { tertiaryTextTypeface = typeface }
        fun withTertiaryTextSize(size: Float) = apply { tertiaryTextSize = size }
        fun withTertiaryTextTypefaceColor(color: Int) = apply { tertiaryTextTypefaceColor = color }
        fun withTertiaryTextBackgroundColor(color: ColorDrawable) = apply { tertiaryTextBackgroundColor = color }
        fun withMainBackgroundColor(color: ColorDrawable) = apply { mainBackgroundColor = color }

        fun build() = NativeTemplateStyle(
            callToActionTextTypeface, callToActionTextSize, callToActionTypefaceColor, callToActionBackgroundColor,
            primaryTextTypeface, primaryTextSize, primaryTextTypefaceColor, primaryTextBackgroundColor,
            secondaryTextTypeface, secondaryTextSize, secondaryTextTypefaceColor, secondaryTextBackgroundColor,
            tertiaryTextTypeface, tertiaryTextSize, tertiaryTextTypefaceColor, tertiaryTextBackgroundColor,
            mainBackgroundColor
        )
    }
}

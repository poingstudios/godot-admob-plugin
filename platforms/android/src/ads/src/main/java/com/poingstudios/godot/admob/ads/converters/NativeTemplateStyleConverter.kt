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
package com.poingstudios.godot.admob.ads.converters

import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable
import com.poingstudios.godot.admob.ads.nativetemplates.NativeTemplateStyle
import org.godotengine.godot.Dictionary

fun Dictionary.convertToNativeTemplateStyle(): NativeTemplateStyle {
    val builder = NativeTemplateStyle.Builder()

    val mainBackgroundColor = this["main_background_color"] as? String ?: ""
    if (mainBackgroundColor.isNotEmpty()) {
        builder.withMainBackgroundColor(mainBackgroundColor.toColorDrawable())
    }

    val applyTextStyle = { textStyleDict: Dictionary?,
                           setBackgroundColor: (ColorDrawable) -> Unit,
                           setTextColor: (Int) -> Unit,
                           setTypeface: (Typeface) -> Unit,
                           setTextSize: (Float) -> Unit ->
        if (textStyleDict != null) {
            val bgColorStr = textStyleDict["background_color"] as? String ?: ""
            if (bgColorStr.isNotEmpty()) setBackgroundColor(bgColorStr.toColorDrawable())

            val textColorStr = textStyleDict["text_color"] as? String ?: ""
            if (textColorStr.isNotEmpty()) setTextColor(textColorStr.toAndroidColor())

            val fontSize = (textStyleDict["font_size"] as? Number)?.toFloat() ?: 0f
            if (fontSize > 0) setTextSize(fontSize)

            val styleInt = (textStyleDict["style"] as? Number)?.toInt() ?: 0
            val typeface = when (styleInt) {
                1 -> Typeface.DEFAULT_BOLD
                2 -> Typeface.defaultFromStyle(Typeface.ITALIC)
                3 -> Typeface.MONOSPACE
                else -> Typeface.DEFAULT
            }
            setTypeface(typeface)
        }
    }

    val primaryText = this["primary_text"] as? Dictionary
    applyTextStyle(primaryText, builder::withPrimaryTextBackgroundColor, builder::withPrimaryTextTypefaceColor, builder::withPrimaryTextTypeface, builder::withPrimaryTextSize)

    val secondaryText = this["secondary_text"] as? Dictionary
    applyTextStyle(secondaryText, builder::withSecondaryTextBackgroundColor, builder::withSecondaryTextTypefaceColor, builder::withSecondaryTextTypeface, builder::withSecondaryTextSize)

    val tertiaryText = this["tertiary_text"] as? Dictionary
    applyTextStyle(tertiaryText, builder::withTertiaryTextBackgroundColor, builder::withTertiaryTextTypefaceColor, builder::withTertiaryTextTypeface, builder::withTertiaryTextSize)

    val callToActionText = this["call_to_action_text"] as? Dictionary
    applyTextStyle(callToActionText, builder::withCallToActionBackgroundColor, builder::withCallToActionTypefaceColor, builder::withCallToActionTextTypeface, builder::withCallToActionTextSize)

    return builder.build()
}

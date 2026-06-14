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

package com.poingstudios.godot.admob.ads.adformats

import android.app.Activity
import android.graphics.Rect
import org.godotengine.godot.Godot

abstract class AdFormatsBase(val uid: Int, val activity: Activity, val godot: Godot) {
    protected fun getSafeArea(): Rect {
        val safeArea = Rect()
        val window = activity.window
        val decorView = window.decorView
        decorView.getWindowVisibleDisplayFrame(safeArea)

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
            val insets = decorView.rootWindowInsets
            if (insets != null) {
                val displayCutout = insets.displayCutout
                if (displayCutout != null) {
                    safeArea.left = kotlin.math.max(safeArea.left, displayCutout.safeInsetLeft)
                    safeArea.top = kotlin.math.max(safeArea.top, displayCutout.safeInsetTop)
                    safeArea.right =
                        kotlin.math.min(safeArea.right, decorView.width - displayCutout.safeInsetRight)
                    safeArea.bottom =
                        kotlin.math.min(safeArea.bottom, decorView.height - displayCutout.safeInsetBottom)
                }
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
                    val systemInsets = insets.getInsets(android.view.WindowInsets.Type.systemBars())
                    safeArea.top = kotlin.math.max(safeArea.top, systemInsets.top)
                    safeArea.bottom =
                        kotlin.math.min(safeArea.bottom, decorView.height - systemInsets.bottom)
                    safeArea.left = kotlin.math.max(safeArea.left, systemInsets.left)
                    safeArea.right = kotlin.math.min(safeArea.right, decorView.width - systemInsets.right)
                }
            }
        }
        return safeArea
    }
}

data class Position(var value: Int?, var customX: Int, var customY: Int)

enum class AdPosition(val value: Int) {
    TOP(0), BOTTOM(1), LEFT(2), RIGHT(3), TOP_LEFT(4), TOP_RIGHT(5), BOTTOM_LEFT(6), BOTTOM_RIGHT(7), CENTER(8), CUSTOM(-1)
}
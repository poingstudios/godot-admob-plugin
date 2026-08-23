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

package com.poingstudios.godot.admob.mediation.vungle

import android.os.Bundle
import com.google.ads.mediation.vungle.VungleConstants
import com.poingstudios.godot.admob.core.AdNetworkExtras
import com.poingstudios.godot.admob.core.utils.Logger
import kotlin.Any
import kotlin.String

abstract class VunglePoingExtrasBuilder : AdNetworkExtras {
    companion object {
        private const val USER_ID_KEY = "USER_ID_KEY"
    }

    override fun buildExtras(extras: Map<String, Any>?): Bundle? {
        val bundle = Bundle()
        val userId = extras?.get(USER_ID_KEY)
        if (userId != null) {
            bundle.putString(VungleConstants.KEY_USER_ID, userId as String)
        }

        Logger.debug("buildExtras of class : ${getAdapterClass()}")
        return bundle
    }
}
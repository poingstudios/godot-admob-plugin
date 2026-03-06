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
import com.poingstudios.godot.admob.core.AdNetworkExtras
import com.poingstudios.godot.admob.core.utils.Logger
import com.vungle.mediation.VungleExtrasBuilder
import kotlin.Any
import kotlin.String

abstract class VunglePoingExtrasBuilder : AdNetworkExtras {
    companion object {
        private const val ALL_PLACEMENTS_KEY = "ALL_PLACEMENTS_KEY"
        private const val USER_ID_KEY = "USER_ID_KEY"
        private const val SOUND_ENABLED_KEY = "SOUND_ENABLED_KEY"
    }

    override fun buildExtras(extras: Map<String, Any>?): Bundle? {
        val placements = extras?.get(ALL_PLACEMENTS_KEY)

        val extrasBuilder = if (placements != null) {
            VungleExtrasBuilder((placements as String).split(",").toTypedArray())
        } else {
            VungleExtrasBuilder(null)
        }

        val soundEnabled = extras?.get(SOUND_ENABLED_KEY)
        if (soundEnabled != null) {
            extrasBuilder.setStartMuted(soundEnabled as Boolean)
        }

        val userId = extras?.get(USER_ID_KEY)
        if (userId != null) {
            extrasBuilder.setUserId(userId as String)
        }

        Logger.debug("buildExtras of class : ${getAdapterClass()}")
        return extrasBuilder.build()
    }
}
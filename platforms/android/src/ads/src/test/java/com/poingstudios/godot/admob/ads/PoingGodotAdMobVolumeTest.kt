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

package com.poingstudios.godot.admob.ads

import org.junit.Assert.assertEquals
import org.junit.Test

/**
 * Unit tests for volume clamping used by set_app_volume.
 * Verifies clampAppVolume clamps to [0.0, 1.0] as required by MobileAds.setAppVolume.
 */
class PoingGodotAdMobVolumeTest {

    @Test
    fun clampAppVolume_withinRange_returnsSame() {
        assertEquals(0.5f, clampAppVolume(0.5f), 0.001f)
        assertEquals(0f, clampAppVolume(0f), 0.001f)
        assertEquals(1f, clampAppVolume(1f), 0.001f)
    }

    @Test
    fun clampAppVolume_negative_clampsToZero() {
        assertEquals(0f, clampAppVolume(-1f), 0.001f)
        assertEquals(0f, clampAppVolume(-0.5f), 0.001f)
        assertEquals(0f, clampAppVolume(Float.NEGATIVE_INFINITY), 0.001f)
    }

    @Test
    fun clampAppVolume_aboveOne_clampsToOne() {
        assertEquals(1f, clampAppVolume(2f), 0.001f)
        assertEquals(1f, clampAppVolume(1.5f), 0.001f)
        assertEquals(1f, clampAppVolume(Float.POSITIVE_INFINITY), 0.001f)
    }

}

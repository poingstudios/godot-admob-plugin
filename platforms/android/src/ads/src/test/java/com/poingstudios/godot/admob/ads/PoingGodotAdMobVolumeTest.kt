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

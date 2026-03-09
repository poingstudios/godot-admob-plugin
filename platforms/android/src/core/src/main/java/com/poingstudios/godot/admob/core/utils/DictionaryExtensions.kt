// MIT License
//
// Copyright (c) 2026-present Poing Studios
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

package com.poingstudios.godot.admob.core.utils

import org.godotengine.godot.Dictionary

fun Dictionary.getInt(key: String, default: Int = 0): Int {
    return (this[key] as? Number)?.toInt() ?: default
}

fun Dictionary.getLong(key: String, default: Long = 0L): Long {
    return (this[key] as? Number)?.toLong() ?: default
}

fun Dictionary.getFloat(key: String, default: Float = 0f): Float {
    return (this[key] as? Number)?.toFloat() ?: default
}

fun Dictionary.getDouble(key: String, default: Double = 0.0): Double {
    return (this[key] as? Number)?.toDouble() ?: default
}

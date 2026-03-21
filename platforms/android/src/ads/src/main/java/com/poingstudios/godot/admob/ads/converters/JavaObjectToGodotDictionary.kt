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

import android.os.Bundle
import com.google.android.gms.ads.AdError
import com.google.android.gms.ads.AdSize
import com.google.android.gms.ads.AdapterResponseInfo
import com.google.android.gms.ads.LoadAdError
import com.google.android.gms.ads.ResponseInfo
import com.google.android.gms.ads.initialization.AdapterStatus
import com.google.android.gms.ads.initialization.InitializationStatus
import com.google.android.gms.ads.rewarded.RewardItem
import com.google.android.ump.FormError
import org.godotengine.godot.Dictionary

fun InitializationStatus.convertToGodotDictionary() : Dictionary {
    val statusMap = adapterStatusMap
    val dictionary = Dictionary()

    for (adapterClass in statusMap.keys) {
        val adapterStatusDictionary = statusMap[adapterClass]?.convertToGodotDictionary()
        dictionary[adapterClass] = adapterStatusDictionary
    }
    return dictionary
}

fun AdapterStatus.convertToGodotDictionary() : Dictionary {
    val dictionary = Dictionary()
    dictionary["latency"] = latency
    dictionary["initializationState"] = initializationState.ordinal
    dictionary["description"] = description

    return dictionary
}

fun AdError.convertToGodotDictionary() : Dictionary {
    val dictionary = Dictionary()
    dictionary["code"] = code
    dictionary["domain"] = domain
    dictionary["message"] = message
    dictionary["cause"] = cause?.convertToGodotDictionary()?: Dictionary()

    return dictionary
}

fun LoadAdError.convertToGodotDictionary() : Dictionary {
    val dictionary = Dictionary()
    dictionary["response_info"] = responseInfo?.convertToGodotDictionary()?: Dictionary()
    dictionary += (this as AdError).convertToGodotDictionary()
    return dictionary
}

fun ResponseInfo.convertToGodotDictionary() : Dictionary {
    val dictionary = Dictionary()
    dictionary["loaded_adapter_response_info"] = loadedAdapterResponseInfo?.convertToGodotDictionary()?: Dictionary()
    dictionary["adapter_responses"] = adapterResponses.convertToGodotDictionary()
    dictionary["response_extras"] = responseExtras.convertToGodotDictionary()
    dictionary["mediation_adapter_class_name"] = mediationAdapterClassName ?: ""
    dictionary["response_id"] = responseId ?: ""

    return dictionary
}

fun List<AdapterResponseInfo>.convertToGodotDictionary() : Dictionary {
    val dictionary = Dictionary()

    for (index in this.indices){
        val value = this[index].convertToGodotDictionary()
        dictionary[index.toString()] = value
    }

    return dictionary
}

fun AdapterResponseInfo.convertToGodotDictionary() : Dictionary {
    val dictionary = Dictionary()
    dictionary["adapter_class_name"] = adapterClassName
    dictionary["ad_source_id"] = adSourceId
    dictionary["ad_source_name"] = adSourceName
    dictionary["ad_source_instance_id"] = adSourceInstanceId
    dictionary["ad_source_instance_name"] = adSourceInstanceName
    dictionary["ad_unit_mapping"] = credentials.convertToGodotDictionary()
    dictionary["ad_error"] = adError?.convertToGodotDictionary()?: Dictionary()
    dictionary["latency_millis"] = latencyMillis

    return dictionary
}

fun Bundle.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()

    for (key in keySet()) {
        dictionary[key] = getString(key) ?: ""
    }

    return dictionary
}

fun AdSize.convertToGodotDictionary() : Dictionary{
    val dictionary = Dictionary()

    dictionary["width"] = width
    dictionary["height"] = height

    return dictionary
}

fun FormError.convertToGodotDictionary() : Dictionary{
    val dictionary = Dictionary()

    dictionary["error_code"] = errorCode
    dictionary["message"] = message

    return dictionary
}

fun RewardItem.convertToGodotDictionary() : Dictionary{
    val dictionary = Dictionary()

    dictionary["amount"] = amount
    dictionary["type"] = type

    return dictionary
}
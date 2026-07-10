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
import com.google.android.libraries.ads.mobile.sdk.banner.AdSize
import com.google.android.libraries.ads.mobile.sdk.common.AdValue
import com.google.android.libraries.ads.mobile.sdk.common.AdSourceResponseInfo
import com.google.android.libraries.ads.mobile.sdk.common.FullScreenContentError
import com.google.android.libraries.ads.mobile.sdk.common.LoadAdError
import com.google.android.libraries.ads.mobile.sdk.common.MediationAdError
import com.google.android.libraries.ads.mobile.sdk.common.ResponseInfo
import com.google.android.libraries.ads.mobile.sdk.initialization.AdapterStatus
import com.google.android.libraries.ads.mobile.sdk.initialization.InitializationStatus
import com.google.android.libraries.ads.mobile.sdk.rewarded.RewardItem
import com.google.android.ump.FormError
import org.godotengine.godot.Dictionary

fun InitializationStatus.convertToGodotDictionary(): Dictionary {
    val statusMap = adapterStatusMap
    val dictionary = Dictionary()

    for (adapterClass in statusMap.keys) {
        val adapterStatusDictionary = statusMap[adapterClass]?.convertToGodotDictionary()
        dictionary[adapterClass] = adapterStatusDictionary
    }
    return dictionary
}

fun AdapterStatus.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()
    dictionary["latency"] = latency
    dictionary["initializationState"] = initializationState.ordinal
    dictionary["description"] = description

    return dictionary
}

fun FullScreenContentError.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()
    val underlying = mediationAdError
    dictionary["code"] = code.ordinal
    dictionary["domain"] = underlying?.domain ?: ""
    dictionary["message"] = message
    dictionary["cause"] = underlying?.convertToGodotDictionary() ?: Dictionary()

    return dictionary
}

fun LoadAdError.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()
    dictionary["code"] = code.ordinal
    dictionary["domain"] = ""
    dictionary["message"] = message
    dictionary["cause"] = Dictionary()
    dictionary["response_info"] = responseInfo?.convertToGodotDictionary() ?: Dictionary()
    return dictionary
}

fun ResponseInfo.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()
    dictionary["loaded_adapter_response_info"] =
            loadedAdSourceResponseInfo?.convertToGodotDictionary() ?: Dictionary()
    dictionary["adapter_responses"] = adSourceResponses.convertToGodotDictionary()
    dictionary["response_extras"] = responseExtras.convertToGodotDictionary()
    dictionary["mediation_adapter_class_name"] = adapterClassName ?: ""
    dictionary["response_id"] = responseId ?: ""

    return dictionary
}

fun List<AdSourceResponseInfo>.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()

    for (index in this.indices) {
        val value = this[index].convertToGodotDictionary()
        dictionary[index.toString()] = value
    }

    return dictionary
}

fun MediationAdError.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()
    dictionary["code"] = code
    dictionary["domain"] = domain
    dictionary["message"] = message
    dictionary["cause"] = Dictionary()
    return dictionary
}

fun AdSourceResponseInfo.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()
    dictionary["adapter_class_name"] = adapterClassName
    dictionary["ad_source_id"] = id
    dictionary["ad_source_name"] = name
    dictionary["ad_source_instance_id"] = instanceId
    dictionary["ad_source_instance_name"] = instanceName
    dictionary["ad_unit_mapping"] = credentials.convertToGodotDictionary()
    dictionary["ad_error"] = adError?.convertToGodotDictionary() ?: Dictionary()
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

fun AdSize.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()

    dictionary["width"] = width
    dictionary["height"] = height

    return dictionary
}

fun FormError.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()

    dictionary["error_code"] = errorCode
    dictionary["message"] = message

    return dictionary
}

fun RewardItem.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()

    dictionary["amount"] = amount
    dictionary["type"] = type

    return dictionary
}

fun AdValue.convertToGodotDictionary(): Dictionary {
    val dictionary = Dictionary()

    dictionary["value_micros"] = valueMicros
    dictionary["currency_code"] = currencyCode
    dictionary["precision_type"] = precisionType.ordinal

    return dictionary
}

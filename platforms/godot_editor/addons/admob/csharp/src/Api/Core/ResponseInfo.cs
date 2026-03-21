// MIT License

// Copyright (c) 2023-present Poing Studios

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

using System.Collections.Generic;
using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class ResponseInfo
    {
        public AdapterResponseInfo LoadedAdapterResponseInfo { get; set; }
        public List<AdapterResponseInfo> AdapterResponses { get; set; }
        public Dictionary ResponseExtras { get; set; }
        public string MediationAdapterClassName { get; set; }
        public string ResponseId { get; set; }

        public ResponseInfo(
            AdapterResponseInfo loadedAdapterResponseInfo,
            List<AdapterResponseInfo> adapterResponses,
            Dictionary responseExtras,
            string mediationAdapterClassName,
            string responseId)
        {
            LoadedAdapterResponseInfo = loadedAdapterResponseInfo;
            AdapterResponses = adapterResponses;
            ResponseExtras = responseExtras;
            MediationAdapterClassName = mediationAdapterClassName;
            ResponseId = responseId;
        }

        public static ResponseInfo Create(Dictionary dictionary)
        {
            if (dictionary == null || dictionary.Count == 0)
                return null;

            var loadedAdapterResponseInfo = AdapterResponseInfo.Create(
                (Dictionary)dictionary["loaded_adapter_response_info"]);
            var adapterResponses = AdapterResponseInfo.CreateAdapterResponses(
                (Dictionary)dictionary["adapter_responses"]);
            var responseExtras = (Dictionary)dictionary["response_extras"];
            string mediationAdapterClassName = (string)dictionary["mediation_adapter_class_name"];
            string responseId = (string)dictionary["response_id"];

            return new ResponseInfo(
                loadedAdapterResponseInfo,
                adapterResponses,
                responseExtras,
                mediationAdapterClassName,
                responseId);
        }
    }
}

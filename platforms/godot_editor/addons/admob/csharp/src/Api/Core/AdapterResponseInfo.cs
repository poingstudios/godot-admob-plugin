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

using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class AdapterResponseInfo
    {
        public string AdapterClassName { get; set; }
        public string AdSourceId { get; set; }
        public string AdSourceName { get; set; }
        public string AdSourceInstanceId { get; set; }
        public string AdSourceInstanceName { get; set; }
        public Dictionary AdUnitMapping { get; set; }
        public AdError AdError { get; set; }
        public int LatencyMillis { get; set; }

        public AdapterResponseInfo(
            string adapterClassName,
            string adSourceId,
            string adSourceName,
            string adSourceInstanceId,
            string adSourceInstanceName,
            Dictionary adUnitMapping,
            AdError adError,
            int latencyMillis)
        {
            AdapterClassName = adapterClassName;
            AdSourceId = adSourceId;
            AdSourceName = adSourceName;
            AdSourceInstanceId = adSourceInstanceId;
            AdSourceInstanceName = adSourceInstanceName;
            AdUnitMapping = adUnitMapping;
            AdError = adError;
            LatencyMillis = latencyMillis;
        }

        public static AdapterResponseInfo Create(Dictionary dictionary)
        {
            if (dictionary == null || dictionary.Count == 0)
                return null;

            string adapterClassName = (string)dictionary["adapter_class_name"];
            string adSourceId = (string)dictionary["ad_source_id"];
            string adSourceName = (string)dictionary["ad_source_name"];
            string adSourceInstanceId = (string)dictionary["ad_source_instance_id"];
            string adSourceInstanceName = (string)dictionary["ad_source_instance_name"];
            var adUnitMapping = (Dictionary)dictionary["ad_unit_mapping"];
            var adError = AdError.Create((Dictionary)dictionary["ad_error"]);
            int latencyMillis = (int)dictionary["latency_millis"];

            return new AdapterResponseInfo(
                adapterClassName,
                adSourceId,
                adSourceName,
                adSourceInstanceId,
                adSourceInstanceName,
                adUnitMapping,
                adError,
                latencyMillis);
        }

        public static System.Collections.Generic.List<AdapterResponseInfo> CreateAdapterResponses(Dictionary dictionary)
        {
            var list = new System.Collections.Generic.List<AdapterResponseInfo>();

            if (dictionary == null)
                return list;

            foreach (var key in dictionary.Keys)
            {
                var itemDict = (Dictionary)dictionary[key];
                list.Add(Create(itemDict));
            }

            return list;
        }
    }
}

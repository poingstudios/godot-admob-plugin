// MIT License
// Copyright (c) 2023-present Poing Studios

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

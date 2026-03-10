// MIT License
// Copyright (c) 2023-present Poing Studios

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

// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class LoadAdError : AdError
    {
        public ResponseInfo ResponseInfo { get; set; }

        public LoadAdError(ResponseInfo responseInfo, int code, string domain, string message, AdError cause)
            : base(code, domain, message, cause)
        {
            ResponseInfo = responseInfo;
        }

        public new static LoadAdError Create(Dictionary loadAdErrorDictionary)
        {
            if (loadAdErrorDictionary == null || loadAdErrorDictionary.Count == 0)
                return null;

            var adError = AdError.Create(loadAdErrorDictionary);
            var responseInfo = ResponseInfo.Create((Dictionary)loadAdErrorDictionary["response_info"]);

            return new LoadAdError(responseInfo, adError.Code, adError.Domain, adError.Message, adError.Cause);
        }
    }
}

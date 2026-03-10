// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class AdError
    {
        public int Code { get; set; }
        public string Domain { get; set; }
        public string Message { get; set; }
        public AdError Cause { get; set; }

        public AdError(int code, string domain, string message, AdError cause)
        {
            Code = code;
            Domain = domain;
            Message = message;
            Cause = cause;
        }

        public static AdError Create(Dictionary adErrorDictionary)
        {
            if (adErrorDictionary == null || adErrorDictionary.Count == 0)
                return null;

            int code = (int)adErrorDictionary["code"];
            string domain = (string)adErrorDictionary["domain"];
            string message = (string)adErrorDictionary["message"];
            var cause = Create((Dictionary)adErrorDictionary["cause"]);

            return new AdError(code, domain, message, cause);
        }
    }
}

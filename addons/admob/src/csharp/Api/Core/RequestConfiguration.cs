// MIT License
// Copyright (c) 2023-present Poing Studios

using System.Collections.Generic;
using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class RequestConfiguration
    {
        public const string DeviceIdEmulator = "B3EEABB8EE11C2BE770B684D95219ECB";

        public enum TagForChildDirectedTreatment
        {
            Unspecified = -1,
            False = 0,
            True = 1
        }

        public enum TagForUnderAgeOfConsent
        {
            Unspecified = -1,
            False = 0,
            True = 1
        }

        public const string MaxAdContentRatingUnspecified = "";
        public const string MaxAdContentRatingG = "G";
        public const string MaxAdContentRatingPG = "PG";
        public const string MaxAdContentRatingT = "T";
        public const string MaxAdContentRatingMA = "MA";

        public string MaxAdContentRating { get; set; } = MaxAdContentRatingUnspecified;
        public TagForChildDirectedTreatment ChildDirectedTreatment { get; set; } = TagForChildDirectedTreatment.Unspecified;
        public TagForUnderAgeOfConsent UnderAgeOfConsent { get; set; } = TagForUnderAgeOfConsent.Unspecified;
        public List<string> TestDeviceIds { get; set; } = new List<string>();

        public Dictionary ConvertToDictionary()
        {
            return new Dictionary
            {
                { "max_ad_content_rating", MaxAdContentRating },
                { "tag_for_child_directed_treatment", (int)ChildDirectedTreatment },
                { "tag_for_under_age_of_consent", (int)UnderAgeOfConsent }
            };
        }
    }
}

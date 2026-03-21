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

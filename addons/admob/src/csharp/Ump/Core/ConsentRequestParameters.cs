// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot.Collections;

namespace PoingStudios.AdMob.Ump.Core
{
    public class ConsentRequestParameters
    {
        public bool TagForUnderAgeOfConsent { get; set; }
        public ConsentDebugSettings ConsentDebugSettings { get; set; }

        public Dictionary ConvertToDictionary()
        {
            return new Dictionary
            {
                { "tag_for_under_age_of_consent", TagForUnderAgeOfConsent },
                { "consent_debug_settings", ConsentDebugSettings?.ConvertToDictionary() }
            };
        }
    }
}

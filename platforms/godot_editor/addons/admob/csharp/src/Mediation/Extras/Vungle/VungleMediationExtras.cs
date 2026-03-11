// MIT License
// Copyright (c) 2023-present Poing Studios

using System.Collections.Generic;

namespace PoingStudios.AdMob.Mediation.Extras.Vungle
{
    public class VungleMediationExtras : MediationExtras
    {
        private const string AllPlacementsKey = "ALL_PLACEMENTS_KEY";
        private const string UserIdKey = "USER_ID_KEY";
        private const string SoundEnabledKey = "SOUND_ENABLED_KEY";

        public List<string> AllPlacements
        {
            set => Extras[AllPlacementsKey] = string.Join(",", value);
        }

        public string UserId
        {
            set => Extras[UserIdKey] = value;
        }

        public bool SoundEnabled
        {
            set => Extras[SoundEnabledKey] = value;
        }

        protected override string GetAndroidMediationExtraClassName()
        {
            // Base class — subclasses provide platform-specific class names
            return "";
        }

        protected override string GetIosMediationExtraClassName()
        {
            return "VunglePoingExtrasBuilder";
        }
    }
}

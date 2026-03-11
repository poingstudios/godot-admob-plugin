// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Mediation.Extras.Vungle
{
    public class Vungle : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobVungle");

        public enum Consent
        {
            OptedIn = 0,
            OptedOut = 1
        }

        public static void UpdateConsentStatus(Consent consent, string consentMessageVersion)
        {
            _plugin?.Call("update_consent_status", (int)consent, consentMessageVersion);
        }

        public static void UpdateCcpaStatus(Consent consent)
        {
            _plugin?.Call("update_ccpa_status", (int)consent);
        }
    }
}

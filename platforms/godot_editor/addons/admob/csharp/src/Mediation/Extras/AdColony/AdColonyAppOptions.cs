// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Mediation.Extras.AdColony
{
    public class AdColonyAppOptions : MobileSingletonPlugin
    {
        public const string Ccpa = "CCPA";
        public const string Gdpr = "GDPR";

        private const string PluginName = "PoingGodotAdMobAdColonyAppOptions";
        private readonly GodotObject _plugin;

        public AdColonyAppOptions()
        {
            _plugin = GetPlugin(PluginName);
        }

        public void SetPrivacyFrameworkRequired(string type, bool required)
        {
            _plugin?.Call("set_privacy_framework_required", type, required);
        }

        public bool GetPrivacyFrameworkRequired(string type)
        {
            if (_plugin != null)
                return (bool)_plugin.Call("get_privacy_framework_required", type);
            return false;
        }

        public void SetPrivacyConsentString(string type, string consentString)
        {
            _plugin?.Call("set_privacy_consent_string", type, consentString);
        }

        public string GetPrivacyConsentString(string type)
        {
            if (_plugin != null)
                return (string)_plugin.Call("get_privacy_consent_string", type);
            return "";
        }

        public void SetUserId(string userId)
        {
            _plugin?.Call("set_user_id", userId);
        }

        public string GetUserId()
        {
            if (_plugin != null)
                return (string)_plugin.Call("get_user_id");
            return "";
        }

        public void SetTestMode(bool enabled)
        {
            _plugin?.Call("set_test_mode", enabled);
        }

        public bool GetTestMode()
        {
            if (_plugin != null)
                return (bool)_plugin.Call("get_test_mode");
            return false;
        }
    }
}

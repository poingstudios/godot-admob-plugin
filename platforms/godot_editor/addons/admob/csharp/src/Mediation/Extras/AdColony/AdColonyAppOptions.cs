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
            _plugin = GetPlugin(PluginName, false);
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

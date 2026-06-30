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
using Godot.Collections;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
    public class MobileAds : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMob");

        private static OnInitializationCompleteListener _currentListener;
        private static readonly Callable _onInitCompleteCallable =
            Callable.From<Dictionary>(OnInitializationComplete);

        private static AdInspectorClosedListener _currentAdInspectorListener;
        private static readonly Callable _onAdInspectorClosedCallable =
            Callable.From<Dictionary>(OnAdInspectorClosed);

        public static void Initialize(OnInitializationCompleteListener listener = null)
        {
            if (_plugin == null) return;

            _plugin.Call("initialize");

            if (listener != null)
            {
                _currentListener = listener;
                SafeConnect(_plugin, "on_initialization_complete",
                    _onInitCompleteCallable, (uint)GodotObject.ConnectFlags.OneShot);
            }
        }

        public static void SetRequestConfiguration(RequestConfiguration config)
        {
            if (_plugin == null) return;

            _plugin.Call("set_request_configuration",
                config.ConvertToDictionary(),
                new Array<string>(config.TestDeviceIds));
        }

        public static InitializationStatus GetInitializationStatus()
        {
            if (_plugin == null) return null;

            var dict = (Dictionary)_plugin.Call("get_initialization_status");
            return InitializationStatus.Create(dict);
        }

        public static void SetIosAppPauseOnBackground(bool pause)
        {
            if (_plugin != null && OS.GetName() == "iOS")
            {
                _plugin.Call("set_ios_app_pause_on_background", pause);
            }
        }

        public static void SetAppVolume(float volume)
        {
            if (_plugin != null)
            {
                _plugin.Call("set_app_volume", Mathf.Clamp(volume, 0.0f, 1.0f));
            }
        }

        public static void SetAppMuted(bool muted)
        {
            if (_plugin != null)
            {
                _plugin.Call("set_app_muted", muted);
            }
        }

        public static void SetPublisherFirstPartyIDEnabled(bool enabled)
        {
            if (_plugin != null)
            {
                _plugin.Call("set_publisher_first_party_id_enabled", enabled);
            }
        }

        public static void SetGadHasConsentForCookies(bool enabled)
        {
            if (_plugin != null)
            {
                _plugin.Call("set_gad_has_consent_for_cookies", enabled);
            }
        }

        public static bool GetGadHasConsentForCookies()
        {
            if (_plugin == null) return true;

            return (bool)_plugin.Call("get_gad_has_consent_for_cookies");
        }

        public static void DisableSdkCrashReporting()
        {
            if (_plugin != null && OS.GetName() == "iOS")
            {
                _plugin.Call("disable_sdk_crash_reporting");
            }
        }

        public static void OpenAdInspector(AdInspectorClosedListener listener = null)
        {
            if (_plugin == null) return;

            _plugin.Call("open_ad_inspector");

            if (listener != null)
            {
                _currentAdInspectorListener = listener;
                SafeConnect(_plugin, "on_ad_inspector_closed",
                    _onAdInspectorClosedCallable, (uint)GodotObject.ConnectFlags.OneShot);
            }
        }

        public static string GetVersion()
        {
            return PoingStudios.AdMob.Core.PluginVersion.Current;
        }

        public static string GetPlatformVersion()
        {
            if (_plugin == null) return "";

            return (string)_plugin.Call("get_platform_version");
        }

        private static void OnInitializationComplete(Dictionary statusDict)
        {
            var status = InitializationStatus.Create(statusDict);
            Callable.From(() => _currentListener?.OnInitializationComplete?.Invoke(status)).CallDeferred();
        }

        private static void OnAdInspectorClosed(Dictionary errorDict)
        {
            Callable.From(() => _currentAdInspectorListener?.OnAdInspectorClosed?.Invoke(errorDict)).CallDeferred();
        }
    }
}

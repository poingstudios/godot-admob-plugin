// MIT License
// Copyright (c) 2023-present Poing Studios

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

        private static void OnInitializationComplete(Dictionary statusDict)
        {
            var status = InitializationStatus.Create(statusDict);
            Callable.From(() => _currentListener?.OnInitializationComplete?.Invoke(status)).CallDeferred();
        }
    }
}

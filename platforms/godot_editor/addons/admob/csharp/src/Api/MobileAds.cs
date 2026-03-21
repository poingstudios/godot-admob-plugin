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

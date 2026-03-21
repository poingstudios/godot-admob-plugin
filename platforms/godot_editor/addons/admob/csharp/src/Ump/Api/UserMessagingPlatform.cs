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

using System;
using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Core;
using PoingStudios.AdMob.Ump.Core;

namespace PoingStudios.AdMob.Ump.Api
{
    public class UserMessagingPlatform : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobUserMessagingPlatform");

        public static ConsentInformation ConsentInformation { get; } = new ConsentInformation();

        private static Action<ConsentForm> _onLoadSuccessCallback;
        private static Action<FormError> _onLoadFailureCallback;

        private static readonly Callable _onLoadSuccessCallable =
            Callable.From<int>(OnConsentFormLoadSuccess);
        private static readonly Callable _onLoadFailureCallable =
            Callable.From<Dictionary>(OnConsentFormLoadFailure);

        public static void LoadConsentForm(
            Action<ConsentForm> onSuccess = null,
            Action<FormError> onFailure = null)
        {
            if (_plugin == null) return;

            _onLoadSuccessCallback = onSuccess ?? ((_) => { });
            _onLoadFailureCallback = onFailure ?? ((_) => { });

            _plugin.Call("load_consent_form");
            SafeConnect(_plugin, "on_consent_form_load_success_listener",
                _onLoadSuccessCallable, (uint)GodotObject.ConnectFlags.OneShot);
            SafeConnect(_plugin, "on_consent_form_load_failure_listener",
                _onLoadFailureCallable, (uint)GodotObject.ConnectFlags.OneShot);
        }

        private static void OnConsentFormLoadSuccess(int uid)
        {
            Callable.From(() => _onLoadSuccessCallback?.Invoke(new ConsentForm(uid))).CallDeferred();
        }

        private static void OnConsentFormLoadFailure(Dictionary errorDict)
        {
            var error = FormError.Create(errorDict);
            Callable.From(() => _onLoadFailureCallback?.Invoke(error)).CallDeferred();
        }
    }
}

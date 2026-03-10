// MIT License
// Copyright (c) 2023-present Poing Studios

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

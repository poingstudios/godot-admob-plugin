// MIT License
// Copyright (c) 2023-present Poing Studios

using System;
using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Core;
using PoingStudios.AdMob.Ump.Core;

namespace PoingStudios.AdMob.Ump.Api
{
    public class ConsentInformation : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobConsentInformation");

        public enum ConsentStatus
        {
            Unknown = 0,
            NotRequired = 1,
            Required = 2,
            Obtained = 3
        }

        private Action _onSuccessCallback;
        private Action<FormError> _onFailureCallback;

        private readonly Callable _onSuccessCallable;
        private readonly Callable _onFailureCallable;

        public ConsentInformation()
        {
            _onSuccessCallable = Callable.From(OnConsentInfoUpdatedSuccess);
            _onFailureCallable = Callable.From<Dictionary>(OnConsentInfoUpdatedFailure);
        }

        public ConsentStatus GetConsentStatus()
        {
            if (_plugin != null)
                return (ConsentStatus)(int)_plugin.Call("get_consent_status");
            return ConsentStatus.Unknown;
        }

        public bool GetIsConsentFormAvailable()
        {
            if (_plugin != null)
                return (bool)_plugin.Call("get_is_consent_form_available");
            return false;
        }

        public void Update(
            ConsentRequestParameters consentRequest,
            Action onSuccess = null,
            Action<FormError> onFailure = null)
        {
            if (_plugin == null) return;

            _onSuccessCallback = onSuccess ?? (() => { });
            _onFailureCallback = onFailure ?? ((_) => { });

            _plugin.Call("update", consentRequest.ConvertToDictionary());

            SafeConnect(_plugin, "on_consent_info_updated_success", _onSuccessCallable);
            SafeConnect(_plugin, "on_consent_info_updated_failure", _onFailureCallable);
        }

        public void Reset()
        {
            _plugin?.Call("reset");
        }

        private void OnConsentInfoUpdatedSuccess()
        {
            Callable.From(() => _onSuccessCallback?.Invoke()).CallDeferred();
        }

        private void OnConsentInfoUpdatedFailure(Dictionary errorDict)
        {
            var error = FormError.Create(errorDict);
            Callable.From(() => _onFailureCallback?.Invoke(error)).CallDeferred();
        }
    }
}

// MIT License
// Copyright (c) 2023-present Poing Studios

using System;
using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Core;
using PoingStudios.AdMob.Ump.Core;

namespace PoingStudios.AdMob.Ump.Api
{
    public class ConsentForm : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobUserMessagingPlatform");

        private readonly int _uid;
        private Action<FormError> _onDismissedCallback;

        private readonly Callable _onDismissedCallable;

        internal ConsentForm(int uid)
        {
            _uid = uid;
            _onDismissedCallable = Callable.From<int, Dictionary>(OnConsentFormDismissed);
        }

        public void Show(Action<FormError> onConsentFormDismissed = null)
        {
            if (_plugin == null) return;

            _onDismissedCallback = onConsentFormDismissed ?? ((_) => { });
            _plugin.Call("show", _uid);
            SafeConnect(_plugin, "on_consent_form_dismissed", _onDismissedCallable);
        }

        private void OnConsentFormDismissed(int uid, Dictionary errorDict)
        {
            if (uid != _uid) return;

            FormError formError = (errorDict != null && errorDict.Count > 0)
                ? FormError.Create(errorDict)
                : null;
            Callable.From(() => _onDismissedCallback?.Invoke(formError)).CallDeferred();
        }
    }
}

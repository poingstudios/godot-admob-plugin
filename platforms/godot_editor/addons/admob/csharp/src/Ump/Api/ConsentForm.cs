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

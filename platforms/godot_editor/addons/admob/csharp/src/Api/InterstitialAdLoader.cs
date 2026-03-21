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

using System.Collections.Generic;
using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
    public class InterstitialAdLoader : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobInterstitialAd");

        // Prevent GC during async load (replaces GdScript reference()/unreference())
        private static readonly HashSet<InterstitialAdLoader> _activeLoaders = new HashSet<InterstitialAdLoader>();

        private InterstitialAdLoadCallback _callback;
        private readonly int _uid;

        private readonly Callable _onLoadedCallable;
        private readonly Callable _onFailedCallable;

        public InterstitialAdLoader()
        {
            _onLoadedCallable = Callable.From<int>(OnLoaded);
            _onFailedCallable = Callable.From<int, Godot.Collections.Dictionary>(OnFailed);

            if (_plugin != null)
            {
                _uid = (int)_plugin.Call("create");
            }
        }

        public void Load(string adUnitId, AdRequest adRequest, InterstitialAdLoadCallback callback = null)
        {
            if (_plugin == null) return;

            _callback = callback ?? new InterstitialAdLoadCallback();
            SafeConnect(_plugin, "on_interstitial_ad_loaded", _onLoadedCallable,
                (uint)GodotObject.ConnectFlags.Deferred);
            SafeConnect(_plugin, "on_interstitial_ad_failed_to_load", _onFailedCallable,
                (uint)GodotObject.ConnectFlags.Deferred);

            _activeLoaders.Add(this);
            _plugin.Call("load", adUnitId, adRequest.ConvertToDictionary(),
                new Array<string>(adRequest.Keywords), _uid);
        }

        private void OnLoaded(int uid)
        {
            if (uid != _uid) return;
            _callback.OnAdLoaded?.Invoke(new InterstitialAd(uid));
            Callable.From(() => _activeLoaders.Remove(this)).CallDeferred();
        }

        private void OnFailed(int uid, Godot.Collections.Dictionary errorDict)
        {
            if (uid != _uid) return;
            _callback.OnAdFailedToLoad?.Invoke(LoadAdError.Create(errorDict));
            Callable.From(() => _activeLoaders.Remove(this)).CallDeferred();
        }
    }
}

// MIT License
// Copyright (c) 2023-present Poing Studios

using System.Collections.Generic;
using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
    public class RewardedAdLoader : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobRewardedAd");

        // Prevent GC during async load
        private static readonly HashSet<RewardedAdLoader> _activeLoaders = new HashSet<RewardedAdLoader>();

        private RewardedAdLoadCallback _callback;
        private readonly int _uid;

        private readonly Callable _onLoadedCallable;
        private readonly Callable _onFailedCallable;

        public RewardedAdLoader()
        {
            _onLoadedCallable = Callable.From<int>(OnLoaded);
            _onFailedCallable = Callable.From<int, Godot.Collections.Dictionary>(OnFailed);

            if (_plugin != null)
            {
                _uid = (int)_plugin.Call("create");
            }
        }

        public void Load(string adUnitId, AdRequest adRequest, RewardedAdLoadCallback callback = null)
        {
            if (_plugin == null) return;

            _callback = callback ?? new RewardedAdLoadCallback();
            SafeConnect(_plugin, "on_rewarded_ad_loaded", _onLoadedCallable,
                (uint)GodotObject.ConnectFlags.Deferred);
            SafeConnect(_plugin, "on_rewarded_ad_failed_to_load", _onFailedCallable,
                (uint)GodotObject.ConnectFlags.Deferred);

            _activeLoaders.Add(this);
            _plugin.Call("load", adUnitId, adRequest.ConvertToDictionary(),
                new Array<string>(adRequest.Keywords), _uid);
        }

        private void OnLoaded(int uid)
        {
            if (uid != _uid) return;
            _callback.OnAdLoaded?.Invoke(new RewardedAd(uid));
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

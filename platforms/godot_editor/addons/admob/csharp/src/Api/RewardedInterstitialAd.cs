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
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
    public class RewardedInterstitialAd : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobRewardedInterstitialAd");

        public FullScreenContentCallback FullScreenContentCallback { get; set; } = new FullScreenContentCallback();
        public Action<AdValue> OnAdPaid { get; set; }

        private readonly int _uid;
        private OnUserEarnedRewardListener _rewardListener;

        private readonly Callable _onClickedCallable;
        private readonly Callable _onDismissedCallable;
        private readonly Callable _onFailedToShowCallable;
        private readonly Callable _onImpressionCallable;
        private readonly Callable _onShowedCallable;
        private readonly Callable _onRewardCallable;
        private readonly Callable _onPaidCallable;

        internal RewardedInterstitialAd(int uid)
        {
            _uid = uid;

            _onClickedCallable = Callable.From<int>(OnClicked);
            _onDismissedCallable = Callable.From<int>(OnDismissed);
            _onFailedToShowCallable = Callable.From<int, Dictionary>(OnFailedToShow);
            _onImpressionCallable = Callable.From<int>(OnImpression);
            _onShowedCallable = Callable.From<int>(OnShowed);
            _onRewardCallable = Callable.From<int, Dictionary>(OnReward);
            _onPaidCallable = Callable.From<int, Dictionary>(OnPaid);

            RegisterCallbacks();
        }

        public void Show(OnUserEarnedRewardListener rewardListener = null)
        {
            if (_plugin == null) return;

            _rewardListener = rewardListener ?? new OnUserEarnedRewardListener();
            _plugin.Call("show", _uid);
            SafeConnect(_plugin, "on_rewarded_interstitial_ad_user_earned_reward", _onRewardCallable);
        }

        public void Destroy()
        {
            _plugin?.Call("destroy", _uid);
        }

        public ResponseInfo GetResponseInfo()
        {
            var responseInfoDictionary = (Dictionary)_plugin.Call("get_response_info", _uid);
            return ResponseInfo.Create(responseInfoDictionary);
        }

        public void SetServerSideVerificationOptions(ServerSideVerificationOptions options)
        {
            _plugin?.Call("set_server_side_verification_options", _uid, options.ConvertToDictionary());
        }

        private void RegisterCallbacks()
        {
            if (_plugin == null) return;
            SafeConnect(_plugin, "on_rewarded_interstitial_ad_clicked", _onClickedCallable);
            SafeConnect(_plugin, "on_rewarded_interstitial_ad_dismissed_full_screen_content", _onDismissedCallable);
            SafeConnect(_plugin, "on_rewarded_interstitial_ad_failed_to_show_full_screen_content", _onFailedToShowCallable);
            SafeConnect(_plugin, "on_rewarded_interstitial_ad_impression", _onImpressionCallable);
            SafeConnect(_plugin, "on_rewarded_interstitial_ad_showed_full_screen_content", _onShowedCallable);
            SafeConnect(_plugin, "on_rewarded_interstitial_ad_paid", _onPaidCallable);
        }

        private void OnReward(int uid, Dictionary rewardDict)
        {
            if (uid != _uid) return;
            var item = RewardedItem.Create(rewardDict);
            Callable.From(() => _rewardListener?.OnUserEarnedReward?.Invoke(item)).CallDeferred();
        }

        private void OnClicked(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => FullScreenContentCallback.OnAdClicked?.Invoke()).CallDeferred();
        }

        private void OnDismissed(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => FullScreenContentCallback.OnAdDismissedFullScreenContent?.Invoke()).CallDeferred();
        }

        private void OnFailedToShow(int uid, Dictionary errorDict)
        {
            if (uid != _uid) return;
            var error = AdError.Create(errorDict);
            Callable.From(() => FullScreenContentCallback.OnAdFailedToShowFullScreenContent?.Invoke(error)).CallDeferred();
        }

        private void OnImpression(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => FullScreenContentCallback.OnAdImpression?.Invoke()).CallDeferred();
        }

        private void OnShowed(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => FullScreenContentCallback.OnAdShowedFullScreenContent?.Invoke()).CallDeferred();
        }

        private void OnPaid(int uid, Dictionary adValueDictionary)
        {
            if (uid != _uid) return;
            var adValue = AdValue.Create(adValueDictionary);
            Callable.From(() => OnAdPaid?.Invoke(adValue)).CallDeferred();
        }
    }
}

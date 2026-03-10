// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
    public class RewardedAd : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobRewardedAd");

        public FullScreenContentCallback FullScreenContentCallback { get; set; } = new FullScreenContentCallback();

        private readonly int _uid;
        private OnUserEarnedRewardListener _rewardListener;

        private readonly Callable _onClickedCallable;
        private readonly Callable _onDismissedCallable;
        private readonly Callable _onFailedToShowCallable;
        private readonly Callable _onImpressionCallable;
        private readonly Callable _onShowedCallable;
        private readonly Callable _onRewardCallable;

        internal RewardedAd(int uid)
        {
            _uid = uid;

            _onClickedCallable = Callable.From<int>(OnClicked);
            _onDismissedCallable = Callable.From<int>(OnDismissed);
            _onFailedToShowCallable = Callable.From<int, Dictionary>(OnFailedToShow);
            _onImpressionCallable = Callable.From<int>(OnImpression);
            _onShowedCallable = Callable.From<int>(OnShowed);
            _onRewardCallable = Callable.From<int, Dictionary>(OnReward);

            RegisterCallbacks();
        }

        public void Show(OnUserEarnedRewardListener rewardListener = null)
        {
            if (_plugin == null) return;

            _rewardListener = rewardListener ?? new OnUserEarnedRewardListener();
            _plugin.Call("show", _uid);
            SafeConnect(_plugin, "on_rewarded_ad_user_earned_reward", _onRewardCallable);
        }

        public void Destroy()
        {
            _plugin?.Call("destroy", _uid);
        }

        public void SetServerSideVerificationOptions(ServerSideVerificationOptions options)
        {
            _plugin?.Call("set_server_side_verification_options", _uid, options.ConvertToDictionary());
        }

        private void RegisterCallbacks()
        {
            if (_plugin == null) return;
            SafeConnect(_plugin, "on_rewarded_ad_clicked", _onClickedCallable);
            SafeConnect(_plugin, "on_rewarded_ad_dismissed_full_screen_content", _onDismissedCallable);
            SafeConnect(_plugin, "on_rewarded_ad_failed_to_show_full_screen_content", _onFailedToShowCallable);
            SafeConnect(_plugin, "on_rewarded_ad_impression", _onImpressionCallable);
            SafeConnect(_plugin, "on_rewarded_ad_showed_full_screen_content", _onShowedCallable);
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
    }
}

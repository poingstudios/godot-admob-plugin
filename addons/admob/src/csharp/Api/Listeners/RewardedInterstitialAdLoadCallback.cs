// MIT License
// Copyright (c) 2023-present Poing Studios

using System;
using PoingStudios.AdMob.Api.Core;

namespace PoingStudios.AdMob.Api.Listeners
{
    public class RewardedInterstitialAdLoadCallback
    {
        public Action<LoadAdError> OnAdFailedToLoad { get; set; } = (_) => { };
        public Action<RewardedInterstitialAd> OnAdLoaded { get; set; } = (_) => { };
    }
}

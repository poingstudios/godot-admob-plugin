// MIT License
// Copyright (c) 2023-present Poing Studios

using System;
using PoingStudios.AdMob.Api.Core;

namespace PoingStudios.AdMob.Api.Listeners
{
    public class AdListener
    {
        public Action OnAdClicked { get; set; } = () => { };
        public Action OnAdClosed { get; set; } = () => { };
        public Action<LoadAdError> OnAdFailedToLoad { get; set; } = (_) => { };
        public Action OnAdImpression { get; set; } = () => { };
        public Action OnAdLoaded { get; set; } = () => { };
        public Action OnAdOpened { get; set; } = () => { };
    }
}

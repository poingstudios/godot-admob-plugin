// MIT License
// Copyright (c) 2023-present Poing Studios

using System;
using PoingStudios.AdMob.Api.Core;

namespace PoingStudios.AdMob.Api.Listeners
{
    public class FullScreenContentCallback
    {
        public Action OnAdClicked { get; set; } = () => { };
        public Action OnAdDismissedFullScreenContent { get; set; } = () => { };
        public Action<AdError> OnAdFailedToShowFullScreenContent { get; set; } = (_) => { };
        public Action OnAdImpression { get; set; } = () => { };
        public Action OnAdShowedFullScreenContent { get; set; } = () => { };
    }
}

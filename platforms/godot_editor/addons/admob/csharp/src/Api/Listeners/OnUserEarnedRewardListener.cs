// MIT License
// Copyright (c) 2023-present Poing Studios

using System;
using PoingStudios.AdMob.Api.Core;

namespace PoingStudios.AdMob.Api.Listeners
{
    public class OnUserEarnedRewardListener
    {
        public Action<RewardedItem> OnUserEarnedReward { get; set; } = (_) => { };
    }
}

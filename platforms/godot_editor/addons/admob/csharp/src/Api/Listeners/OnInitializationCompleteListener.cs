// MIT License
// Copyright (c) 2023-present Poing Studios

using System;

namespace PoingStudios.AdMob.Api.Listeners
{
    public class OnInitializationCompleteListener
    {
        public Action<InitializationStatus> OnInitializationComplete { get; set; } = (_) => { };
    }
}

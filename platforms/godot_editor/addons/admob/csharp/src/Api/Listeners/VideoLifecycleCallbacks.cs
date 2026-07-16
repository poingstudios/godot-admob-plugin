// MIT License
// Copyright (c) 2023-present Poing Studios

using System;

namespace PoingStudios.AdMob.Api.Listeners
{
    public class VideoLifecycleCallbacks
    {
        public Action OnVideoStart { get; set; }
        public Action OnVideoPlay { get; set; }
        public Action OnVideoPause { get; set; }
        public Action OnVideoEnd { get; set; }
        public Action<bool> OnVideoMute { get; set; }
    }
}

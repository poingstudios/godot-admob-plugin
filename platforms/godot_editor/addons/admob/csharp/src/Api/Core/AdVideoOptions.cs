// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class AdVideoOptions
    {
        public bool ClickToExpandRequested = false;
        public bool CustomControlsRequested = false;
        public bool StartMuted = true;

        public Dictionary ConvertToDictionary()
        {
            var dict = new Dictionary();
            dict.Add("click_to_expand_requested", ClickToExpandRequested);
            dict.Add("custom_controls_requested", CustomControlsRequested);
            dict.Add("start_muted", StartMuted);
            return dict;
        }
    }
}

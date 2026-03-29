// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class NativeAdOptions
    {
        public NativeMediaAspectRatio MediaAspectRatio = NativeMediaAspectRatio.Unknown;
        public AdChoicesPlacement AdChoicesPlacement = AdChoicesPlacement.TopRight;
        public AdVideoOptions VideoOptions = new AdVideoOptions();

        public Dictionary ConvertToDictionary()
        {
            var dict = new Dictionary();
            dict.Add("media_aspect_ratio", (int)MediaAspectRatio);
            dict.Add("ad_choices_placement", (int)AdChoicesPlacement);
            dict.Add("video_options", VideoOptions.ConvertToDictionary());
            return dict;
        }
    }
}

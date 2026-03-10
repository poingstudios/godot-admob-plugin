// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Mediation.Extras.Meta
{
    public class FBAdSettings : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin =
            OS.GetName() == "iOS" ? GetPlugin("PoingGodotAdMobMetaFBAdSettings") : null;

        public static void SetAdvertiserTrackingEnabled(bool trackingRequired)
        {
            _plugin?.Call("set_advertiser_tracking_enabled", trackingRequired);
        }
    }
}

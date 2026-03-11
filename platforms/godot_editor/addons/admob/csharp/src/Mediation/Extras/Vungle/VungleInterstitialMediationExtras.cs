// MIT License
// Copyright (c) 2023-present Poing Studios

namespace PoingStudios.AdMob.Mediation.Extras.Vungle
{
    public class VungleInterstitialMediationExtras : VungleMediationExtras
    {
        protected override string GetAndroidMediationExtraClassName()
        {
            return "com.poingstudios.godot.admob.mediation.vungle.VungleInterstitialExtrasBuilder";
        }
    }
}

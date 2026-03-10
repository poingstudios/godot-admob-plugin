// MIT License
// Copyright (c) 2023-present Poing Studios

namespace PoingStudios.AdMob.Mediation.Extras.AdColony
{
    public class AdColonyMediationExtras : MediationExtras
    {
        private const string ShowPrePopupKey = "SHOW_PRE_POPUP_KEY";
        private const string ShowPostPopupKey = "SHOW_POST_POPUP_KEY";

        public bool ShowPrePopup
        {
            set => Extras[ShowPrePopupKey] = value;
        }

        public bool ShowPostPopup
        {
            set => Extras[ShowPostPopupKey] = value;
        }

        protected override string GetAndroidMediationExtraClassName()
        {
            return "com.poingstudios.godot.admob.mediation.adcolony.AdColonyExtrasBuilder";
        }

        protected override string GetIosMediationExtraClassName()
        {
            return "AdColonyExtrasBuilder";
        }
    }
}

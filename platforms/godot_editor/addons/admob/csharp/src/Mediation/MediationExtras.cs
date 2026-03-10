// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using Godot.Collections;

namespace PoingStudios.AdMob.Mediation
{
    public abstract class MediationExtras
    {
        public Dictionary Extras { get; set; } = new Dictionary();

        public string GetMediationClassName()
        {
            return OS.GetName() switch
            {
                "Android" => GetAndroidMediationExtraClassName(),
                "iOS" => GetIosMediationExtraClassName(),
                _ => ""
            };
        }

        protected abstract string GetAndroidMediationExtraClassName();
        protected abstract string GetIosMediationExtraClassName();
    }
}

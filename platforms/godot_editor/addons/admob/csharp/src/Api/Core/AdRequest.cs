// MIT License
// Copyright (c) 2023-present Poing Studios

using System.Collections.Generic;
using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Core;
using PoingStudios.AdMob.Mediation;

namespace PoingStudios.AdMob.Api.Core
{
    public class AdRequest
    {
        private const string PluginConfigPath = "res://addons/admob/plugin.cfg";
        private const string FallbackPluginVersion = "v4.0.0";

        public List<string> Keywords { get; set; } = new List<string>();
        public List<MediationExtras> MediationExtrasList { get; set; } = new List<MediationExtras>();
        public Godot.Collections.Dictionary Extras { get; set; } = new Godot.Collections.Dictionary();

        public Godot.Collections.Dictionary ConvertToDictionary()
        {
            return new Godot.Collections.Dictionary
            {
                { "mediation_extras", TransformMediationExtrasToDictionary() },
                { "extras", Extras },
                { "google_request_agent", "Godot-PoingStudios-" + GetFormattedVersion() }
            };
        }

        public string[] GetKeywordsArray()
        {
            return Keywords.ToArray();
        }

        private Godot.Collections.Dictionary TransformMediationExtrasToDictionary()
        {
            var dict = new Godot.Collections.Dictionary();
            for (int i = 0; i < MediationExtrasList.Count; i++)
            {
                var extra = MediationExtrasList[i];
                dict[i] = new Godot.Collections.Dictionary
                {
                    { "class_name", extra.GetMediationClassName() },
                    { "extras", extra.Extras }
                };
            }
            return dict;
        }

        private static string GetFormattedVersion()
        {
            var configFile = new ConfigFile();
            if (configFile.Load(PluginConfigPath) == Error.Ok)
            {
                string version = (string)configFile.GetValue("plugin", "version", FallbackPluginVersion);
                return version.TrimStart('v');
            }
            return FallbackPluginVersion.TrimStart('v');
        }
    }
}

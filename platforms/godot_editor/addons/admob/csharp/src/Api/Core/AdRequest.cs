// MIT License

// Copyright (c) 2023-present Poing Studios

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

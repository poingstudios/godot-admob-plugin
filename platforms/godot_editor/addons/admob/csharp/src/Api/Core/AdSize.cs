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

using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api.Core
{
    public class AdSize : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobAdSize");

        public const int FullWidth = -1;

        public static readonly AdSize Banner = new AdSize(320, 50);
        public static readonly AdSize FullBanner = new AdSize(468, 60);
        public static readonly AdSize LargeBanner = new AdSize(320, 100);
        public static readonly AdSize Leaderboard = new AdSize(728, 90);
        public static readonly AdSize MediumRectangle = new AdSize(300, 250);
        public static readonly AdSize WideSkyscraper = new AdSize(160, 600);

        public int Width { get; set; }
        public int Height { get; set; }

        public AdSize(int width, int height)
        {
            Width = width;
            Height = height;
        }

        public static AdSize SmartBanner
        {
            get
            {
                if (_plugin != null)
                {
                    var dict = (Dictionary)_plugin.Call("getSmartBannerAdSize");
                    return CreateFromDictionary(dict);
                }
                return new AdSize(0, 0);
            }
        }

        public static AdSize GetCurrentOrientationAnchoredAdaptiveBannerAdSize(int width)
        {
            if (_plugin != null)
            {
                var dict = (Dictionary)_plugin.Call("getCurrentOrientationAnchoredAdaptiveBannerAdSize", width);
                return CreateFromDictionary(dict);
            }
            return new AdSize(0, 0);
        }

        public static AdSize GetPortraitAnchoredAdaptiveBannerAdSize(int width)
        {
            if (_plugin != null)
            {
                var dict = (Dictionary)_plugin.Call("getPortraitAnchoredAdaptiveBannerAdSize", width);
                return CreateFromDictionary(dict);
            }
            return new AdSize(0, 0);
        }

        public static AdSize GetLandscapeAnchoredAdaptiveBannerAdSize(int width)
        {
            if (_plugin != null)
            {
                var dict = (Dictionary)_plugin.Call("getLandscapeAnchoredAdaptiveBannerAdSize", width);
                return CreateFromDictionary(dict);
            }
            return new AdSize(0, 0);
        }

        private static AdSize CreateFromDictionary(Dictionary dict)
        {
            int width = (int)dict["width"];
            int height = (int)dict["height"];
            return new AdSize(width, height);
        }
    }
}

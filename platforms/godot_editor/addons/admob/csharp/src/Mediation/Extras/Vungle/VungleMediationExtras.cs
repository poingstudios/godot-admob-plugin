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

namespace PoingStudios.AdMob.Mediation.Extras.Vungle
{
    public class VungleMediationExtras : MediationExtras
    {
        private const string AllPlacementsKey = "ALL_PLACEMENTS_KEY";
        private const string UserIdKey = "USER_ID_KEY";
        private const string SoundEnabledKey = "SOUND_ENABLED_KEY";

        public List<string> AllPlacements
        {
            set => Extras[AllPlacementsKey] = string.Join(",", value);
        }

        public string UserId
        {
            set => Extras[UserIdKey] = value;
        }

        public bool SoundEnabled
        {
            set => Extras[SoundEnabledKey] = value;
        }

        protected override string GetAndroidMediationExtraClassName()
        {
            // Base class — subclasses provide platform-specific class names
            return "";
        }

        protected override string GetIosMediationExtraClassName()
        {
            return "VunglePoingExtrasBuilder";
        }
    }
}

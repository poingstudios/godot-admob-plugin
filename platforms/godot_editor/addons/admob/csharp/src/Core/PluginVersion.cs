// MIT License
// 
// Copyright (c) 2023-present Poing Studios
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

namespace PoingStudios.AdMob.Core
{
    public static class PluginVersion
    {
        private static readonly PluginConfig _config = new PluginConfig();
        private const string FallbackPluginVersion = "v5.0.0";
        private static string _cachedVersion = "";

        public static string Current
        {
            get
            {
                if (string.IsNullOrEmpty(_cachedVersion))
                {
                    string version = _config.GetValue("plugin", "version", FallbackPluginVersion);
                    _cachedVersion = "v" + version.TrimStart('v');
                }
                return _cachedVersion;
            }
        }

        public static string Formatted => Current.TrimStart('v');
    }
}

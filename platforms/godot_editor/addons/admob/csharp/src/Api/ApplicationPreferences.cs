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
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
    public class ApplicationPreferences : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMob");

        public static void SetInt(string key, int value)
        {
            if (_plugin != null)
            {
                _plugin.Call("set_app_preference_int", key, value);
            }
        }

        public static int GetInt(string key, int defaultValue = 0)
        {
            if (_plugin != null)
            {
                return (int)_plugin.Call("get_app_preference_int", key, defaultValue);
            }
            return defaultValue;
        }

        public static void SetString(string key, string value)
        {
            if (_plugin != null)
            {
                _plugin.Call("set_app_preference_string", key, value);
            }
        }

        public static string GetString(string key, string defaultValue = "")
        {
            if (_plugin != null)
            {
                return (string)_plugin.Call("get_app_preference_string", key, defaultValue);
            }
            return defaultValue;
        }

        public static void SetBoolean(string key, bool value)
        {
            if (_plugin != null)
            {
                _plugin.Call("set_app_preference_boolean", key, value);
            }
        }

        public static bool GetBoolean(string key, bool defaultValue = false)
        {
            if (_plugin != null)
            {
                return (bool)_plugin.Call("get_app_preference_boolean", key, defaultValue);
            }
            return defaultValue;
        }
    }
}

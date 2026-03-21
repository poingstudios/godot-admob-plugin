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
using Godot.Collections;

namespace PoingStudios.AdMob.Ump.Core
{
    public class ConsentDebugSettings
    {
        public DebugGeography DebugGeography { get; set; } = DebugGeography.Disabled;
        public List<string> TestDeviceHashedIds { get; set; } = new List<string>();

        public Dictionary ConvertToDictionary()
        {
            return new Dictionary
            {
                { "debug_geography", (int)DebugGeography },
                { "test_device_hashed_ids", TransformTestDeviceHashedIds() }
            };
        }

        private Dictionary TransformTestDeviceHashedIds()
        {
            var dict = new Dictionary();
            for (int i = 0; i < TestDeviceHashedIds.Count; i++)
            {
                dict[i] = TestDeviceHashedIds[i];
            }
            return dict;
        }
    }
}

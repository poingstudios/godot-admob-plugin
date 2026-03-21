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
using PoingStudios.AdMob.Api.Core;

namespace PoingStudios.AdMob.Api
{
    public class InitializationStatus
    {
        public System.Collections.Generic.Dictionary<string, AdapterStatus> AdapterStatusMap { get; private set; }
            = new System.Collections.Generic.Dictionary<string, AdapterStatus>();

        public static InitializationStatus Create(Dictionary dictionary)
        {
            var status = new InitializationStatus();

            foreach (var key in dictionary.Keys)
            {
                string adapterKey = (string)key;
                var adapterDict = (Dictionary)dictionary[key];

                int latency = (int)adapterDict["latency"];
                var initState = (AdapterStatus.InitializationState)(int)adapterDict["initializationState"];
                string description = (string)adapterDict["description"];

                var adapterStatus = new AdapterStatus(latency, initState, description);
                status.AdapterStatusMap[adapterKey] = adapterStatus;
            }

            return status;
        }
    }
}

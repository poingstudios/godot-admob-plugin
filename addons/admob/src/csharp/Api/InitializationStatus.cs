// MIT License
// Copyright (c) 2023-present Poing Studios

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

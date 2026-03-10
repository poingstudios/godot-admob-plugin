// MIT License
// Copyright (c) 2023-present Poing Studios

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

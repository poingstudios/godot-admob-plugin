// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class ServerSideVerificationOptions
    {
        public string CustomData { get; set; } = "";
        public string UserId { get; set; } = "";

        public Dictionary ConvertToDictionary()
        {
            return new Dictionary
            {
                { "custom_data", CustomData },
                { "user_id", UserId }
            };
        }
    }
}

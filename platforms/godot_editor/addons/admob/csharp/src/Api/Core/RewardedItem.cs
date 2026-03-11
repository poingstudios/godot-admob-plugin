// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class RewardedItem
    {
        public int Amount { get; set; }
        public string Type { get; set; }

        public RewardedItem(int amount, string type)
        {
            Amount = amount;
            Type = type;
        }

        public static RewardedItem Create(Dictionary dictionary)
        {
            if (dictionary == null || dictionary.Count == 0)
                return null;

            int amount = (int)dictionary["amount"];
            string type = (string)dictionary["type"];

            return new RewardedItem(amount, type);
        }
    }
}

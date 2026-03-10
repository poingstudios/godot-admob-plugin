// MIT License
// Copyright (c) 2023-present Poing Studios

namespace PoingStudios.AdMob.Api.Core
{
    public class AdapterStatus
    {
        public enum InitializationState
        {
            NotReady = 0,
            Ready = 1
        }

        public int Latency { get; set; }
        public InitializationState State { get; set; }
        public string Description { get; set; }

        public AdapterStatus(int latency, InitializationState state, string description)
        {
            Latency = latency;
            State = state;
            Description = description;
        }
    }
}

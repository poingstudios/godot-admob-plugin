// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;

namespace PoingStudios.AdMob.Sample
{
	public interface ISampleLogger
	{
		void LogMessage(string message);
	}

	public static class SampleRegistry
	{
		public static ISampleLogger Logger { get; set; }
		public static SafeArea SafeArea { get; set; }
	}
}

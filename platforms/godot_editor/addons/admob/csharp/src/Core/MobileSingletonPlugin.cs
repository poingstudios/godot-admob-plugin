// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;

namespace PoingStudios.AdMob.Core
{
	public class MobileSingletonPlugin
	{
		protected static GodotObject GetPlugin(string pluginName)
		{
			if (Engine.HasSingleton(pluginName))
			{
				return Engine.GetSingleton(pluginName);
			}

			string os = OS.GetName();
			if (os == "Android" || os == "iOS")
			{
				GD.PrintErr($"{pluginName} not found, make sure you marked all 'PoingAdMob' plugins on export tab");
			}

			return null;
		}

		protected static void SafeConnect(GodotObject plugin, string signalName, Callable callable, uint flags = 0)
		{
			if (plugin != null && !plugin.IsConnected(signalName, callable))
			{
				plugin.Connect(signalName, callable, flags);
			}
		}
	}
}

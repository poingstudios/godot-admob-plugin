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

namespace PoingStudios.AdMob.Core
{
	public class MobileSingletonPlugin
	{
		protected static GodotObject GetPlugin(string pluginName, bool isRequired = true)
		{
			if (Engine.HasSingleton(pluginName))
			{
				return Engine.GetSingleton(pluginName);
			}

			string osName = OS.GetName();
			if (osName != "Android" && osName != "iOS")
			{
				return null;
			}

			string location = osName == "Android" 
				? "'res://addons/admob/android/config.gd' and 'Use Gradle Build' is enabled" 
				: "the 'Plugins' section of the Export tab";
			
			string message = $"{pluginName} not found, make sure it is enabled in {location}";

			if (isRequired)
			{
				GD.PrintErr(message);
			}
			else
			{
				GD.PushWarning(message);
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

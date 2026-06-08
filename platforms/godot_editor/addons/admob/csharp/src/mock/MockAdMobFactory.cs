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
using System.Collections.Generic;

namespace PoingStudios.AdMob.Core
{
	public static class MockAdMobFactory
	{
		private static readonly Dictionary<string, GodotObject> _mocks = new Dictionary<string, GodotObject>();

		public static GodotObject GetMockPlugin(string pluginName)
		{
			if (_mocks.TryGetValue(pluginName, out GodotObject mock))
			{
				return mock;
			}

			GodotObject mockInstance = null;

			switch (pluginName)
			{
				case "PoingGodotAdMob":
					mockInstance = new MockMobileAdsPlugin();
					break;
				case "PoingGodotAdMobAdView":
					mockInstance = new MockAdViewPlugin();
					break;
				case "PoingGodotAdMobNativeOverlayAd":
					mockInstance = new MockNativeOverlayAdPlugin();
					break;
				case "PoingGodotAdMobAdSize":
					mockInstance = new MockAdSizePlugin();
					break;
				case "PoingGodotAdMobInterstitialAd":
					mockInstance = new MockInterstitialAdPlugin();
					break;
				case "PoingGodotAdMobRewardedAd":
					mockInstance = new MockRewardedAdPlugin();
					break;
				case "PoingGodotAdMobRewardedInterstitialAd":
					mockInstance = new MockRewardedInterstitialAdPlugin();
					break;
				case "PoingGodotAdMobAppOpenAd":
					mockInstance = new MockAppOpenAdPlugin();
					break;
			}

			if (mockInstance != null)
			{
				_mocks[pluginName] = mockInstance;
				if (mockInstance is Node nodeInstance)
				{
					var mainLoop = Engine.GetMainLoop();
					if (mainLoop is SceneTree tree)
					{
						tree.Root.CallDeferred(Node.MethodName.AddChild, nodeInstance);
					}
				}
			}

			return mockInstance;
		}
	}
}

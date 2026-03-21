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
using Godot.Collections;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
	public class AdView : MobileSingletonPlugin
	{
		private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobAdView");

		public AdListener AdListener { get; set; } = new AdListener();
		public AdPosition Position { get; private set; }

		private readonly int _uid;

		private readonly Callable _onAdClickedCallable;
		private readonly Callable _onAdClosedCallable;
		private readonly Callable _onAdFailedToLoadCallable;
		private readonly Callable _onAdImpressionCallable;
		private readonly Callable _onAdLoadedCallable;
		private readonly Callable _onAdOpenedCallable;

		public AdView(string adUnitId, AdSize adSize, AdPosition adPosition)
		{
			Position = adPosition;

			_onAdClickedCallable = Callable.From<int>(OnAdClicked);
			_onAdClosedCallable = Callable.From<int>(OnAdClosed);
			_onAdFailedToLoadCallable = Callable.From<int, Dictionary>(OnAdFailedToLoad);
			_onAdImpressionCallable = Callable.From<int>(OnAdImpression);
			_onAdLoadedCallable = Callable.From<int>(OnAdLoaded);
			_onAdOpenedCallable = Callable.From<int>(OnAdOpened);

			if (_plugin != null)
			{
				var adViewDict = new Dictionary
				{
					{ "ad_unit_id", adUnitId },
					{ "ad_position", (int)adPosition.Value },
					{ "custom_position", new Dictionary
						{
							{ "x", adPosition.Offset.X },
							{ "y", adPosition.Offset.Y }
						}
					},
					{ "ad_size", new Dictionary
						{
							{ "width", adSize.Width },
							{ "height", adSize.Height }
						}
					}
				};

				_uid = (int)_plugin.Call("create", adViewDict);
				SafeConnect(_plugin, "on_ad_clicked", _onAdClickedCallable);
				SafeConnect(_plugin, "on_ad_closed", _onAdClosedCallable);
				SafeConnect(_plugin, "on_ad_failed_to_load", _onAdFailedToLoadCallable);
				SafeConnect(_plugin, "on_ad_impression", _onAdImpressionCallable);
				SafeConnect(_plugin, "on_ad_loaded", _onAdLoadedCallable);
				SafeConnect(_plugin, "on_ad_opened", _onAdOpenedCallable);
			}
		}

		public void LoadAd(AdRequest adRequest)
		{
			_plugin?.Call("load_ad", _uid, adRequest.ConvertToDictionary(),
				new Array<string>(adRequest.Keywords));
		}

		public void Destroy()
		{
			_plugin?.Call("destroy", _uid);
		}

		public void Hide()
		{
			_plugin?.Call("hide", _uid);
		}

		public void Show()
		{
			_plugin?.Call("show", _uid);
		}

		public void SetPosition(AdPosition adPosition)
		{
			Position = adPosition;
			if (_plugin != null)
			{
				if (adPosition.Value == AdPosition.Values.Custom)
				{
					_plugin.Call("update_custom_position", _uid, adPosition.Offset.X, adPosition.Offset.Y);
				}
				else
				{
					_plugin.Call("update_position", _uid, (int)adPosition.Value);
				}
			}
		}

		public int GetWidth()
		{
			if (_plugin != null)
				return (int)_plugin.Call("get_width", _uid);
			return -1;
		}

		public int GetHeight()
		{
			if (_plugin != null)
				return (int)_plugin.Call("get_height", _uid);
			return -1;
		}

		public int GetWidthInPixels()
		{
			if (_plugin != null)
				return (int)_plugin.Call("get_width_in_pixels", _uid);
			return -1;
		}

		public int GetHeightInPixels()
		{
			if (_plugin != null)
				return (int)_plugin.Call("get_height_in_pixels", _uid);
			return -1;
		}

		private void OnAdClicked(int uid)
		{
			if (uid != _uid) return;
			Callable.From(() => AdListener.OnAdClicked?.Invoke()).CallDeferred();
		}

		private void OnAdClosed(int uid)
		{
			if (uid != _uid) return;
			Callable.From(() => AdListener.OnAdClosed?.Invoke()).CallDeferred();
		}

		private void OnAdFailedToLoad(int uid, Dictionary errorDict)
		{
			if (uid != _uid) return;
			var error = LoadAdError.Create(errorDict);
			Callable.From(() => AdListener.OnAdFailedToLoad?.Invoke(error)).CallDeferred();
		}

		private void OnAdImpression(int uid)
		{
			if (uid != _uid) return;
			Callable.From(() => AdListener.OnAdImpression?.Invoke()).CallDeferred();
		}

		private void OnAdLoaded(int uid)
		{
			if (uid != _uid) return;
			Callable.From(() => AdListener.OnAdLoaded?.Invoke()).CallDeferred();
		}

		private void OnAdOpened(int uid)
		{
			if (uid != _uid) return;
			Callable.From(() => AdListener.OnAdOpened?.Invoke()).CallDeferred();
		}
	}
}

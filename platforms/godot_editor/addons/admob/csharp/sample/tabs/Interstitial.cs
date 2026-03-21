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
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Sample;

public partial class Interstitial : VBoxContainer
{
	private const string AdUnitIdAndroid = "ca-app-pub-3940256099942544/1033173712";
	private const string AdUnitIdIos = "ca-app-pub-3940256099942544/4411468910";

	private string AdUnitId => OS.GetName() == "iOS" ? AdUnitIdIos : AdUnitIdAndroid;

	private InterstitialAd _interstitialAd;

	private Button _loadBtn;
	private Button _showBtn;
	private Button _destroyBtn;

	public override void _Ready()
	{
		_loadBtn = GetNode<Button>("Load");
		_showBtn = GetNode<Button>("Show");
		_destroyBtn = GetNode<Button>("Destroy");

		_loadBtn.Pressed += OnLoadPressed;
		_showBtn.Pressed += OnShowPressed;
		_destroyBtn.Pressed += OnDestroyPressed;
	}

	private void UpdateUI(bool isLoaded)
	{
		_loadBtn.Disabled = isLoaded;
		_showBtn.Disabled = !isLoaded;
		_destroyBtn.Disabled = !isLoaded;
	}

	private void OnLoadPressed()
	{
		Log("Loading...");
		UpdateUI(false);

		new InterstitialAdLoader().Load(AdUnitId, new AdRequest(), new InterstitialAdLoadCallback
		{
			OnAdLoaded = ad =>
			{
				Log("Ad loaded successfully");
				_interstitialAd = ad;
				_interstitialAd.FullScreenContentCallback = new FullScreenContentCallback
				{
					OnAdShowedFullScreenContent = () => Log("Ad showed"),
					OnAdDismissedFullScreenContent = () =>
					{
						Log("Ad dismissed");
						DestroyAd();
					},
					OnAdFailedToShowFullScreenContent = err => Log($"Failed to show: {err.Message}"),
					OnAdClicked = () => Log("Ad clicked"),
					OnAdImpression = () => Log("Impression recorded"),
				};
				UpdateUI(true);
			},
			OnAdFailedToLoad = err => { Log($"Failed to load: {err.Message}"); UpdateUI(false); },
		});
	}

	private void OnShowPressed() => _interstitialAd?.Show();

	private void OnDestroyPressed() => DestroyAd();

	private void DestroyAd()
	{
		if (_interstitialAd != null)
		{
			_interstitialAd.Destroy();
			_interstitialAd = null;
			Log("Ad destroyed");
			UpdateUI(false);
		}
	}

	private void Log(string message)
	{
		if (SampleRegistry.Logger != null)
			SampleRegistry.Logger.LogMessage("[Interstitial] " + message);
		else
			GD.Print("[Interstitial] " + message);
	}
}

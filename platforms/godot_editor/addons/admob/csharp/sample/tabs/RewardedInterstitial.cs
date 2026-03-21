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

public partial class RewardedInterstitial : VBoxContainer
{
	private const string AdUnitIdAndroid = "ca-app-pub-3940256099942544/5354046379";
	private const string AdUnitIdIos = "ca-app-pub-3940256099942544/6978759866";

	private string AdUnitId => OS.GetName() == "iOS" ? AdUnitIdIos : AdUnitIdAndroid;

	private RewardedInterstitialAd _rewardedInterstitialAd;

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

		new RewardedInterstitialAdLoader().Load(AdUnitId, new AdRequest(), new RewardedInterstitialAdLoadCallback
		{
			OnAdLoaded = ad =>
			{
				Log("Ad loaded successfully");
				_rewardedInterstitialAd = ad;
				_rewardedInterstitialAd.FullScreenContentCallback = new FullScreenContentCallback
				{
					OnAdShowedFullScreenContent = () => Log("Ad showed"),
					OnAdDismissedFullScreenContent = () =>
					{
						Log("Ad dismissed");
						DestroyAd();
					},
					OnAdFailedToShowFullScreenContent = err => Log($"Failed to show: {err.Message}"),
				};

				var ssv = new ServerSideVerificationOptions
				{
					CustomData = "TEST_DATA",
					UserId = "test_user",
				};
				_rewardedInterstitialAd.SetServerSideVerificationOptions(ssv);

				UpdateUI(true);
			},
			OnAdFailedToLoad = err => { Log($"Failed to load: {err.Message}"); UpdateUI(false); },
		});
	}

	private void OnShowPressed()
	{
		_rewardedInterstitialAd?.Show(new OnUserEarnedRewardListener
		{
			OnUserEarnedReward = reward => Log($"Reward earned: {reward.Amount} {reward.Type}"),
		});
	}

	private void OnDestroyPressed() => DestroyAd();

	private void DestroyAd()
	{
		if (_rewardedInterstitialAd != null)
		{
			_rewardedInterstitialAd.Destroy();
			_rewardedInterstitialAd = null;
			Log("Ad destroyed");
			UpdateUI(false);
		}
	}

	private void Log(string message)
	{
		if (SampleRegistry.Logger != null)
			SampleRegistry.Logger.LogMessage("[RewardedInterstitial] " + message);
		else
			GD.Print("[RewardedInterstitial] " + message);
	}
}

// MIT License
//
// Copyright (c) 2023-present Poing Studios
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
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
using PoingStudios.AdMob.Ump.Api;
using PoingStudios.AdMob.Ump.Core;

public partial class MainCSharpExample : Control
{
	private const string BannerAdUnitIdAndroid = "ca-app-pub-3940256099942544/6300978111";
	private const string BannerAdUnitIdIos = "ca-app-pub-3940256099942544/2934735716";
	private const string InterstitialAdUnitIdAndroid = "ca-app-pub-3940256099942544/1033173712";
	private const string InterstitialAdUnitIdIos = "ca-app-pub-3940256099942544/4411468910";
	private const string RewardedAdUnitIdAndroid = "ca-app-pub-3940256099942544/5224354917";
	private const string RewardedAdUnitIdIos = "ca-app-pub-3940256099942544/1712485313";
	private const string RewardedInterstitialAdUnitIdAndroid = "ca-app-pub-3940256099942544/5354046379";
	private const string RewardedInterstitialAdUnitIdIos = "ca-app-pub-3940256099942544/6978759866";

	private string BannerAdUnitId => OS.GetName() == "iOS" ? BannerAdUnitIdIos : BannerAdUnitIdAndroid;
	private string InterstitialAdUnitId => OS.GetName() == "iOS" ? InterstitialAdUnitIdIos : InterstitialAdUnitIdAndroid;
	private string RewardedAdUnitId => OS.GetName() == "iOS" ? RewardedAdUnitIdIos : RewardedAdUnitIdAndroid;
	private string RewardedInterstitialAdUnitId => OS.GetName() == "iOS" ? RewardedInterstitialAdUnitIdIos : RewardedInterstitialAdUnitIdAndroid;

	private AdView _adView;
	private InterstitialAd _interstitialAd;
	private RewardedAd _rewardedAd;
	private RewardedInterstitialAd _rewardedInterstitialAd;

	private RichTextLabel _consoleOutput;
	private Node _safeArea; // MarginContainer for safe area logic

	private const string TabsRoot = "Background/SafeArea/LayoutContainer/TabContent/MainTabs/";

	// UI References
	private Button _bannerLoad, _bannerDestroy, _bannerShow, _bannerHide, _bannerGetSize;
	private Button _interstitialLoad, _interstitialShow, _interstitialDestroy;
	private Button _rewardedLoad, _rewardedShow, _rewardedDestroy;
	private Button _rewardedInterstitialLoad, _rewardedInterstitialShow, _rewardedInterstitialDestroy;
	
	// MobileAds Tab controls
	private AudioStreamPlayer _musicPlayer;
	private CheckButton _iosAppPauseCheck, _muteMusicCheck, _adMutedCheck;
	private HSlider _adVolumeSlider;

	private AdPosition _currentAdPosition = AdPosition.Bottom;

	public override void _Ready()
	{
		_consoleOutput = GetNode<RichTextLabel>("Background/SafeArea/LayoutContainer/ConsolePanel/ConsoleOutput");
		_safeArea = GetNode<MarginContainer>("Background/SafeArea");

		SetupBannerTab();
		SetupInterstitialTab();
		SetupRewardedTab();
		SetupRewardedInterstitialTab();
		SetupUmpTab();
		SetupMobileAdsTab();

		InitializeMobileAds();
	}

	private void SetupBannerTab()
	{
		string path = TabsRoot + "Banner/";
		_bannerLoad = GetNode<Button>(path + "BannerActions/LoadBanner");
		_bannerDestroy = GetNode<Button>(path + "BannerActions/DestroyBanner");
		_bannerShow = GetNode<Button>(path + "BannerActions/ShowBanner");
		_bannerHide = GetNode<Button>(path + "BannerActions/HideBanner");
		_bannerGetSize = GetNode<Button>(path + "BannerActions/GetSize");

		_bannerLoad.Pressed += OnLoadBannerPressed;
		_bannerDestroy.Pressed += OnDestroyBannerPressed;
		_bannerShow.Pressed += OnShowBannerPressed;
		_bannerHide.Pressed += OnHideBannerPressed;
		_bannerGetSize.Pressed += OnGetSizePressed;

		// Position Grid
		string grid = path + "PositionCard/VBox/PositionGrid/";
		GetNode<Button>(grid + "TOP_LEFT").Pressed += () => UpdatePosition(AdPosition.TopLeft);
		GetNode<Button>(grid + "TOP").Pressed += () => UpdatePosition(AdPosition.Top);
		GetNode<Button>(grid + "TOP_RIGHT").Pressed += () => UpdatePosition(AdPosition.TopRight);
		GetNode<Button>(grid + "LEFT").Pressed += () => UpdatePosition(AdPosition.Left);
		GetNode<Button>(grid + "CENTER").Pressed += () => UpdatePosition(AdPosition.Center);
		GetNode<Button>(grid + "RIGHT").Pressed += () => UpdatePosition(AdPosition.Right);
		GetNode<Button>(grid + "BOTTOM_LEFT").Pressed += () => UpdatePosition(AdPosition.BottomLeft);
		GetNode<Button>(grid + "BOTTOM").Pressed += () => UpdatePosition(AdPosition.Bottom);
		GetNode<Button>(grid + "BOTTOM_RIGHT").Pressed += () => UpdatePosition(AdPosition.BottomRight);
	}

	private void SetupInterstitialTab()
	{
		string path = TabsRoot + "Interstitial/";
		_interstitialLoad = GetNode<Button>(path + "Load");
		_interstitialShow = GetNode<Button>(path + "Show");
		_interstitialDestroy = GetNode<Button>(path + "Destroy");

		_interstitialLoad.Pressed += OnLoadInterstitialPressed;
		_interstitialShow.Pressed += OnShowInterstitialPressed;
		_interstitialDestroy.Pressed += OnDestroyInterstitialPressed;
	}

	private void SetupRewardedTab()
	{
		string path = TabsRoot + "Rewarded/";
		_rewardedLoad = GetNode<Button>(path + "Load");
		_rewardedShow = GetNode<Button>(path + "Show");
		_rewardedDestroy = GetNode<Button>(path + "Destroy");

		_rewardedLoad.Pressed += OnLoadRewardedPressed;
		_rewardedShow.Pressed += OnShowRewardedPressed;
		_rewardedDestroy.Pressed += OnDestroyRewardedPressed;
	}

	private void SetupRewardedInterstitialTab()
	{
		string path = TabsRoot + "RewardedInterstitial/";
		_rewardedInterstitialLoad = GetNode<Button>(path + "Load");
		_rewardedInterstitialShow = GetNode<Button>(path + "Show");
		_rewardedInterstitialDestroy = GetNode<Button>(path + "Destroy");

		_rewardedInterstitialLoad.Pressed += OnLoadRewardedInterstitialPressed;
		_rewardedInterstitialShow.Pressed += OnShowRewardedInterstitialPressed;
		_rewardedInterstitialDestroy.Pressed += OnDestroyRewardedInterstitialPressed;
	}

	private void SetupUmpTab()
	{
		string path = TabsRoot + "UMP/";
		GetNode<Button>(path + "GetConsentStatus").Pressed += OnGetConsentStatusPressed;
		GetNode<Button>(path + "ResetConsentInformation").Pressed += OnResetConsentPressed;
	}

	private void SetupMobileAdsTab()
	{
		string path = TabsRoot + "MobileAds/";
		GetNode<Button>(path + "GetInitStatus").Pressed += OnGetInitStatusPressed;
		
		_iosAppPauseCheck = GetNode<CheckButton>(path + "iOSAppPause");
		_muteMusicCheck = GetNode<CheckButton>(path + "MuteMusic");
		_adMutedCheck = GetNode<CheckButton>(path + "AdMuted");
		_adVolumeSlider = GetNode<HSlider>(path + "AdVolumeContainer/AdVolumeSlider");
		_musicPlayer = GetNode<AudioStreamPlayer>(path + "MusicPlayer");

		_iosAppPauseCheck.Pressed += () => MobileAds.SetIosAppPauseOnBackground(_iosAppPauseCheck.ButtonPressed);
		_muteMusicCheck.Pressed += () => _musicPlayer.StreamPaused = _muteMusicCheck.ButtonPressed;
		_adMutedCheck.Pressed += () => MobileAds.SetAppMuted(_adMutedCheck.ButtonPressed);
		_adVolumeSlider.ValueChanged += (val) => MobileAds.SetAppVolume((float)val);
	}

	// ── Initialization ─────────────────────────────────────────────────────────

	private void InitializeMobileAds()
	{
		Log("Initializing MobileAds...");

		var config = new RequestConfiguration
		{
			ChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatment.True,
			UnderAgeOfConsent = RequestConfiguration.TagForUnderAgeOfConsent.True,
			MaxAdContentRating = RequestConfiguration.MaxAdContentRatingG,
		};
		MobileAds.SetRequestConfiguration(config);

		MobileAds.Initialize(new OnInitializationCompleteListener
		{
			OnInitializationComplete = status =>
			{
				Log("MobileAds initialization complete.");
				foreach (var (name, adapterStatus) in status.AdapterStatusMap)
					Log($"  [{name}] State: {adapterStatus.State} | Latency: {adapterStatus.Latency}ms | Desc: {adapterStatus.Description}");
				
				if (OS.GetName() == "iOS")
				{
					// For Meta Audience Network on iOS
					// FBAdSettings.SetAdvertiserTrackingEnabled(true);
				}
			}
		});
	}

	private void OnGetInitStatusPressed()
	{
		var status = MobileAds.GetInitializationStatus();
		if (status != null)
		{
			Log("MobileAds initialization status:");
			foreach (var (name, adapterStatus) in status.AdapterStatusMap)
				Log($"  [{name}] State: {adapterStatus.State} | Latency: {adapterStatus.Latency}ms");
		}
	}

	// ── Banner ─────────────────────────────────────────────────────────────────

	private void UpdateBannerUI(bool isLoaded)
	{
		_bannerLoad.Disabled = isLoaded;
		_bannerDestroy.Disabled = !isLoaded;
		_bannerShow.Disabled = !isLoaded;
		_bannerHide.Disabled = !isLoaded;
		_bannerGetSize.Disabled = !isLoaded;
	}

	private void UpdatePosition(AdPosition newPos)
	{
		_currentAdPosition = newPos;
		Log($"[Banner] Position updated to: {newPos}");
		if (_adView != null) OnLoadBannerPressed();
	}

	private void OnLoadBannerPressed()
	{
		_adView?.Destroy();
		UpdateBannerUI(false);
		Log("[Banner] Loading adaptive banner...");

		var size = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
		_adView = new AdView(BannerAdUnitId, size, _currentAdPosition);
		_adView.AdListener = new AdListener
		{
			OnAdLoaded = () =>
			{
				Log("[Banner] Ad loaded successfully");
				UpdateBannerUI(true);
				// FIXME: AdView in C# is not a GodotObject, cannot pass to SafeArea.gd directly
				// if (_safeArea.HasMethod("update_ad_overlap")) _safeArea.Call("update_ad_overlap", _adView);
			},
			OnAdFailedToLoad = err => { Log($"[Banner] Failed to load: {err.Message}"); UpdateBannerUI(false); },
			OnAdClicked = () => Log("[Banner] Ad clicked"),
			OnAdOpened = () => Log("[Banner] Ad opened"),
			OnAdClosed = () => Log("[Banner] Ad closed"),
			OnAdImpression = () => Log("[Banner] Impression recorded"),
		};
		_adView.LoadAd(new AdRequest());
	}

	private void OnShowBannerPressed() { _adView?.Show(); Log("[Banner] Banner shown"); }

	private void OnHideBannerPressed() { _adView?.Hide(); Log("[Banner] Banner hidden"); }

	private void OnDestroyBannerPressed()
	{
		_adView?.Destroy();
		_adView = null;
		Log("[Banner] Banner destroyed");
		UpdateBannerUI(false);
		if (_safeArea.HasMethod("reset_ad_overlap")) _safeArea.Call("reset_ad_overlap");
	}

	private void OnGetSizePressed()
	{
		if (_adView != null)
		{
			Log($"[Banner] W: {_adView.GetWidth()}, H: {_adView.GetHeight()} | Pixels: {_adView.GetWidthInPixels()}x{_adView.GetHeightInPixels()}");
		}
	}

	// ── Interstitial ───────────────────────────────────────────────────────────

	private void UpdateInterstitialUI(bool isLoaded)
	{
		_interstitialLoad.Disabled = isLoaded;
		_interstitialShow.Disabled = !isLoaded;
		_interstitialDestroy.Disabled = !isLoaded;
	}

	private void OnLoadInterstitialPressed()
	{
		Log("[Interstitial] Loading...");
		UpdateInterstitialUI(false);

		new InterstitialAdLoader().Load(InterstitialAdUnitId, new AdRequest(), new InterstitialAdLoadCallback
		{
			OnAdLoaded = ad =>
			{
				Log($"[Interstitial] Ad loaded successfully (UID: {ad.GetHashCode()})");
				_interstitialAd = ad;
				_interstitialAd.FullScreenContentCallback = new FullScreenContentCallback
				{
					OnAdShowedFullScreenContent = () => Log("[Interstitial] Ad showed"),
					OnAdDismissedFullScreenContent = () =>
					{
						Log("[Interstitial] Ad dismissed");
						OnDestroyInterstitialPressed();
					},
					OnAdFailedToShowFullScreenContent = err => Log($"[Interstitial] Failed to show: {err.Message}"),
					OnAdClicked = () => Log("[Interstitial] Ad clicked"),
					OnAdImpression = () => Log("[Interstitial] Impression recorded"),
				};
				UpdateInterstitialUI(true);
			},
			OnAdFailedToLoad = err => { Log($"[Interstitial] Failed to load: {err.Message}"); UpdateInterstitialUI(false); },
		});
	}

	private void OnShowInterstitialPressed() => _interstitialAd?.Show();

	private void OnDestroyInterstitialPressed()
	{
		if (_interstitialAd != null)
		{
			_interstitialAd.Destroy();
			_interstitialAd = null;
			Log("[Interstitial] Ad destroyed");
			UpdateInterstitialUI(false);
		}
	}

	// ── Rewarded ───────────────────────────────────────────────────────────────

	private void UpdateRewardedUI(bool isLoaded)
	{
		_rewardedLoad.Disabled = isLoaded;
		_rewardedShow.Disabled = !isLoaded;
		_rewardedDestroy.Disabled = !isLoaded;
	}

	private void OnLoadRewardedPressed()
	{
		Log("[Rewarded] Loading...");
		UpdateRewardedUI(false);

		new RewardedAdLoader().Load(RewardedAdUnitId, new AdRequest(), new RewardedAdLoadCallback
		{
			OnAdLoaded = ad =>
			{
				Log($"[Rewarded] Ad loaded successfully (UID: {ad.GetHashCode()})");
				_rewardedAd = ad;
				_rewardedAd.FullScreenContentCallback = new FullScreenContentCallback
				{
					OnAdShowedFullScreenContent = () => Log("[Rewarded] Ad showed"),
					OnAdDismissedFullScreenContent = () =>
					{
						Log("[Rewarded] Ad dismissed");
						OnDestroyRewardedPressed();
					},
					OnAdFailedToShowFullScreenContent = err => Log($"[Rewarded] Failed to show: {err.Message}"),
				};
				
				// Optional: SSV setup mirror
				var ssv = new ServerSideVerificationOptions { CustomData = "TEST_DATA", UserId = "test_user" };
				_rewardedAd.SetServerSideVerificationOptions(ssv);

				UpdateRewardedUI(true);
			},
			OnAdFailedToLoad = err => { Log($"[Rewarded] Failed to load: {err.Message}"); UpdateRewardedUI(false); },
		});
	}

	private void OnShowRewardedPressed()
	{
		_rewardedAd?.Show(new OnUserEarnedRewardListener
		{
			OnUserEarnedReward = reward => Log($"[Rewarded] Reward earned: {reward.Amount} {reward.Type}"),
		});
	}

	private void OnDestroyRewardedPressed()
	{
		if (_rewardedAd != null)
		{
			_rewardedAd.Destroy();
			_rewardedAd = null;
			Log("[Rewarded] Ad destroyed");
			UpdateRewardedUI(false);
		}
	}

	// ── Rewarded Interstitial ──────────────────────────────────────────────────

	private void UpdateRewardedInterstitialUI(bool isLoaded)
	{
		_rewardedInterstitialLoad.Disabled = isLoaded;
		_rewardedInterstitialShow.Disabled = !isLoaded;
		_rewardedInterstitialDestroy.Disabled = !isLoaded;
	}

	private void OnLoadRewardedInterstitialPressed()
	{
		Log("[RewardedInterstitial] Loading...");
		UpdateRewardedInterstitialUI(false);

		new RewardedInterstitialAdLoader().Load(RewardedInterstitialAdUnitId, new AdRequest(), new RewardedInterstitialAdLoadCallback
		{
			OnAdLoaded = ad =>
			{
				Log($"[RewardedInterstitial] Ad loaded successfully (UID: {ad.GetHashCode()})");
				_rewardedInterstitialAd = ad;
				_rewardedInterstitialAd.FullScreenContentCallback = new FullScreenContentCallback
				{
					OnAdShowedFullScreenContent = () => Log("[RewardedInterstitial] Ad showed"),
					OnAdDismissedFullScreenContent = () =>
					{
						Log("[RewardedInterstitial] Ad dismissed");
						OnDestroyRewardedInterstitialPressed();
					},
					OnAdFailedToShowFullScreenContent = err => Log($"[RewardedInterstitial] Failed to show: {err.Message}"),
				};
				UpdateRewardedInterstitialUI(true);
			},
			OnAdFailedToLoad = err => { Log($"[RewardedInterstitial] Failed to load: {err.Message}"); UpdateRewardedInterstitialUI(false); },
		});
	}

	private void OnShowRewardedInterstitialPressed()
	{
		_rewardedInterstitialAd?.Show(new OnUserEarnedRewardListener
		{
			OnUserEarnedReward = reward => Log($"[RewardedInterstitial] Reward earned: {reward.Amount} {reward.Type}"),
		});
	}

	private void OnDestroyRewardedInterstitialPressed()
	{
		if (_rewardedInterstitialAd != null)
		{
			_rewardedInterstitialAd.Destroy();
			_rewardedInterstitialAd = null;
			Log("[RewardedInterstitial] Ad destroyed");
			UpdateRewardedInterstitialUI(false);
		}
	}

	// ── UMP (Consent) ──────────────────────────────────────────────────────────

	private void OnGetConsentStatusPressed()
	{
		var info = UserMessagingPlatform.ConsentInformation;
		Log($"[UMP] Current Consent Status: {info.GetConsentStatus()}");
	}

	private void OnResetConsentPressed()
	{
		Log("[UMP] Resetting consent information...");
		var info = UserMessagingPlatform.ConsentInformation;
		info.Reset();

		var parameters = new ConsentRequestParameters
		{
			ConsentDebugSettings = new ConsentDebugSettings { DebugGeography = DebugGeography.Eea },
		};

		info.Update(parameters,
			onSuccess: () =>
			{
				Log($"[UMP] Consent info updated. Status: {info.GetConsentStatus()}");
				if (info.GetIsConsentFormAvailable())
				{
					Log("[UMP] Consent form available, loading...");
					UserMessagingPlatform.LoadConsentForm(
						onSuccess: form =>
						{
							Log("[UMP] Form loaded. Showing...");
							form.Show(err => Log(err == null ? "[UMP] Form dismissed." : $"[UMP] Form error: {err.Message}"));
						},
						onFailure: err => Log($"[UMP] Form load error: {err.Message}")
					);
				}
			},
			onFailure: err => Log($"[UMP] Consent update error: {err.Message}")
		);
	}

	// ── Utility ────────────────────────────────────────────────────────────────

	private void Log(string message)
	{
		GD.Print($"[AdMob] {message}");
		if (_consoleOutput != null)
			_consoleOutput.Text += $"\n{message}";
	}
}

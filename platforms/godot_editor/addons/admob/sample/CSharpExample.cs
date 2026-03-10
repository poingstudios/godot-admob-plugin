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

/// <summary>
/// Example scene demonstrating how to use the AdMob C# API.
/// Replace test ad unit IDs with your own before publishing.
/// </summary>
public partial class CSharpExample : VBoxContainer
{
    // Google test ad unit IDs — safe to use during development.
    // Replace with your real ad unit IDs before releasing.
    private const string BannerAdUnitIdAndroid = "ca-app-pub-3940256099942544/6300978111";
    private const string BannerAdUnitIdIos = "ca-app-pub-3940256099942544/2934735716";
    private const string InterstitialAdUnitIdAndroid = "ca-app-pub-3940256099942544/1033173712";
    private const string InterstitialAdUnitIdIos = "ca-app-pub-3940256099942544/4411468910";
    private const string RewardedAdUnitIdAndroid = "ca-app-pub-3940256099942544/5224354917";
    private const string RewardedAdUnitIdIos = "ca-app-pub-3940256099942544/1712485313";

    private string BannerAdUnitId => OS.GetName() == "iOS" ? BannerAdUnitIdIos : BannerAdUnitIdAndroid;
    private string InterstitialAdUnitId => OS.GetName() == "iOS" ? InterstitialAdUnitIdIos : InterstitialAdUnitIdAndroid;
    private string RewardedAdUnitId => OS.GetName() == "iOS" ? RewardedAdUnitIdIos : RewardedAdUnitIdAndroid;

    private AdView _adView;
    private InterstitialAd _interstitialAd;
    private RewardedAd _rewardedAd;

    // UI node references populated in _Ready
    private Label _statusLabel;
    private RichTextLabel _logOutput;
    private Button _showBannerButton;
    private Button _hideBannerButton;
    private Button _destroyBannerButton;
    private Button _showInterstitialButton;
    private Button _showRewardedButton;

    public override void _Ready()
    {
        _statusLabel = GetNode<Label>("StatusLabel");
        _logOutput = GetNode<RichTextLabel>("LogOutput");

        _showBannerButton = GetNode<Button>("ButtonsScroll/Buttons/ShowBannerButton");
        _hideBannerButton = GetNode<Button>("ButtonsScroll/Buttons/HideBannerButton");
        _destroyBannerButton = GetNode<Button>("ButtonsScroll/Buttons/DestroyBannerButton");
        _showInterstitialButton = GetNode<Button>("ButtonsScroll/Buttons/ShowInterstitialButton");
        _showRewardedButton = GetNode<Button>("ButtonsScroll/Buttons/ShowRewardedButton");

        GetNode<Button>("ButtonsScroll/Buttons/InitializeButton").Pressed += OnInitializePressed;
        GetNode<Button>("ButtonsScroll/Buttons/LoadBannerButton").Pressed += OnLoadBannerPressed;
        _showBannerButton.Pressed += OnShowBannerPressed;
        _hideBannerButton.Pressed += OnHideBannerPressed;
        _destroyBannerButton.Pressed += OnDestroyBannerPressed;
        GetNode<Button>("ButtonsScroll/Buttons/LoadInterstitialButton").Pressed += OnLoadInterstitialPressed;
        _showInterstitialButton.Pressed += OnShowInterstitialPressed;
        GetNode<Button>("ButtonsScroll/Buttons/LoadRewardedButton").Pressed += OnLoadRewardedPressed;
        _showRewardedButton.Pressed += OnShowRewardedPressed;
        GetNode<Button>("ButtonsScroll/Buttons/RequestConsentButton").Pressed += OnRequestConsentPressed;

        Log("Ready — press \"Initialize MobileAds\" to begin.");
    }

    // ── Initialization ─────────────────────────────────────────────────────────

    private void OnInitializePressed()
    {
        Log("Initializing MobileAds...");
        _statusLabel.Text = "Initializing...";

        var config = new RequestConfiguration
        {
            ChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatment.Unspecified,
            MaxAdContentRating = RequestConfiguration.MaxAdContentRatingG,
        };
        MobileAds.SetRequestConfiguration(config);

        MobileAds.Initialize(new OnInitializationCompleteListener
        {
            OnInitializationComplete = status =>
            {
                _statusLabel.Text = "Initialized ✓";
                Log("MobileAds initialized.");
                foreach (var (name, adapterStatus) in status.AdapterStatusMap)
                    Log($"  Adapter [{name}] state={adapterStatus.State} latency={adapterStatus.Latency}ms");
            }
        });
    }

    // ── Banner ─────────────────────────────────────────────────────────────────

    private void OnLoadBannerPressed()
    {
        Log("Loading banner ad...");
        _adView?.Destroy();

        var size = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
        _adView = new AdView(BannerAdUnitId, size, AdPosition.Bottom);
        _adView.AdListener = new AdListener
        {
            OnAdLoaded = () =>
            {
                Log("Banner loaded.");
                _showBannerButton.Disabled = false;
                _hideBannerButton.Disabled = false;
                _destroyBannerButton.Disabled = false;
            },
            OnAdFailedToLoad = err => Log($"Banner failed to load: {err.Message}"),
            OnAdClicked = () => Log("Banner clicked."),
            OnAdOpened = () => Log("Banner opened."),
            OnAdClosed = () => Log("Banner closed."),
            OnAdImpression = () => Log("Banner impression."),
        };
        _adView.LoadAd(new AdRequest());
    }

    private void OnShowBannerPressed() => _adView?.Show();

    private void OnHideBannerPressed() => _adView?.Hide();

    private void OnDestroyBannerPressed()
    {
        _adView?.Destroy();
        _adView = null;
        _showBannerButton.Disabled = true;
        _hideBannerButton.Disabled = true;
        _destroyBannerButton.Disabled = true;
        Log("Banner destroyed.");
    }

    // ── Interstitial ───────────────────────────────────────────────────────────

    private void OnLoadInterstitialPressed()
    {
        Log("Loading interstitial ad...");
        _showInterstitialButton.Disabled = true;

        new InterstitialAdLoader().Load(InterstitialAdUnitId, new AdRequest(), new InterstitialAdLoadCallback
        {
            OnAdLoaded = ad =>
            {
                Log("Interstitial loaded.");
                _interstitialAd = ad;
                _interstitialAd.FullScreenContentCallback = new FullScreenContentCallback
                {
                    OnAdShowedFullScreenContent = () => Log("Interstitial showed."),
                    OnAdDismissedFullScreenContent = () =>
                    {
                        Log("Interstitial dismissed.");
                        _interstitialAd = null;
                        _showInterstitialButton.Disabled = true;
                    },
                    OnAdFailedToShowFullScreenContent = err => Log($"Interstitial failed to show: {err.Message}"),
                    OnAdClicked = () => Log("Interstitial clicked."),
                    OnAdImpression = () => Log("Interstitial impression."),
                };
                _showInterstitialButton.Disabled = false;
            },
            OnAdFailedToLoad = err => Log($"Interstitial failed to load: {err.Message}"),
        });
    }

    private void OnShowInterstitialPressed()
    {
        if (_interstitialAd == null) { Log("No interstitial loaded."); return; }
        _interstitialAd.Show();
    }

    // ── Rewarded ───────────────────────────────────────────────────────────────

    private void OnLoadRewardedPressed()
    {
        Log("Loading rewarded ad...");
        _showRewardedButton.Disabled = true;

        new RewardedAdLoader().Load(RewardedAdUnitId, new AdRequest(), new RewardedAdLoadCallback
        {
            OnAdLoaded = ad =>
            {
                Log("Rewarded ad loaded.");
                _rewardedAd = ad;
                _rewardedAd.FullScreenContentCallback = new FullScreenContentCallback
                {
                    OnAdShowedFullScreenContent = () => Log("Rewarded ad showed."),
                    OnAdDismissedFullScreenContent = () =>
                    {
                        Log("Rewarded ad dismissed.");
                        _rewardedAd = null;
                        _showRewardedButton.Disabled = true;
                    },
                    OnAdFailedToShowFullScreenContent = err => Log($"Rewarded failed to show: {err.Message}"),
                };
                _showRewardedButton.Disabled = false;
            },
            OnAdFailedToLoad = err => Log($"Rewarded failed to load: {err.Message}"),
        });
    }

    private void OnShowRewardedPressed()
    {
        if (_rewardedAd == null) { Log("No rewarded ad loaded."); return; }
        _rewardedAd.Show(new OnUserEarnedRewardListener
        {
            OnUserEarnedReward = reward => Log($"Reward earned: {reward.Amount} {reward.Type}"),
        });
    }

    // ── Consent (UMP) ──────────────────────────────────────────────────────────

    private void OnRequestConsentPressed()
    {
        Log("Requesting consent info...");

        var parameters = new ConsentRequestParameters
        {
            // Remove or adjust ConsentDebugSettings before releasing to production.
            ConsentDebugSettings = new ConsentDebugSettings
            {
                DebugGeography = DebugGeography.Eea,
            },
        };

        var info = UserMessagingPlatform.ConsentInformation;
        info.Update(parameters,
            onSuccess: () =>
            {
                Log($"Consent status: {info.GetConsentStatus()}");
                if (!info.GetIsConsentFormAvailable())
                {
                    Log("No consent form available.");
                    return;
                }
                UserMessagingPlatform.LoadConsentForm(
                    onSuccess: form =>
                    {
                        Log("Consent form loaded. Showing...");
                        form.Show(err =>
                            Log(err == null ? "Consent form dismissed." : $"Form error: {err.Message}"));
                    },
                    onFailure: err => Log($"Consent form load error: {err.Message}")
                );
            },
            onFailure: err => Log($"Consent update error: {err.Message}")
        );
    }

    // ── Utility ────────────────────────────────────────────────────────────────

    private void Log(string message)
    {
        GD.Print($"[AdMob] {message}");
        if (_logOutput != null)
            _logOutput.Text += $"\n{message}";
    }
}

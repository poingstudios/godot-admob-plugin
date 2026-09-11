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
using PoingStudios.AdMob.Mediation.Extras.Meta;
using PoingStudios.AdMob.Mediation.Extras.Vungle;
using PoingStudios.AdMob.Mediation.Extras.IronSource;
using PoingStudios.AdMob.Mediation.Extras.AppLovin;
using PoingStudios.AdMob.Mediation.Extras.BidMachine;
using PoingStudios.AdMob.Mediation.Extras.UnityAds;
using PoingStudios.AdMob.Mediation.Extras.Chartboost;
using PoingStudios.AdMob.Mediation.Extras.DTExchange;
using PoingStudios.AdMob.Sample;

public partial class MainCSharpExample : Control, ISampleLogger
{
	private RichTextLabel _consoleOutput;
	private PanelContainer _supportCard;
	private Timer _resizeTimer;
	private Label _appTitle;

	public override async void _Ready()
	{
		_appTitle = GetNode<Label>("Background/SafeArea/LayoutContainer/HeaderContainer/VBox/LogoContainer/TitleContainer/AppTitle");
		var appSubtitle = GetNode<Label>("Background/SafeArea/LayoutContainer/HeaderContainer/VBox/LogoContainer/TitleContainer/AppSubtitle");
		appSubtitle.Text = $"© {System.DateTime.Now.Year} Poing Studios";

		_resizeTimer = GetNode<Timer>("ResizeTimer");
		_resizeTimer.Timeout += ApplyResize;

		Resized += OnResized;
		ApplyResize();

		var config = new ConfigFile();
		if (config.Load(SampleRegistry.SettingsPath) == Error.Ok)
		{
			string savedLocale = (string)config.GetValue(SampleRegistry.LocalizationSection, SampleRegistry.LocaleKey, "");
			if (!string.IsNullOrEmpty(savedLocale))
			{
				TranslationServer.SetLocale(savedLocale);
			}
		}

		_consoleOutput = GetNode<RichTextLabel>("Background/SafeArea/LayoutContainer/ConsolePanel/ConsoleOutput");
		_consoleOutput.Text = Tr("GAD_LogsStart");

		_supportCard = GetNode<PanelContainer>("Background/SafeArea/LayoutContainer/HeaderContainer/VBox/SupportCard");

		var mainTabs = GetNode<TabContainer>("Background/SafeArea/LayoutContainer/TabContent/MainTabs");
		
		SampleRegistry.Logger = this;
		LogMessage("Main initialized");
		LogMessage("Plugin Version: " + PoingStudios.AdMob.Api.MobileAds.GetVersion());
		LogMessage("Platform SDK Version: " + PoingStudios.AdMob.Api.MobileAds.GetPlatformVersion());

		GetNode<Label>("Background/SafeArea/LayoutContainer/HeaderContainer/VBox/SupportCard/VBox/SupportLabel").Text = Tr("GAD_SupportProject");

		InitializeMobileAds();
		SetupTabTitles(mainTabs);

		// Workaround for TabContainer headers not showing up on start in Godot 4
		// We wait for a couple of frames to ensure the layout and theme are fully applied
		await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame);
		await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame);
		mainTabs.TabsVisible = false;
		mainTabs.TabsVisible = true;
	}

	private void SetupTabTitles(TabContainer mainTabs)
	{
		mainTabs.SetTabTitle(0, "Banner");
		mainTabs.SetTabTitle(1, "Native");
		mainTabs.SetTabTitle(2, "App Open");
		mainTabs.SetTabTitle(3, "Interstitial");
		mainTabs.SetTabTitle(4, "Rewarded");
		mainTabs.SetTabTitle(5, "Rewarded Interstitial");
		mainTabs.SetTabTitle(6, "UMP");
		mainTabs.SetTabTitle(7, "Mobile Ads");
	}

	private void OnResized()
	{
		_resizeTimer?.Start();
	}

	private void ApplyResize()
	{
		var viewportSize = GetViewportRect().Size;
		var windowSize = GetWindow().Size;
		if (viewportSize.X <= 0 || viewportSize.Y <= 0 || windowSize.X <= 0 || windowSize.Y <= 0)
			return;

		float scaleFactor = viewportSize.Y / (float)windowSize.Y;
		float windowFactor = (windowSize.X + windowSize.Y) / 1140.0f;
		float totalFactor = windowFactor * scaleFactor;

		// Use the centralized UI scaling utility to recursively scale all controls
		UIScaler.ScaleUi(this, totalFactor, scaleFactor);

		if (_supportCard != null)
		{
			_supportCard.Visible = windowSize.Y >= 500;
		}
	}

	public void LogMessage(string message)
	{
		GD.Print(message);
		if (_consoleOutput != null)
			_consoleOutput.Text += "\n" + message;
	}

	private void InitializeMobileAds()
	{
		var onInitListener = new OnInitializationCompleteListener
		{
			OnInitializationComplete = OnInitializationComplete,
		};

		var requestConfig = new RequestConfiguration
		{
			ChildDirectedTreatment = RequestConfiguration.TagForChildDirectedTreatment.True,
			UnderAgeOfConsent = RequestConfiguration.TagForUnderAgeOfConsent.True,
			MaxAdContentRating = RequestConfiguration.MaxAdContentRatingG,
		};

		PoingStudios.AdMob.Api.MobileAds.SetRequestConfiguration(requestConfig);
		PoingStudios.AdMob.Api.MobileAds.Initialize(onInitListener);
	}

	private void OnInitializationComplete(InitializationStatus status)
	{
		LogMessage("MobileAds initialization complete");
		LogAdapterStatus(status);

		SetupMediationAdapters();

		if (OS.GetName() == "iOS")
		{
			FBAdSettings.SetAdvertiserTrackingEnabled(true);
		}
	}

	private void SetupMediationAdapters()
	{
		// Vungle setup example
		Vungle.UpdateCcpaStatus(Vungle.Consent.OptedOut);
		Vungle.UpdateConsentStatus(Vungle.Consent.OptedIn, "consent_message");

		// IronSource setup example
		IronSource.SetConsent(true);
		IronSource.SetMetaData("do_not_sell", "false");
		IronSource.SetUserId("unique_user_id_123");

		// AppLovin setup example
		AppLovin.SetHasUserConsent(true);
		AppLovin.SetDoNotSell(false);
		AppLovin.SetMuted(true);

		// BidMachine setup example
		BidMachine.SetSubjectToGdpr(true);
		BidMachine.SetConsentStatus(true);
		BidMachine.SetUsPrivacyString("1YNN");

		// Unity Ads setup example
		UnityAds.SetConsent(true);
		UnityAds.SetPrivacyConsent("user_privacy_data", true);

		// Chartboost setup example
		Chartboost.SetConsent(true);

		// DT Exchange setup example
		DTExchange.SetGDPRConsent(true);
		DTExchange.SetGDPRConsentString("consent_string_example");
		DTExchange.SetCCPAString("1YNN");
	}

	private void _OnGetInitializationStatusPressed()
	{
		var status = PoingStudios.AdMob.Api.MobileAds.GetInitializationStatus();
		if (status != null)
			LogAdapterStatus(status);
	}

	private void LogAdapterStatus(InitializationStatus status)
	{
		foreach (var (adapterName, adapterStatus) in status.AdapterStatusMap)
		{
			var info = $"[{adapterName}] State: {adapterStatus.State} | Latency: {adapterStatus.Latency}ms | Desc: {adapterStatus.Description}";
			LogMessage(info);
		}
	}
}

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
using PoingStudios.AdMob.Mediation.Extras.AdColony;
using PoingStudios.AdMob.Mediation.Extras.Meta;
using PoingStudios.AdMob.Mediation.Extras.Vungle;
using PoingStudios.AdMob.Sample;

public partial class MainCSharpExample : Control, ISampleLogger
{
	private RichTextLabel _consoleOutput;

	public override async void _Ready()
	{
		_consoleOutput = GetNode<RichTextLabel>("Background/SafeArea/LayoutContainer/ConsolePanel/ConsoleOutput");

		var mainTabs = GetNode<TabContainer>("Background/SafeArea/LayoutContainer/TabContent/MainTabs");
		
		SampleRegistry.Logger = this;
		LogMessage("Main initialized");

		InitializeMobileAds();

		// Workaround for TabContainer headers not showing up on start in Godot 4
		// We wait for a couple of frames to ensure the layout and theme are fully applied
		await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame);
		await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame);
		mainTabs.TabsVisible = false;
		mainTabs.TabsVisible = true;
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
		// AdColony setup example
		var adColonyOptions = new AdColonyAppOptions();
		adColonyOptions.SetPrivacyConsentString(AdColonyAppOptions.Ccpa, "OPTED_OUT");
		adColonyOptions.SetPrivacyFrameworkRequired(AdColonyAppOptions.Ccpa, false);
		adColonyOptions.SetTestMode(false);

		// Vungle setup example
		Vungle.UpdateCcpaStatus(Vungle.Consent.OptedOut);
		Vungle.UpdateConsentStatus(Vungle.Consent.OptedIn, "consent_message");
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

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
using PoingStudios.AdMob.Ump.Api;
using PoingStudios.AdMob.Ump.Core;
using PoingStudios.AdMob.Sample;

public partial class Ump : BaseTab
{
	public override void _Ready()
	{
		base._Ready();
		GetNode<Button>("GetConsentStatus").Pressed += OnGetConsentStatusPressed;
		GetNode<Button>("ResetConsentInformation").Pressed += OnResetConsentPressed;
		GetNode<Button>("ShowPrivacyOptionsForm").Pressed += OnShowPrivacyOptionsFormPressed;
		GetNode<Button>("ReadConsentPreferences").Pressed += OnReadConsentPreferencesPressed;
		GetNode<Button>("TestApplicationPreferences").Pressed += OnTestApplicationPreferencesPressed;
	}

	private void OnGetConsentStatusPressed()
	{
		var info = UserMessagingPlatform.ConsentInformation;
		Log($"Current Consent Status: {info.GetConsentStatus()}");
		Log($"Privacy Options Requirement Status: {info.GetPrivacyOptionsRequirementStatus()}");
	}

	private void OnShowPrivacyOptionsFormPressed()
	{
		Log("Showing privacy options form...");
		UserMessagingPlatform.ShowPrivacyOptionsForm(err =>
			Log(err == null ? "Privacy options form dismissed successfully." : $"Privacy options form error: {err.Message}"));
	}

	private void OnResetConsentPressed()
	{
		Log("Resetting consent information...");
		var info = UserMessagingPlatform.ConsentInformation;
		info.Reset();

		var parameters = new ConsentRequestParameters
		{
			ConsentDebugSettings = new ConsentDebugSettings
			{
				DebugGeography = DebugGeography.Eea,
				TestDeviceHashedIds = new System.Collections.Generic.List<string> { "test_device_hashed_id" },
			},
		};

		info.Update(parameters,
			onSuccess: () =>
			{
				Log($"Consent info updated. Status: {info.GetConsentStatus()}");
				if (info.GetIsConsentFormAvailable())
				{
					Log("Consent form available, loading...");
					UserMessagingPlatform.LoadConsentForm(
						onSuccess: form =>
						{
							Log("Form loaded. Showing...");
							form.Show(err =>
								Log(err == null ? "Form dismissed." : $"Form error: {err.Message}"));
						},
						onFailure: err => Log($"Form load error: {err.Message}")
					);
				}
			},
			onFailure: err => Log($"Consent update error: {err.Message}")
		);
	}

	private void OnReadConsentPreferencesPressed()
	{
		Log("--- Consent Preferences ---");
		string purposeConsents = ApplicationPreferences.GetString("IABTCF_PurposeConsents", "None");
		string gppString = ApplicationPreferences.GetString("IABGPP_HDR_GppString", "None");
		string gppSid = ApplicationPreferences.GetString("IABGPP_GppSID", "None");
		bool cookiesConsent = ApplicationPreferences.GetBoolean("gad_has_consent_for_cookies", false);

		Log($"IABTCF_PurposeConsents: {purposeConsents}");
		Log($"IABGPP_HDR_GppString: {gppString}");
		Log($"IABGPP_GppSID: {gppSid}");
		Log($"gad_has_consent_for_cookies: {cookiesConsent}");
	}

	private void OnTestApplicationPreferencesPressed()
	{
		Log("Testing ApplicationPreferences write/read...");
		ApplicationPreferences.SetString("test_string_key", "GodotAdMob");
		ApplicationPreferences.SetInt("test_int_key", 2026);
		ApplicationPreferences.SetBoolean("test_bool_key", true);

		string readStr = ApplicationPreferences.GetString("test_string_key", "");
		int readInt = ApplicationPreferences.GetInt("test_int_key", 0);
		bool readBool = ApplicationPreferences.GetBoolean("test_bool_key", false);

		Log($"Test Results -> String: {readStr} | Int: {readInt} | Bool: {readBool}");
	}

	private void Log(string message)
	{
		if (SampleRegistry.Logger != null)
			SampleRegistry.Logger.LogMessage("[UMP] " + message);
		else
			GD.Print("[UMP] " + message);
	}
}

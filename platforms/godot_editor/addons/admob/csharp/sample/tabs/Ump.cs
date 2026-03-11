// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using PoingStudios.AdMob.Ump.Api;
using PoingStudios.AdMob.Ump.Core;
using PoingStudios.AdMob.Sample;

public partial class Ump : VBoxContainer
{
	public override void _Ready()
	{
		GetNode<Button>("GetConsentStatus").Pressed += OnGetConsentStatusPressed;
		GetNode<Button>("ResetConsentInformation").Pressed += OnResetConsentPressed;
	}

	private void OnGetConsentStatusPressed()
	{
		var info = UserMessagingPlatform.ConsentInformation;
		Log($"Current Consent Status: {info.GetConsentStatus()}");
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

	private void Log(string message)
	{
		if (SampleRegistry.Logger != null)
			SampleRegistry.Logger.LogMessage("[UMP] " + message);
		else
			GD.Print("[UMP] " + message);
	}
}

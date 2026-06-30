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
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Sample;

public partial class MobileAds : BaseTab
{
	private CheckButton _iosPauseCheck;
	private CheckButton _muteMusicCheck;
	private AudioStreamPlayer _musicPlayer;
	private HSlider _adVolumeSlider;
	private CheckButton _adMutedCheck;
	private CheckButton _consentCookiesCheck;

	public override void _Ready()
	{
		base._Ready();

		_iosPauseCheck = GetNode<CheckButton>("iOSAppPause");
		_muteMusicCheck = GetNode<CheckButton>("MuteMusic");
		_musicPlayer = GetNode<AudioStreamPlayer>("MusicPlayer");
		_adVolumeSlider = GetNode<HSlider>("AdVolumeCard/AdVolumeContainer/AdVolumeSlider");
		_consentCookiesCheck = GetNode<CheckButton>("ConsentCookies");
		_adMutedCheck = GetNode<CheckButton>("AdMuted");

		_consentCookiesCheck.SetPressedNoSignal(PoingStudios.AdMob.Api.MobileAds.GetGadHasConsentForCookies());

		_iosPauseCheck.Toggled += OnSetIosAppPausePressed;
		_muteMusicCheck.Toggled += OnMuteMusicPressed;
		_adVolumeSlider.ValueChanged += OnAdVolumeChanged;
		_consentCookiesCheck.Toggled += OnConsentCookiesToggled;
		_adMutedCheck.Toggled += OnAdMutedPressed;

		var initBtn = GetNode<Button>("GetInitStatus");
		initBtn.Pressed += OnGetInitializationStatusPressed;

		var openAdInspectorBtn = GetNode<Button>("OpenAdInspector");
		openAdInspectorBtn.Pressed += OnOpenAdInspectorPressed;

		var langBtn = GetNode<OptionButton>("LanguageCard/LanguageContainer/LanguageButton");
		langBtn.AddItem("English", 0);
		langBtn.SetItemMetadata(0, "en");
		langBtn.AddItem("Português (Brasil)", 1);
		langBtn.SetItemMetadata(1, "pt_BR");
		langBtn.AddItem("Español", 2);
		langBtn.SetItemMetadata(2, "es");
		langBtn.AddItem("简体中文", 3);
		langBtn.SetItemMetadata(3, "zh_CN");
		langBtn.AddItem("日本語", 4);
		langBtn.SetItemMetadata(4, "ja");

		var currentLocale = TranslationServer.GetLocale();
		var config = new ConfigFile();
		if (config.Load(SampleRegistry.SettingsPath) == Error.Ok)
		{
			currentLocale = (string)config.GetValue(SampleRegistry.LocalizationSection, SampleRegistry.LocaleKey, currentLocale);
		}

		if (currentLocale.StartsWith("pt"))
		{
			langBtn.Selected = 1;
		}
		else if (currentLocale.StartsWith("es"))
		{
			langBtn.Selected = 2;
		}
		else if (currentLocale.StartsWith("zh"))
		{
			langBtn.Selected = 3;
		}
		else if (currentLocale.StartsWith("ja"))
		{
			langBtn.Selected = 4;
		}
		else
		{
			langBtn.Selected = 0;
		}

		langBtn.ItemSelected += OnLanguageSelected;
	}

	private void OnLanguageSelected(long index)
	{
		var langBtn = GetNode<OptionButton>("LanguageCard/LanguageContainer/LanguageButton");
		string locale = (string)langBtn.GetItemMetadata((int)index);
		Log(string.Format("Changing language to: {0}", locale));
		TranslationServer.SetLocale(locale);

		var config = new ConfigFile();
		config.Load(SampleRegistry.SettingsPath);
		config.SetValue(SampleRegistry.LocalizationSection, SampleRegistry.LocaleKey, locale);
		config.Save(SampleRegistry.SettingsPath);
	}

	private void OnGetInitializationStatusPressed()
	{
		var status = PoingStudios.AdMob.Api.MobileAds.GetInitializationStatus();
		if (status != null)
		{
			LogAdapterStatus(status);
		}
	}

	private void LogAdapterStatus(InitializationStatus status)
	{
		foreach (var adapterName in status.AdapterStatusMap.Keys)
		{
			var adapterStatus = status.AdapterStatusMap[adapterName];
			Log(string.Format("[{0}] State: {1} | Latency: {2}ms | Desc: {3}", adapterName, adapterStatus.State, adapterStatus.Latency, adapterStatus.Description));
		}
	}

	private void OnSetIosAppPausePressed(bool isEnabled)
	{
		Log(string.Format("Setting iOS App Pause on Background: {0}", isEnabled));
		PoingStudios.AdMob.Api.MobileAds.SetIosAppPauseOnBackground(isEnabled);
	}

	private void OnMuteMusicPressed(bool isMuted)
	{
		Log(string.Format("Muting music: {0}", isMuted));
		_musicPlayer.StreamPaused = isMuted;
	}

	private void OnAdVolumeChanged(double value)
	{
		Log(string.Format("Setting ad volume: {0}", value));
		PoingStudios.AdMob.Api.MobileAds.SetAppVolume((float)value);
	}

	private void OnConsentCookiesToggled(bool isEnabled)
	{
		Log(string.Format("Setting consent for cookies: {0}", isEnabled));
		PoingStudios.AdMob.Api.MobileAds.SetGadHasConsentForCookies(isEnabled);
	}

	private void OnAdMutedPressed(bool isMuted)
	{
		Log(string.Format("Muting ads: {0}", isMuted));
		PoingStudios.AdMob.Api.MobileAds.SetAppMuted(isMuted);
	}

	private void OnOpenAdInspectorPressed()
	{
		Log("Opening Ad Inspector...");
		var listener = new AdInspectorClosedListener
		{
			OnAdInspectorClosed = (error) =>
			{
				if (error.Count == 0)
				{
					Log("Ad Inspector closed. Result: OK");
				}
				else
				{
					Log(string.Format("Ad Inspector closed. Error code: {0} | message: {1} | domain: {2}",
						error.ContainsKey("code") ? error["code"] : -1,
						error.ContainsKey("message") ? (string)error["message"] : "",
						error.ContainsKey("domain") ? (string)error["domain"] : ""));
				}
			}
		};
		PoingStudios.AdMob.Api.MobileAds.OpenAdInspector(listener);
	}

	private void Log(string message)
	{
		if (SampleRegistry.Logger != null)
			SampleRegistry.Logger.LogMessage("[MobileAds] " + message);
		else
			GD.Print("[MobileAds] " + message);
	}
}

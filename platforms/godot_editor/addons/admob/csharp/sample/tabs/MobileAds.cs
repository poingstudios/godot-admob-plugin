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
using PoingStudios.AdMob.Sample;

public partial class MobileAds : VBoxContainer
{
	private CheckButton _iosPauseCheck;
	private CheckButton _muteMusicCheck;
	private AudioStreamPlayer _musicPlayer;
	private HSlider _adVolumeSlider;
	private CheckButton _adMutedCheck;

	public override void _Ready()
	{
		_iosPauseCheck = GetNode<CheckButton>("iOSAppPause");
		_muteMusicCheck = GetNode<CheckButton>("MuteMusic");
		_musicPlayer = GetNode<AudioStreamPlayer>("MusicPlayer");
		_adVolumeSlider = GetNode<HSlider>("AdVolumeContainer/AdVolumeSlider");
		_adMutedCheck = GetNode<CheckButton>("AdMuted");

		_iosPauseCheck.Toggled += OnSetIosAppPausePressed;
		_muteMusicCheck.Toggled += OnMuteMusicPressed;
		_adVolumeSlider.ValueChanged += OnAdVolumeChanged;
		_adMutedCheck.Toggled += OnAdMutedPressed;

		var initBtn = GetNode<Button>("GetInitStatus");
		initBtn.Pressed += OnGetInitializationStatusPressed;
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
			Log($"[{adapterName}] State: {adapterStatus.State} | Latency: {adapterStatus.Latency}ms | Desc: {adapterStatus.Description}");
		}
	}

	private void OnSetIosAppPausePressed(bool isEnabled)
	{
		Log("Setting iOS App Pause on Background: " + isEnabled);
		PoingStudios.AdMob.Api.MobileAds.SetIosAppPauseOnBackground(isEnabled);
	}

	private void OnMuteMusicPressed(bool isMuted)
	{
		Log("Muting music: " + isMuted);
		_musicPlayer.StreamPaused = isMuted;
	}

	private void OnAdVolumeChanged(double value)
	{
		Log("Setting ad volume: " + value);
		PoingStudios.AdMob.Api.MobileAds.SetAppVolume((float)value);
	}

	private void OnAdMutedPressed(bool isMuted)
	{
		Log("Muting ads: " + isMuted);
		PoingStudios.AdMob.Api.MobileAds.SetAppMuted(isMuted);
	}

	private void Log(string message)
	{
		if (SampleRegistry.Logger != null)
			SampleRegistry.Logger.LogMessage("[MobileAds] " + message);
		else
			GD.Print("[MobileAds] " + message);
	}
}

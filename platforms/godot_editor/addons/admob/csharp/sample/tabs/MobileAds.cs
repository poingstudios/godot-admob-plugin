// MIT License
// Copyright (c) 2023-present Poing Studios

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

		_iosPauseCheck.Pressed += OnSetIosAppPausePressed;
		_muteMusicCheck.Pressed += OnMuteMusicPressed;
		_adVolumeSlider.ValueChanged += OnAdVolumeChanged;
		_adMutedCheck.Pressed += OnAdMutedPressed;
	}

	private void OnSetIosAppPausePressed()
	{
		var isEnabled = _iosPauseCheck.ButtonPressed;
		Log("Setting iOS App Pause on Background: " + isEnabled);
		PoingStudios.AdMob.Api.MobileAds.SetIosAppPauseOnBackground(isEnabled);
	}

	private void OnMuteMusicPressed()
	{
		var isMuted = _muteMusicCheck.ButtonPressed;
		Log("Muting music: " + isMuted);
		_musicPlayer.StreamPaused = isMuted;
	}

	private void OnAdVolumeChanged(double value)
	{
		Log("Setting ad volume: " + value);
		PoingStudios.AdMob.Api.MobileAds.SetAppVolume((float)value);
	}

	private void OnAdMutedPressed()
	{
		var isMuted = _adMutedCheck.ButtonPressed;
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

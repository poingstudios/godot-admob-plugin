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

public partial class Banner : VBoxContainer
{
	private const string AdUnitIdAndroid = "ca-app-pub-3940256099942544/6300978111";
	private const string AdUnitIdIos = "ca-app-pub-3940256099942544/2934735716";

	private string AdUnitId => OS.GetName() == "iOS" ? AdUnitIdIos : AdUnitIdAndroid;

	private AdView _adView;
	private AdPosition _currentPosition = AdPosition.Bottom;

	private Button _loadBtn;
	private Button _destroyBtn;
	private Button _showBtn;
	private Button _hideBtn;
	private Button _getSizeBtn;

	public override void _Ready()
	{
		_loadBtn = GetNode<Button>("LoadBanner");
		_destroyBtn = GetNode<Button>("DestroyBanner");
		_showBtn = GetNode<Button>("ShowBanner");
		_hideBtn = GetNode<Button>("HideBanner");
		_getSizeBtn = GetNode<Button>("GetSize");

		_loadBtn.Pressed += OnLoadPressed;
		_destroyBtn.Pressed += OnDestroyPressed;
		_showBtn.Pressed += OnShowPressed;
		_hideBtn.Pressed += OnHidePressed;
		_getSizeBtn.Pressed += OnGetSizePressed;

		var grid = GetNode<GridContainer>("PositionCard/VBox/PositionGrid");
		grid.GetNode<Button>("TOP_LEFT").Pressed += () => SetPosition(AdPosition.TopLeft);
		grid.GetNode<Button>("TOP").Pressed += () => SetPosition(AdPosition.Top);
		grid.GetNode<Button>("TOP_RIGHT").Pressed += () => SetPosition(AdPosition.TopRight);
		grid.GetNode<Button>("LEFT").Pressed += () => SetPosition(AdPosition.Left);
		grid.GetNode<Button>("CENTER").Pressed += () => SetPosition(AdPosition.Center);
		grid.GetNode<Button>("RIGHT").Pressed += () => SetPosition(AdPosition.Right);
		grid.GetNode<Button>("BOTTOM_LEFT").Pressed += () => SetPosition(AdPosition.BottomLeft);
		grid.GetNode<Button>("BOTTOM").Pressed += () => SetPosition(AdPosition.Bottom);
		grid.GetNode<Button>("BOTTOM_RIGHT").Pressed += () => SetPosition(AdPosition.BottomRight);
	}

	private void UpdateUI(bool isLoaded)
	{
		_loadBtn.Disabled = isLoaded;
		_destroyBtn.Disabled = !isLoaded;
		_showBtn.Disabled = !isLoaded;
		_hideBtn.Disabled = !isLoaded;
		_getSizeBtn.Disabled = !isLoaded;
	}

	private void SetPosition(AdPosition pos)
	{
		_currentPosition = pos;
		Log($"Position updated to: {pos}");
		if (_adView != null) OnLoadPressed();
	}

	private void OnLoadPressed()
	{
		DestroyAd();
		UpdateUI(false);
		Log("Loading adaptive banner...");

		var size = AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
		_adView = new AdView(AdUnitId, size, _currentPosition);
		_adView.AdListener = new AdListener
		{
			OnAdLoaded = () =>
			{
				Log("Ad loaded successfully");
				UpdateUI(true);
				SampleRegistry.SafeArea?.UpdateAdOverlap(_adView);
			},
			OnAdFailedToLoad = err => 
			{ 
				Log($"Failed to load: {err.Message}"); 
				UpdateUI(false); 
				SampleRegistry.SafeArea?.ResetAdOverlap();
			},
			OnAdClicked = () => Log("Ad clicked"),
			OnAdOpened = () => Log("Ad opened"),
			OnAdClosed = () => 
			{ 
				Log("Ad closed"); 
				SampleRegistry.SafeArea?.ResetAdOverlap();
			},
			OnAdImpression = () => Log("Impression recorded"),
		};
		_adView.LoadAd(new AdRequest());
	}

	private void OnShowPressed() 
	{ 
		_adView?.Show(); 
		Log("Banner shown"); 
		SampleRegistry.SafeArea?.UpdateAdOverlap(_adView);
	}

	private void OnHidePressed() 
	{ 
		_adView?.Hide(); 
		Log("Banner hidden"); 
		SampleRegistry.SafeArea?.ResetAdOverlap();
	}

	private void OnDestroyPressed()
	{
		DestroyAd();
		Log("Banner destroyed");
		UpdateUI(false);
		SampleRegistry.SafeArea?.ResetAdOverlap();
	}

	private void OnGetSizePressed()
	{
		if (_adView != null)
			Log($"W: {_adView.GetWidth()}, H: {_adView.GetHeight()} | Pixels: {_adView.GetWidthInPixels()}x{_adView.GetHeightInPixels()}");
	}

	private void DestroyAd()
	{
		_adView?.Destroy();
		_adView = null;
	}

	private void Log(string message)
	{
		if (SampleRegistry.Logger != null)
			SampleRegistry.Logger.LogMessage("[Banner] " + message);
		else
			GD.Print("[Banner] " + message);
	}
}

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
using PoingStudios.AdMob.Sample;

public partial class Banner : BaseTab
{
	private const string AdUnitIdAndroid = "ca-app-pub-3940256099942544/6300978111";
	private const string AdUnitIdIos = "ca-app-pub-3940256099942544/2934735716";

	private string AdUnitId => OS.GetName() == "iOS" ? AdUnitIdIos : AdUnitIdAndroid;

	private AdView _adView;
	private AdPosition _adPosition = AdPosition.Top;
	private bool _isHidden = false;

	private Button _loadBtn;
	private Button _loadBackgroundBtn;
	private Button _destroyBtn;
	private Button _showBtn;
	private Button _hideBtn;
	private Button _getSizeBtn;
	private CheckButton _collapsibleToggle;

	private LineEdit _xValue;
	private LineEdit _yValue;
	private OptionButton _sizeOption;
	private HBoxContainer _customSize;
	private LineEdit _widthValue;
	private LineEdit _heightValue;

	private enum Preset
	{
		Adaptive,
		Banner,
		FullBanner,
		LargeBanner,
		Leaderboard,
		MediumRectangle,
		WideSkyscraper,
		Custom
	}

	public override void _Ready()
	{
		base._Ready();
		_loadBtn = GetNode<Button>("%BannerActions/LoadBanner");
		_loadBackgroundBtn = GetNode<Button>("%BannerActions/LoadBannerBackground");
		_destroyBtn = GetNode<Button>("%BannerActions/DestroyBanner");
		_showBtn = GetNode<Button>("%BannerActions/ShowBanner");
		_hideBtn = GetNode<Button>("%BannerActions/HideBanner");
		_getSizeBtn = GetNode<Button>("%BannerActions/GetSize");
		_collapsibleToggle = GetNode<CheckButton>("%Collapsible");
		_sizeOption = GetNode<OptionButton>("%SizeOption");
		_customSize = GetNode<HBoxContainer>("%CustomSize");
		_widthValue = GetNode<LineEdit>("%WidthValue");
		_heightValue = GetNode<LineEdit>("%HeightValue");

		_sizeOption.ItemSelected += (index) =>
		{
			_customSize.Visible = index == (int)Preset.Custom;
		};

		_loadBtn.Pressed += OnLoadPressed;
		_loadBackgroundBtn.Pressed += OnLoadBackgroundPressed;
		_destroyBtn.Pressed += OnDestroyPressed;
		_showBtn.Pressed += OnShowPressed;
		_hideBtn.Pressed += OnHidePressed;
		_getSizeBtn.Pressed += OnGetSizePressed;

		_xValue = GetNode<LineEdit>("%XValue");
		_yValue = GetNode<LineEdit>("%YValue");
		
		_xValue.TextSubmitted += _ => OnApplyCustomPressed();
		_yValue.TextSubmitted += _ => OnApplyCustomPressed();

		var applyCustomBtn = GetNode<Button>("CustomCard/VBox/HBox/ApplyCustom");
		applyCustomBtn.Pressed += OnApplyCustomPressed;

		var grid = GetNode<GridContainer>("PositionCard/VBox/PositionGrid");
		grid.GetNode<Button>("TOP_LEFT").Pressed += () => UpdatePosition(AdPosition.TopLeft);
		grid.GetNode<Button>("TOP").Pressed += () => UpdatePosition(AdPosition.Top);
		grid.GetNode<Button>("TOP_RIGHT").Pressed += () => UpdatePosition(AdPosition.TopRight);
		grid.GetNode<Button>("LEFT").Pressed += () => UpdatePosition(AdPosition.Left);
		grid.GetNode<Button>("CENTER").Pressed += () => UpdatePosition(AdPosition.Center);
		grid.GetNode<Button>("RIGHT").Pressed += () => UpdatePosition(AdPosition.Right);
		grid.GetNode<Button>("BOTTOM_LEFT").Pressed += () => UpdatePosition(AdPosition.BottomLeft);
		grid.GetNode<Button>("BOTTOM").Pressed += () => UpdatePosition(AdPosition.Bottom);
		grid.GetNode<Button>("BOTTOM_RIGHT").Pressed += () => UpdatePosition(AdPosition.BottomRight);



		UpdateUI(false);
	}

	private void UpdateUI(bool isLoaded)
	{
		_loadBtn.Disabled = isLoaded;
		_loadBackgroundBtn.Disabled = isLoaded;
		_destroyBtn.Disabled = !isLoaded;
		_getSizeBtn.Disabled = !isLoaded;

		_showBtn.Disabled = !(isLoaded && _isHidden);
		_hideBtn.Disabled = !(isLoaded && !_isHidden);

	}

	private void UpdatePosition(AdPosition pos)
	{
		_adPosition = pos;
		Log("Position updated");
		if (_adView != null) 
		{
			_adView.SetPosition(pos);
			if (!_isHidden)
			{
				SampleRegistry.SafeArea?.UpdateAdOverlap(_adView);
			}
		}
	}

	private void OnApplyCustomPressed()
	{
		if (int.TryParse(_xValue.Text, out int x) && int.TryParse(_yValue.Text, out int y))
		{
			Log($"Applying custom position: ({x}, {y})");
			UpdatePosition(AdPosition.Custom(x, y));
			if (DisplayServer.HasFeature(DisplayServer.Feature.VirtualKeyboard))
			{
				DisplayServer.VirtualKeyboardHide();
			}
		}
	}

	private string GetAdUnitId(bool isCollapsible = false)
	{
		if (isCollapsible)
		{
			return OS.GetName() == "iOS" ? "ca-app-pub-3940256099942544/8388050270" : "ca-app-pub-3940256099942544/2014213617";
		}
		return OS.GetName() == "iOS" ? AdUnitIdIos : AdUnitIdAndroid;
	}

	private AdSize GetSelectedAdSize()
	{
		switch ((Preset)_sizeOption.Selected)
		{
			case Preset.Adaptive: return AdSize.GetCurrentOrientationAnchoredAdaptiveBannerAdSize(AdSize.FullWidth);
			case Preset.Banner: return AdSize.Banner;
			case Preset.FullBanner: return AdSize.FullBanner;
			case Preset.LargeBanner: return AdSize.LargeBanner;
			case Preset.Leaderboard: return AdSize.Leaderboard;
			case Preset.MediumRectangle: return AdSize.MediumRectangle;
			case Preset.WideSkyscraper: return AdSize.WideSkyscraper;
			case Preset.Custom:
				if (int.TryParse(_widthValue.Text, out int w) && int.TryParse(_heightValue.Text, out int h))
				{
					return new AdSize(w, h);
				}
				return AdSize.Banner;
			default: return AdSize.Banner;
		}
	}

	private void LoadBanner(bool hideImmediately)
	{
		DestroyAd();
		UpdateUI(false);
		bool isCollapsibleRequest = _collapsibleToggle.ButtonPressed;
		AdSize size = GetSelectedAdSize();

		Log($"Loading banner ({_sizeOption.GetItemText(_sizeOption.Selected)}){(hideImmediately ? " in background" : string.Empty)}{(isCollapsibleRequest ? " (collapsible)" : string.Empty)}...");

		_adView = new AdView(GetAdUnitId(isCollapsibleRequest), size, _adPosition);
		_isHidden = hideImmediately;
		UpdateUI(false);

		if (_isHidden)
		{
			_adView.Hide();
		}

		_adView.AdListener = new AdListener
		{
			OnAdLoaded = () =>
			{
				bool isCollapsible = _adView.IsCollapsible();
				if (isCollapsible)
				{
					Log("Success: Collapsible banner loaded.");
				}
				else
				{
					Log("Ad loaded successfully. Collapsible: false");
				}
				UpdateUI(true);
				if (!_isHidden)
				{
					SampleRegistry.SafeArea?.UpdateAdOverlap(_adView);
				}
			},
			OnAdFailedToLoad = err => 
			{ 
				Log($"Failed to load: {err.Message}"); 
				UpdateUI(false); 
				SampleRegistry.SafeArea?.ResetAdOverlap();
			},
			OnAdClicked = () => Log("Ad clicked"),
			OnAdOpened = () => 
			{
				Log("Ad opened");
				SampleRegistry.SafeArea?.UpdateAdOverlap(_adView);
			},
			OnAdClosed = () => 
			{ 
				Log("Ad closed callback triggered"); 
				var height = _adView != null ? _adView.GetHeightInPixels() : 0;
				Log($"Ad closed height: {height}");
				if (height == 0)
				{
					if (_adView != null)
					{
						_adView.Destroy();
						_adView = null;
					}
					_isHidden = false;
					UpdateUI(false);
					SampleRegistry.SafeArea?.ResetAdOverlap();
				}
				else
				{
					SampleRegistry.SafeArea?.UpdateAdOverlap(_adView);
				}
			},
			OnAdImpression = () => Log("Impression recorded"),
		};
		_adView.OnAdPaid = adValue =>
		{
			string adSourceName = _adView?.GetResponseInfo()?.LoadedAdapterResponseInfo?.AdSourceName ?? "N/A";
			Log(string.Format("Ad paid: {0:F} {1} (precision: {2}, source: {3})", adValue.ValueMicros / 1000000.0, adValue.CurrencyCode, adValue.Precision, adSourceName));
		};

		var adRequest = new AdRequest();
		if (isCollapsibleRequest)
		{
			string collapsiblePos = _adPosition == AdPosition.Top ? "top" : "bottom";
			adRequest.Extras["collapsible"] = collapsiblePos;
			Log($"Requesting collapsible banner ({collapsiblePos})");
		}
		_adView.LoadAd(adRequest);
	}

	private void OnLoadPressed() => LoadBanner(false);
	private void OnLoadBackgroundPressed() => LoadBanner(true);

	private void OnShowPressed() 
	{ 
		if (_adView != null)
		{
			_isHidden = false;
			_adView.Show(); 
			Log("Banner shown"); 
			UpdateUI(true);
			SampleRegistry.SafeArea?.UpdateAdOverlap(_adView);
		}
	}

	private void OnHidePressed() 
	{ 
		if (_adView != null)
		{
			_isHidden = true;
			_adView.Hide(); 
			Log("Banner hidden"); 
			UpdateUI(true);
			SampleRegistry.SafeArea?.ResetAdOverlap();
		}
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

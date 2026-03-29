using System;
using Godot;
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;

namespace PoingStudios.AdMob.Sample
{
    public partial class Native : BaseTab
    {
        private NativeOverlayAd _nativeOverlayAd;
        private AdPosition _adPosition = AdPosition.Top;
        private bool _isHidden = false;

        private Button _loadButton;
        private Button _loadBackgroundButton;
        private Button _destroyButton;
        private Button _showButton;
        private Button _hideButton;
        private Button _getSizeButton;
        private LineEdit _xValue;
        private LineEdit _yValue;

        private OptionButton _templateType;
        private Button _mainBgButton;
        private Button _ctaBgButton;
        private Button _ctaTextButton;

        private Color _mainBgColor = new Color(1, 1, 1, 1);
        private Color _ctaBgColor = new Color(0.258824f, 0.521569f, 0.956863f, 1);
        private Color _ctaTextColor = new Color(1, 1, 1, 1);

        public override void _Ready()
        {
            base._Ready();

            _loadButton = GetNode<Button>("%LoadNative");
            _loadBackgroundButton = GetNode<Button>("%LoadNativeBackground");
            _destroyButton = GetNode<Button>("%DestroyNative");
            _showButton = GetNode<Button>("%ShowNative");
            _hideButton = GetNode<Button>("%HideNative");
            _getSizeButton = GetNode<Button>("%GetSize");
            _xValue = GetNode<LineEdit>("%XValue");
            _yValue = GetNode<LineEdit>("%YValue");

            _templateType = GetNode<OptionButton>("%TemplateType");
            _mainBgButton = GetNode<Button>("%MainBGButton");
            _ctaBgButton = GetNode<Button>("%CTABGButton");
            _ctaTextButton = GetNode<Button>("%CTATextButton");

            _mainBgButton.Pressed += OnMainBgButtonPressed;
            _ctaBgButton.Pressed += OnCtaBgButtonPressed;
            _ctaTextButton.Pressed += OnCtaTextButtonPressed;

            UpdateUiState(false);
        }

        private void UpdateButtonColor(Button button, Color color)
        {
            string[] states = { "normal", "hover", "pressed" };
            foreach (var state in states)
            {
                var style = (StyleBoxFlat)button.GetThemeStylebox(state).Duplicate();
                style.BgColor = color;
                button.AddThemeStyleboxOverride(state, style);
            }
        }

        private void ShowColorPopup(Color currentColor, Action<Color> callback)
        {
            var popup = new PopupPanel();
            var picker = new ColorPicker();
            picker.Color = currentColor;
            picker.EditAlpha = false;
            picker.CustomMinimumSize = new Vector2(300, 400);
            popup.AddChild(picker);
            AddChild(popup);
            popup.PopupCentered();
            picker.ColorChanged += (color) => callback(color);
            popup.PopupHide += () => popup.QueueFree();
        }

        private void OnMainBgButtonPressed()
        {
            ShowColorPopup(_mainBgColor, (color) =>
            {
                _mainBgColor = color;
                UpdateButtonColor(_mainBgButton, color);
            });
        }

        private void OnCtaBgButtonPressed()
        {
            ShowColorPopup(_ctaBgColor, (color) =>
            {
                _ctaBgColor = color;
                UpdateButtonColor(_ctaBgButton, color);
            });
        }

        private void OnCtaTextButtonPressed()
        {
            ShowColorPopup(_ctaTextColor, (color) =>
            {
                _ctaTextColor = color;
                UpdateButtonColor(_ctaTextButton, color);
            });
        }

        private void UpdateUiState(bool isLoaded)
        {
            _loadButton.Disabled = isLoaded;
            _loadBackgroundButton.Disabled = isLoaded;
            _showButton.Disabled = !isLoaded;
            _hideButton.Disabled = !isLoaded;
            _destroyButton.Disabled = !isLoaded;
            _getSizeButton.Disabled = !isLoaded;
        }

        private string GetAdUnitId()
        {
            return OS.GetName() == "Android" ? "ca-app-pub-3940256099942544/2247696110" : "ca-app-pub-3940256099942544/3986624511";
        }

        private void LoadNative(bool hideImmediately = false)
        {
            if (_nativeOverlayAd != null)
            {
                _nativeOverlayAd.Destroy();
                _nativeOverlayAd = null;
            }

            UpdateUiState(false);
            Log($"Loading native ad{(hideImmediately ? " in background" : string.Empty)}...");

            _isHidden = hideImmediately;

            var options = new NativeAdOptions
            {
                AdChoicesPlacement = AdChoicesPlacement.TopRight,
                MediaAspectRatio = NativeMediaAspectRatio.Any
            };

            NativeOverlayAd.Load(GetAdUnitId(), new AdRequest(), options, OnAdLoadFinished);
        }

        private void OnAdLoadFinished(NativeOverlayAd ad, LoadAdError error)
        {
            if (error != null)
            {
                Log("Failed to load: " + error.Message);
                UpdateUiState(false);
                return;
            }

            Log("Ad loaded successfully");
            _nativeOverlayAd = ad;

            _nativeOverlayAd.AdListener.OnAdClicked = () => Log("Ad clicked");
            _nativeOverlayAd.AdListener.OnAdClosed = () => Log("Ad closed");
            _nativeOverlayAd.AdListener.OnAdImpression = () => Log("Ad impression recorded");
            _nativeOverlayAd.AdListener.OnAdOpened = () => Log("Ad opened");
            _nativeOverlayAd.OnAdPaid = adValue =>
            {
                string adSourceName = _nativeOverlayAd?.GetResponseInfo()?.LoadedAdapterResponseInfo?.AdSourceName ?? "N/A";
                Log(string.Format("Ad paid: {0:F} {1} (precision: {2}, source: {3})", adValue.ValueMicros / 1000000.0, adValue.CurrencyCode, adValue.Precision, adSourceName));
            };

            var style = new NativeTemplateStyle
            {
                TemplateId = _templateType.Selected == 0 ? NativeTemplateStyle.Small : NativeTemplateStyle.Medium,
                MainBackgroundColor = _mainBgColor,
                CallToActionText = new NativeTemplateTextStyle
                {
                    BackgroundColor = _ctaBgColor,
                    TextColor = _ctaTextColor,
                    FontSize = 15,
                    Style = NativeTemplateFontStyle.Bold
                }
            };

            _nativeOverlayAd.RenderTemplate(style, _adPosition);

            if (_isHidden)
            {
                _nativeOverlayAd.Hide();
            }

            UpdateUiState(true);
        }

        public void _on_load_native_pressed() => LoadNative(false);
        public void _on_load_native_background_pressed() => LoadNative(true);

        public void _on_destroy_native_pressed()
        {
            if (_nativeOverlayAd != null)
            {
                _nativeOverlayAd.Destroy();
                _nativeOverlayAd = null;
                Log("Native destroyed");
                UpdateUiState(false);
            }
        }

        public void _on_show_native_pressed()
        {
            if (_nativeOverlayAd != null)
            {
                _isHidden = false;
                _nativeOverlayAd.Show();
                Log("Native shown");
            }
        }

        public void _on_hide_native_pressed()
        {
            if (_nativeOverlayAd != null)
            {
                _isHidden = true;
                _nativeOverlayAd.Hide();
                Log("Native hidden");
            }
        }

        public void _on_get_size_pressed()
        {
            if (_nativeOverlayAd != null)
            {
                var info = $"W: {_nativeOverlayAd.GetTemplateWidthInPixels():F1}, H: {_nativeOverlayAd.GetTemplateHeightInPixels():F1}";
                Log(info);
            }
        }

        private void UpdatePosition(AdPosition pos)
        {
            _adPosition = pos;
            _nativeOverlayAd?.SetTemplatePosition(pos);
        }

        private void OnPositionSelected(AdPosition pos)
        {
            Log("Updating position to: " + pos.Value.ToString());
            UpdatePosition(pos);
        }

        public void _on_apply_custom_pressed()
        {
            int x = _xValue.Text.ToInt();
            int y = _yValue.Text.ToInt();
            Log($"Applying custom position: ({x}, {y})");
            UpdatePosition(AdPosition.Custom(x, y));
            DisplayServer.VirtualKeyboardHide();
        }

        private void Log(string message)
        {
            SampleRegistry.Logger?.LogMessage("[Native] " + message);
        }

        public void _on_top_pressed() => OnPositionSelected(AdPosition.Top);
        public void _on_bottom_pressed() => OnPositionSelected(AdPosition.Bottom);
        public void _on_left_pressed() => OnPositionSelected(AdPosition.Left);
        public void _on_right_pressed() => OnPositionSelected(AdPosition.Right);
        public void _on_top_left_pressed() => OnPositionSelected(AdPosition.TopLeft);
        public void _on_top_right_pressed() => OnPositionSelected(AdPosition.TopRight);
        public void _on_bottom_left_pressed() => OnPositionSelected(AdPosition.BottomLeft);
        public void _on_bottom_right_pressed() => OnPositionSelected(AdPosition.BottomRight);
        public void _on_center_pressed() => OnPositionSelected(AdPosition.Center);
    }
}

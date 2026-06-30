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

namespace PoingStudios.AdMob.Core
{
	public partial class MockInterstitialAdPlugin : Node
	{
		[Signal] public delegate void on_interstitial_ad_clickedEventHandler(int uid);
		[Signal] public delegate void on_interstitial_ad_dismissed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_interstitial_ad_failed_to_show_full_screen_contentEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_interstitial_ad_impressionEventHandler(int uid);
		[Signal] public delegate void on_interstitial_ad_showed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_interstitial_ad_loadedEventHandler(int uid);
		[Signal] public delegate void on_interstitial_ad_failed_to_loadEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_interstitial_ad_paidEventHandler(int uid, Godot.Collections.Dictionary adValue);

		private class AdData
		{
			public Control Ui;
			public string AdUnitId;
		}

		private int _uidCounter = 0;
		private System.Collections.Generic.Dictionary<int, AdData> _ads = new System.Collections.Generic.Dictionary<int, AdData>();

		public override void _Ready()
		{
			((SceneTree)Engine.GetMainLoop()).Root.Connect(Window.SignalName.SizeChanged, new Callable(this, MethodName.OnWindowSizeChanged));
		}

		private void OnWindowSizeChanged()
		{
			foreach (var uid in _ads.Keys)
			{
				UpdateUi(uid);
			}
		}

		public int create()
		{
			_uidCounter++;
			int uid = _uidCounter;

			var ui = new ColorRect
			{
				Color = Colors.Black
			};
			ui.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ui.Hide();

			_ads[uid] = new AdData
			{
				Ui = ui
			};

			var canvas = new CanvasLayer
			{
				Layer = 100
			};
			canvas.AddChild(ui);
			AddChild(canvas);

			return uid;
		}

		public void load(string adUnitId, Godot.Collections.Dictionary adRequestDictionary, Godot.Collections.Array keywords, int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad)) return;
			ad.AdUnitId = adUnitId;

			var timer = ((SceneTree)Engine.GetMainLoop()).CreateTimer(0.5f);
			timer.Connect(SceneTreeTimer.SignalName.Timeout, Callable.From(() =>
			{
				EmitSignal(SignalName.on_interstitial_ad_loaded, uid);
			}));
		}

		public string get_ad_unit_id(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				return ad.AdUnitId ?? "";
			}
			return "";
		}

		private void UpdateUi(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad)) return;
			var ui = ad.Ui as ColorRect;
			if (ui == null || !IsInstanceValid(ui)) return;

			var viewport = GetViewport();
			if (viewport == null) return;
			var viewportSize = viewport.GetVisibleRect().Size;
			viewportSize.X = Mathf.Max(1f, viewportSize.X);
			viewportSize.Y = Mathf.Max(1f, viewportSize.Y);

			float scaleFactor = Mathf.Min(viewportSize.X / 360f, viewportSize.Y / 640f);
			if (scaleFactor <= 0.0f)
			{
				scaleFactor = 1.0f;
			}

			foreach (Node child in ui.GetChildren())
			{
				child.QueueFree();
			}

			ui.Color = Colors.Black;

			var mainVbox = new VBoxContainer();
			mainVbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			mainVbox.AddThemeConstantOverride("separation", 0);
			ui.AddChild(mainVbox);

			// 1. Top Bar (sits on the black background)
			var topMargin = new MarginContainer();
			topMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(16 * scaleFactor));
			topMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(16 * scaleFactor));
			topMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(16 * scaleFactor));
			topMargin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(8 * scaleFactor));
			mainVbox.AddChild(topMargin);

			var topControl = new Control();
			topControl.CustomMinimumSize = new Vector2(1, 40 * scaleFactor);
			topMargin.AddChild(topControl);

			var testAdPill = new Panel();
			testAdPill.CustomMinimumSize = new Vector2((int)Mathf.Round(65 * scaleFactor), (int)Mathf.Round(22 * scaleFactor));
			testAdPill.SetAnchorsPreset(Control.LayoutPreset.Center);
			testAdPill.GrowHorizontal = Control.GrowDirection.Both;
			testAdPill.GrowVertical = Control.GrowDirection.Both;
			var testAdPillStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.2f, 0.2f, 0.2f, 0.8f),
				CornerRadiusTopLeft = (int)Mathf.Round(4 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(4 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(4 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(4 * scaleFactor)
			};
			testAdPill.AddThemeStyleboxOverride("panel", testAdPillStyle);
			topControl.AddChild(testAdPill);

			var testAdLbl = new Label
			{
				Text = "Mock Ad",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			testAdLbl.AddThemeColorOverride("font_color", Colors.White);
			testAdLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			testAdLbl.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			testAdPill.AddChild(testAdLbl);

			var closeBtn = new Button();
			closeBtn.CustomMinimumSize = new Vector2((int)Mathf.Round(32 * scaleFactor), (int)Mathf.Round(32 * scaleFactor));
			closeBtn.SetAnchorsPreset(Control.LayoutPreset.CenterRight);
			closeBtn.GrowHorizontal = Control.GrowDirection.Begin;
			closeBtn.GrowVertical = Control.GrowDirection.Both;

			var closeStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.9f, 0.9f, 0.9f, 0.95f),
				CornerRadiusTopLeft = (int)Mathf.Round(16 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(16 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(16 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(16 * scaleFactor)
			};

			closeBtn.AddThemeStyleboxOverride("normal", closeStyle);
			closeBtn.AddThemeStyleboxOverride("hover", closeStyle);
			closeBtn.AddThemeStyleboxOverride("pressed", closeStyle);
			closeBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			topControl.AddChild(closeBtn);

			var closeIcon = new Label
			{
				Text = "X",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			closeIcon.AddThemeColorOverride("font_color", new Color(0.1f, 0.1f, 0.1f));
			closeIcon.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactor)));
			closeIcon.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			closeBtn.AddChild(closeIcon);

			closeBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				ui.Hide();
				EmitSignal(SignalName.on_interstitial_ad_dismissed_full_screen_content, uid);
			}));

			// Spacer above the card to center it vertically
			var spacerTop = new Control();
			spacerTop.SizeFlagsVertical = Control.SizeFlags.ExpandFill;
			mainVbox.AddChild(spacerTop);

			// 2. Central White Card (full width, flat white, centered vertically)
			var cardRect = new ColorRect
			{
				Color = Colors.White,
				SizeFlagsHorizontal = Control.SizeFlags.ExpandFill
			};
			float cardHeight = Mathf.Min(420 * scaleFactor, viewportSize.Y - (140 * scaleFactor));
			cardRect.CustomMinimumSize = new Vector2(1, cardHeight);
			mainVbox.AddChild(cardRect);

			var cardMargin = new MarginContainer();
			cardMargin.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			cardMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(24 * scaleFactor));
			cardMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(24 * scaleFactor));
			cardMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(24 * scaleFactor));
			cardMargin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(24 * scaleFactor));
			cardRect.AddChild(cardMargin);

			var contentVbox = new VBoxContainer();
			contentVbox.Alignment = BoxContainer.AlignmentMode.Center;
			contentVbox.AddThemeConstantOverride("separation", (int)Mathf.Round(24 * scaleFactor));
			cardMargin.AddChild(contentVbox);

			var adImage = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/format-interstitial.svg"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2(1, (int)Mathf.Round(160 * scaleFactor)),
				SizeFlagsVertical = Control.SizeFlags.ExpandFill
			};
			contentVbox.AddChild(adImage);

			var titleLbl = new Label
			{
				Text = "This is an\ninterstitial mock ad.",
				HorizontalAlignment = HorizontalAlignment.Center
			};
			titleLbl.AddThemeColorOverride("font_color", new Color(0.12f, 0.12f, 0.12f));
			titleLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(22 * scaleFactor)));
			contentVbox.AddChild(titleLbl);

			var spacer = new Control();
			spacer.CustomMinimumSize = new Vector2(1, (int)Mathf.Round(16 * scaleFactor));
			contentVbox.AddChild(spacer);

			var logoHbox = new HBoxContainer();
			logoHbox.Alignment = BoxContainer.AlignmentMode.Center;
			logoHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(8 * scaleFactor));
			contentVbox.AddChild(logoHbox);

			var admobLogo = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/icon-120.png"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2((int)Mathf.Round(24 * scaleFactor), (int)Mathf.Round(24 * scaleFactor)),
				SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
			};
			logoHbox.AddChild(admobLogo);

			var admobLbl = new Label
			{
				Text = "Google AdMob"
			};
			admobLbl.AddThemeColorOverride("font_color", new Color(0.35f, 0.35f, 0.35f));
			admobLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactor)));
			logoHbox.AddChild(admobLbl);

			// Spacer below the card to center it vertically
			var spacerBottom = new Control();
			spacerBottom.SizeFlagsVertical = Control.SizeFlags.ExpandFill;
			mainVbox.AddChild(spacerBottom);
		}

		public void show(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
			{
				UpdateUi(uid);
				ad.Ui.Show();
				EmitSignal(SignalName.on_interstitial_ad_showed_full_screen_content, uid);
				EmitSignal(SignalName.on_interstitial_ad_impression, uid);
			}
		}

		public void destroy(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				if (ad.Ui != null && IsInstanceValid(ad.Ui))
				{
					ad.Ui.GetParent().QueueFree();
				}
				_ads.Remove(uid);
			}
		}

		public Godot.Collections.Dictionary get_response_info(int uid)
		{
			return new Godot.Collections.Dictionary
			{
				{ "response_id", "mock_response_id" },
				{ "mediation_adapter_class_name", "MockAdapter" },
				{ "adapter_responses", new Godot.Collections.Dictionary() },
				{ "loaded_adapter_response_info", new Godot.Collections.Dictionary() },
				{ "response_extras", new Godot.Collections.Dictionary() }
			};
		}
	}
}


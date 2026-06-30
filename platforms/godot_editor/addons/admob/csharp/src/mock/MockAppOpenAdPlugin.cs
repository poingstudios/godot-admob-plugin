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
	public partial class MockAppOpenAdPlugin : Node
	{
		[Signal] public delegate void on_app_open_ad_clickedEventHandler(int uid);
		[Signal] public delegate void on_app_open_ad_dismissed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_app_open_ad_failed_to_show_full_screen_contentEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_app_open_ad_impressionEventHandler(int uid);
		[Signal] public delegate void on_app_open_ad_showed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_app_open_ad_loadedEventHandler(int uid);
		[Signal] public delegate void on_app_open_ad_failed_to_loadEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_app_open_ad_paidEventHandler(int uid, Godot.Collections.Dictionary adValue);

		private class AdData
		{
			public Control Ui;
			public string AdUnitId;
		}

		private int _uidCounter = 0;
		private System.Collections.Generic.Dictionary<int, AdData> _ads = new System.Collections.Generic.Dictionary<int, AdData>();

		public override void _Ready()
		{
			((SceneTree)Engine.GetMainLoop()).Root.Connect(Window.SignalName.SizeChanged, Callable.From(() =>
			{
				foreach (var uid in _ads.Keys)
				{
					_updateUi(uid);
				}
			}));
		}

		public int create()
		{
			_uidCounter++;
			int uid = _uidCounter;

			var ui = new ColorRect
			{
				Color = new Color(0.0f, 0.0f, 0.0f, 0.45f)
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
				EmitSignal(SignalName.on_app_open_ad_loaded, uid);
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

		private void _updateUi(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad) || ad.Ui == null || !IsInstanceValid(ad.Ui)) return;

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

			var children = ad.Ui.GetChildren();
			foreach (var child in children)
			{
				child.QueueFree();
			}

			((ColorRect)ad.Ui).Color = Colors.White;

			var mainVbox = new VBoxContainer();
			mainVbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			mainVbox.AddThemeConstantOverride("separation", 0);
			ad.Ui.AddChild(mainVbox);

			// 1. Top Bar
			var topMargin = new MarginContainer();
			topMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(16 * scaleFactor));
			topMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(16 * scaleFactor));
			topMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(16 * scaleFactor));
			topMargin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(16 * scaleFactor));
			mainVbox.AddChild(topMargin);

			var topHbox = new HBoxContainer();
			topHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(8 * scaleFactor));
			topMargin.AddChild(topHbox);

			var adBadgePanel = new Panel();
			adBadgePanel.CustomMinimumSize = new Vector2((int)Mathf.Round(24 * scaleFactor), (int)Mathf.Round(16 * scaleFactor));
			adBadgePanel.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
			var adBadgeStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.2f, 0.2f, 0.2f),
				CornerRadiusTopLeft = (int)Mathf.Round(3 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(3 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(3 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(3 * scaleFactor)
			};
			adBadgePanel.AddThemeStyleboxOverride("panel", adBadgeStyle);
			topHbox.AddChild(adBadgePanel);

			var adBadgeLbl = new Label
			{
				Text = "Ad",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			adBadgeLbl.AddThemeColorOverride("font_color", Colors.White);
			adBadgeLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(10 * scaleFactor)));
			adBadgeLbl.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			adBadgePanel.AddChild(adBadgeLbl);

			var topIcon = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/flood_it_icon.svg"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2(20 * scaleFactor, 20 * scaleFactor),
				SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
			};
			topHbox.AddChild(topIcon);

			var topTitle = new Label
			{
				Text = "Flood-It!"
			};
			topTitle.AddThemeColorOverride("font_color", new Color(0.2f, 0.2f, 0.2f));
			topTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
			topTitle.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
			topHbox.AddChild(topTitle);

			var topSpacer = new Control
			{
				SizeFlagsHorizontal = Control.SizeFlags.ExpandFill
			};
			topHbox.AddChild(topSpacer);

			var continueContainer = new MarginContainer();
			continueContainer.MouseFilter = Control.MouseFilterEnum.Pass;
			topHbox.AddChild(continueContainer);

			var continueBtn = new Button();
			continueBtn.AddThemeStyleboxOverride("normal", new StyleBoxEmpty());
			continueBtn.AddThemeStyleboxOverride("hover", new StyleBoxEmpty());
			continueBtn.AddThemeStyleboxOverride("pressed", new StyleBoxEmpty());
			continueBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			continueContainer.AddChild(continueBtn);

			var continueHbox = new HBoxContainer();
			continueHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(4 * scaleFactor));
			continueHbox.MouseFilter = Control.MouseFilterEnum.Ignore;
			continueContainer.AddChild(continueHbox);

			var continueLbl = new Label
			{
				Text = "Continue to app"
			};
			continueLbl.AddThemeColorOverride("font_color", new Color(0.5f, 0.5f, 0.5f));
			continueLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
			continueLbl.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
			continueHbox.AddChild(continueLbl);

			var continueArrow = new Label
			{
				Text = ">"
			};
			continueArrow.AddThemeColorOverride("font_color", new Color(0.5f, 0.5f, 0.5f));
			continueArrow.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
			continueArrow.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
			continueHbox.AddChild(continueArrow);

			continueBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				ad.Ui.Hide();
				EmitSignal(SignalName.on_app_open_ad_dismissed_full_screen_content, uid);
			}));

			// 2. Media View (Fills remaining space)
			var mediaContainer = new Panel();
			mediaContainer.SizeFlagsVertical = Control.SizeFlags.ExpandFill;
			var mediaStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.9f, 0.9f, 0.9f)
			};
			mediaContainer.AddThemeStyleboxOverride("panel", mediaStyle);
			mainVbox.AddChild(mediaContainer);

			var grad = new Gradient();
			grad.Offsets = new float[] { 0.0f, 1.0f };
			grad.Colors = new Color[] { new Color(1.0f, 0.65f, 0.1f), new Color(1.0f, 0.4f, 0.0f) };
			var gradTex = new GradientTexture2D
			{
				Gradient = grad,
				Fill = GradientTexture2D.FillEnum.Radial,
				FillFrom = new Vector2(0.5f, 0.5f),
				FillTo = new Vector2(1.0f, 1.0f)
			};

			var mediaBgTex = new TextureRect
			{
				Texture = gradTex,
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize
			};
			mediaBgTex.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			mediaContainer.AddChild(mediaBgTex);

			var mediaHbox = new HBoxContainer();
			mediaHbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			mediaHbox.Alignment = BoxContainer.AlignmentMode.Center;
			mediaHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(12 * scaleFactor));
			mediaContainer.AddChild(mediaHbox);

			var mediaIcon = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/flood_it_icon.svg"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2(70 * scaleFactor, 70 * scaleFactor),
				SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
			};
			mediaHbox.AddChild(mediaIcon);

			var phoneFrame = new Panel();
			phoneFrame.CustomMinimumSize = new Vector2((int)Mathf.Round(50 * scaleFactor), (int)Mathf.Round(90 * scaleFactor));
			phoneFrame.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
			var phoneStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.12f, 0.12f, 0.12f),
				BorderColor = new Color(0.7f, 0.7f, 0.7f),
				BorderWidthLeft = 2,
				BorderWidthRight = 2,
				BorderWidthTop = 2,
				BorderWidthBottom = 2,
				CornerRadiusTopLeft = (int)Mathf.Round(8 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(8 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(8 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(8 * scaleFactor)
			};
			phoneFrame.AddThemeStyleboxOverride("panel", phoneStyle);
			mediaHbox.AddChild(phoneFrame);

			var phoneScreen = new Panel();
			phoneScreen.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			phoneScreen.AnchorLeft = 0.08f;
			phoneScreen.AnchorRight = 0.92f;
			phoneScreen.AnchorTop = 0.08f;
			phoneScreen.AnchorBottom = 0.92f;
			var screenStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.95f, 0.95f, 0.95f)
			};
			phoneScreen.AddThemeStyleboxOverride("panel", screenStyle);
			phoneFrame.AddChild(phoneScreen);

			var phoneGrid = new GridContainer
			{
				Columns = 6,
				SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
				SizeFlagsVertical = Control.SizeFlags.ExpandFill
			};
			phoneGrid.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			phoneGrid.AddThemeConstantOverride("h_separation", (int)Mathf.Round(1 * scaleFactor));
			phoneGrid.AddThemeConstantOverride("v_separation", (int)Mathf.Round(1 * scaleFactor));
			phoneScreen.AddChild(phoneGrid);

			Color[] phoneColors = new Color[] {
				Colors.Aqua, Colors.Green, Colors.Yellow, Colors.DeepPink, Colors.Blue, Colors.Red,
				Colors.Yellow, Colors.DeepPink, Colors.Blue, Colors.Red, Colors.Aqua, Colors.Green,
				Colors.Red, Colors.Green, Colors.Aqua, Colors.Yellow, Colors.DeepPink, Colors.Blue,
				Colors.Blue, Colors.Red, Colors.Yellow, Colors.Green, Colors.DeepPink, Colors.Aqua,
				Colors.Aqua, Colors.Green, Colors.Yellow, Colors.DeepPink, Colors.Blue, Colors.Red
			};
			foreach (var c in phoneColors)
			{
				var sq = new ColorRect
				{
					Color = c,
					SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
					SizeFlagsVertical = Control.SizeFlags.ExpandFill
				};
				phoneGrid.AddChild(sq);
			}

			// 3. Bottom Details Section
			var bottomMargin = new MarginContainer();
			bottomMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(20 * scaleFactor));
			bottomMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(20 * scaleFactor));
			bottomMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(20 * scaleFactor));
			bottomMargin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(20 * scaleFactor));
			mainVbox.AddChild(bottomMargin);

			var bottomVbox = new VBoxContainer();
			bottomVbox.AddThemeConstantOverride("separation", (int)Mathf.Round(16 * scaleFactor));
			bottomMargin.AddChild(bottomVbox);

			var infoHbox = new HBoxContainer();
			infoHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(16 * scaleFactor));
			bottomVbox.AddChild(infoHbox);

			var appIcon = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/flood_it_icon.svg"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2(64 * scaleFactor, 64 * scaleFactor),
				SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
			};

			var appIconBg = new Panel
			{
				CustomMinimumSize = appIcon.CustomMinimumSize,
				SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
			};
			var appIconStyle = new StyleBoxFlat
			{
				BgColor = Colors.Transparent,
				BorderColor = new Color(0.9f, 0.9f, 0.9f),
				BorderWidthLeft = 1,
				BorderWidthRight = 1,
				BorderWidthTop = 1,
				BorderWidthBottom = 1,
				CornerRadiusTopLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(12 * scaleFactor)
			};
			appIconBg.AddThemeStyleboxOverride("panel", appIconStyle);
			appIconBg.AddChild(appIcon);
			appIcon.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			infoHbox.AddChild(appIconBg);

			var textVbox = new VBoxContainer
			{
				SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
				SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
			};
			textVbox.AddThemeConstantOverride("separation", (int)Mathf.Round(4 * scaleFactor));
			infoHbox.AddChild(textVbox);

			var titleLbl = new Label
			{
				Text = "Flood-It!"
			};
			titleLbl.AddThemeColorOverride("font_color", new Color(0.1f, 0.1f, 0.1f));
			titleLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(18 * scaleFactor)));
			textVbox.AddChild(titleLbl);

			var ratingHbox = new HBoxContainer();
			ratingHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(4 * scaleFactor));
			textVbox.AddChild(ratingHbox);

			var ratingVal = new Label
			{
				Text = "4.2"
			};
			ratingVal.AddThemeColorOverride("font_color", new Color(0.3f, 0.3f, 0.3f));
			ratingVal.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
			ratingHbox.AddChild(ratingVal);

			var starHbox = new HBoxContainer();
			starHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(1 * scaleFactor));
			ratingHbox.AddChild(starHbox);

			for (int i = 0; i < 5; i++)
			{
				var star = new Label
				{
					Text = "★",
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				star.AddThemeColorOverride("font_color", i < 4 ? new Color(0.95f, 0.7f, 0.1f) : new Color(0.8f, 0.8f, 0.8f));
				star.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(10 * scaleFactor)));
				starHbox.AddChild(star);
			}

			var playIconControl = new Control
			{
				CustomMinimumSize = new Vector2(8 * scaleFactor, 8 * scaleFactor),
				SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
			};
			ratingHbox.AddChild(playIconControl);

			var playTri = new Polygon2D
			{
				Polygon = new Vector2[] {
					new Vector2(0, 0),
					new Vector2(8 * scaleFactor, 4 * scaleFactor),
					new Vector2(0, 8 * scaleFactor)
				},
				Color = new Color(0.0f, 0.65f, 0.35f)
			};
			playIconControl.AddChild(playTri);

			bool isIos = OS.GetName() == "iOS";
			if (isIos)
			{
				playTri.Polygon = new Vector2[] {
					new Vector2(2 * scaleFactor, 2 * scaleFactor),
					new Vector2(6 * scaleFactor, 2 * scaleFactor),
					new Vector2(6 * scaleFactor, 6 * scaleFactor),
					new Vector2(2 * scaleFactor, 6 * scaleFactor)
				};
				playTri.Color = new Color(0.2f, 0.2f, 0.2f);
			}

			var descLbl = new Label
			{
				Text = "Puzzle game with colors"
			};
			descLbl.AddThemeColorOverride("font_color", new Color(0.5f, 0.5f, 0.5f));
			descLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
			textVbox.AddChild(descLbl);

			var installBtn = new Button
			{
				Text = "Install",
				CustomMinimumSize = new Vector2(1, 48 * scaleFactor)
			};
			installBtn.AddThemeColorOverride("font_color", Colors.White);
			installBtn.AddThemeColorOverride("font_hover_color", Colors.White);
			installBtn.AddThemeColorOverride("font_pressed_color", Colors.White);
			installBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactor)));

			var btnNormal = new StyleBoxFlat
			{
				BgColor = new Color(0.08f, 0.38f, 0.85f),
				CornerRadiusTopLeft = (int)Mathf.Round(24 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(24 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(24 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(24 * scaleFactor)
			};

			var btnHover = (StyleBoxFlat)btnNormal.Duplicate();
			btnHover.BgColor = new Color(0.08f, 0.38f, 0.85f).Lightened(0.15f);

			var btnPressed = (StyleBoxFlat)btnNormal.Duplicate();
			btnPressed.BgColor = new Color(0.08f, 0.38f, 0.85f).Darkened(0.15f);

			installBtn.AddThemeStyleboxOverride("normal", btnNormal);
			installBtn.AddThemeStyleboxOverride("hover", btnHover);
			installBtn.AddThemeStyleboxOverride("pressed", btnPressed);
			installBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			bottomVbox.AddChild(installBtn);

			installBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				EmitSignal(SignalName.on_app_open_ad_clicked, uid);
			}));
		}

		public void show(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
			{
				_updateUi(uid);
				ad.Ui.Show();
				EmitSignal(SignalName.on_app_open_ad_showed_full_screen_content, uid);
				EmitSignal(SignalName.on_app_open_ad_impression, uid);
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

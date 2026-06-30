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
	public partial class MockRewardedInterstitialAdPlugin : Node
	{
		[Signal] public delegate void on_rewarded_interstitial_ad_clickedEventHandler(int uid);
		[Signal] public delegate void on_rewarded_interstitial_ad_dismissed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_rewarded_interstitial_ad_failed_to_show_full_screen_contentEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_rewarded_interstitial_ad_impressionEventHandler(int uid);
		[Signal] public delegate void on_rewarded_interstitial_ad_showed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_rewarded_interstitial_ad_loadedEventHandler(int uid);
		[Signal] public delegate void on_rewarded_interstitial_ad_failed_to_loadEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_rewarded_interstitial_ad_paidEventHandler(int uid, Godot.Collections.Dictionary adValue);
		[Signal] public delegate void on_rewarded_interstitial_ad_user_earned_rewardEventHandler(int uid, Godot.Collections.Dictionary rewardItemDictionary);

		private class AdData
		{
			public Control Ui;
			public string AdUnitId;
		}

		private int _uidCounter = 0;
		private System.Collections.Generic.Dictionary<int, AdData> _ads = new System.Collections.Generic.Dictionary<int, AdData>();
		private int _activeUid = -1;
		private float _timeElapsed = 0.0f;
		private bool _timerActive = false;
		private bool _rewardEarned = false;
		private bool _popupVisible = false;

		private Label _countdownLbl;
		private Button _closeBtnNode;
		private Control _popupNode;
		private VBoxContainer _videoScreenNode;
		private VBoxContainer _endScreenNode;

		public override void _Ready()
		{
			((SceneTree)Engine.GetMainLoop()).Root.Connect(Window.SignalName.SizeChanged, Callable.From(OnWindowSizeChanged));
			SetProcess(false);
		}

		private void OnWindowSizeChanged()
		{
			if (_activeUid != -1)
			{
				UpdateUi(_activeUid);
			}
		}

		public override void _Process(double delta)
		{
			if (!_timerActive || _popupVisible || _rewardEarned) return;

			_timeElapsed += (float)delta;
			if (_timeElapsed >= 8.0f)
			{
				_timeElapsed = 8.0f;
				_rewardEarned = true;
				_timerActive = false;
				OnRewardEarned();
			}

			UpdateCountdownUi();
		}

		private void OnRewardEarned()
		{
			UpdateCountdownUi();
			if (_videoScreenNode != null && IsInstanceValid(_videoScreenNode))
			{
				_videoScreenNode.Hide();
			}
			if (_endScreenNode != null && IsInstanceValid(_endScreenNode))
			{
				_endScreenNode.Show();
			}
		}

		private void UpdateCountdownUi()
		{
			if (_countdownLbl == null || !IsInstanceValid(_countdownLbl)) return;

			if (_rewardEarned)
			{
				_countdownLbl.Text = "Reward granted";
				if (_closeBtnNode != null && IsInstanceValid(_closeBtnNode))
				{
					_closeBtnNode.Show();
				}
			}
			else
			{
				int remaining = Mathf.CeilToInt(8.0f - _timeElapsed);
				_countdownLbl.Text = $"Reward in {remaining} seconds";
				if (_closeBtnNode != null && IsInstanceValid(_closeBtnNode))
				{
					if (_timeElapsed >= 5.0f)
					{
						_closeBtnNode.Show();
					}
					else
					{
						_closeBtnNode.Hide();
					}
				}
			}
		}

		private void OnClosePressed()
		{
			if (_rewardEarned)
			{
				var reward = new Godot.Collections.Dictionary
				{
					{ "amount", 10 },
					{ "type", "coins" }
				};
				EmitSignal(SignalName.on_rewarded_interstitial_ad_user_earned_reward, _activeUid, reward);
				if (_ads.TryGetValue(_activeUid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
				{
					ad.Ui.Hide();
				}
				EmitSignal(SignalName.on_rewarded_interstitial_ad_dismissed_full_screen_content, _activeUid);
				SetProcess(false);
			}
			else
			{
				_popupVisible = true;
				if (_popupNode != null && IsInstanceValid(_popupNode))
				{
					_popupNode.Show();
				}
			}
		}

		private void OnCloseVideoConfirmed()
		{
			if (_popupNode != null && IsInstanceValid(_popupNode))
			{
				_popupNode.Hide();
			}
			if (_ads.TryGetValue(_activeUid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
			{
				ad.Ui.Hide();
			}
			EmitSignal(SignalName.on_rewarded_interstitial_ad_dismissed_full_screen_content, _activeUid);
			SetProcess(false);
		}

		private void OnResumeVideoPressed()
		{
			_popupVisible = false;
			if (_popupNode != null && IsInstanceValid(_popupNode))
			{
				_popupNode.Hide();
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
				EmitSignal(SignalName.on_rewarded_interstitial_ad_loaded, uid);
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

			ui.Color = new Color(0.12f, 0.12f, 0.12f);

			var mainVbox = new VBoxContainer();
			mainVbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			mainVbox.AddThemeConstantOverride("separation", 0);
			ui.AddChild(mainVbox);

			// 1. Top Bar
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

			var statusHbox = new HBoxContainer();
			statusHbox.Alignment = BoxContainer.AlignmentMode.End;
			statusHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(8 * scaleFactor));
			statusHbox.SetAnchorsPreset(Control.LayoutPreset.CenterRight);
			statusHbox.GrowHorizontal = Control.GrowDirection.Begin;
			statusHbox.GrowVertical = Control.GrowDirection.Both;
			topControl.AddChild(statusHbox);

			var countdownPanel = new PanelContainer();
			var countdownStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.2f, 0.2f, 0.2f, 0.8f),
				CornerRadiusTopLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(12 * scaleFactor)
			};
			countdownPanel.AddThemeStyleboxOverride("panel", countdownStyle);
			statusHbox.AddChild(countdownPanel);

			var countdownMargin = new MarginContainer();
			countdownMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(12 * scaleFactor));
			countdownMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(12 * scaleFactor));
			countdownMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(4 * scaleFactor));
			countdownMargin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(4 * scaleFactor));
			countdownPanel.AddChild(countdownMargin);

			_countdownLbl = new Label
			{
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			_countdownLbl.AddThemeColorOverride("font_color", Colors.White);
			_countdownLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			countdownMargin.AddChild(_countdownLbl);

			_closeBtnNode = new Button();
			_closeBtnNode.CustomMinimumSize = new Vector2((int)Mathf.Round(24 * scaleFactor), (int)Mathf.Round(24 * scaleFactor));
			var closeStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.2f, 0.2f, 0.2f, 0.8f),
				CornerRadiusTopLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(12 * scaleFactor)
			};
			_closeBtnNode.AddThemeStyleboxOverride("normal", closeStyle);
			_closeBtnNode.AddThemeStyleboxOverride("hover", closeStyle);
			_closeBtnNode.AddThemeStyleboxOverride("pressed", closeStyle);
			_closeBtnNode.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			_closeBtnNode.Hide();
			statusHbox.AddChild(_closeBtnNode);

			var closeIcon = new Label
			{
				Text = "X",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			closeIcon.AddThemeColorOverride("font_color", Colors.White);
			closeIcon.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
			closeIcon.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			_closeBtnNode.AddChild(closeIcon);

			_closeBtnNode.Connect(Button.SignalName.Pressed, Callable.From(OnClosePressed));

			// Main Area
			var contentMargin = new MarginContainer();
			contentMargin.SizeFlagsVertical = Control.SizeFlags.ExpandFill;
			contentMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(16 * scaleFactor));
			contentMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(16 * scaleFactor));
			contentMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(8 * scaleFactor));
			contentMargin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(24 * scaleFactor));
			mainVbox.AddChild(contentMargin);

			var contentControl = new Control();
			contentMargin.AddChild(contentControl);

			// 2a. Video Screen
			_videoScreenNode = new VBoxContainer();
			_videoScreenNode.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			_videoScreenNode.AddThemeConstantOverride("separation", (int)Mathf.Round(16 * scaleFactor));
			contentControl.AddChild(_videoScreenNode);

			var profilePanel = new PanelContainer();
			var profileStyle = new StyleBoxEmpty();
			profilePanel.AddThemeStyleboxOverride("panel", profileStyle);
			_videoScreenNode.AddChild(profilePanel);

			var profileHbox = new HBoxContainer();
			profileHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(12 * scaleFactor));
			profilePanel.AddChild(profileHbox);

			var appIcon = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/icon-120.png"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2((int)Mathf.Round(56 * scaleFactor), (int)Mathf.Round(56 * scaleFactor))
			};
			profileHbox.AddChild(appIcon);

			var profileDetails = new VBoxContainer();
			profileDetails.SizeFlagsHorizontal = Control.SizeFlags.ExpandFill;
			profileDetails.AddThemeConstantOverride("separation", (int)Mathf.Round(2 * scaleFactor));
			profileHbox.AddChild(profileDetails);

			var appTitle = new Label
			{
				Text = "Google Ads"
			};
			appTitle.AddThemeColorOverride("font_color", Colors.White);
			appTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactor)));
			profileDetails.AddChild(appTitle);

			var appSubtitle = new Label
			{
				Text = "Congratulations!"
			};
			appSubtitle.AddThemeColorOverride("font_color", new Color(0.7f, 0.7f, 0.7f));
			appSubtitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
			profileDetails.AddChild(appSubtitle);

			var playBadge = new HBoxContainer();
			playBadge.AddThemeConstantOverride("separation", (int)Mathf.Round(4 * scaleFactor));
			profileDetails.AddChild(playBadge);

			var playIcon = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/google_play_icon.svg"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2((int)Mathf.Round(10 * scaleFactor), (int)Mathf.Round(10 * scaleFactor))
			};
			playBadge.AddChild(playIcon);

			var playLbl = new Label
			{
				Text = "Google Play"
			};
			playLbl.AddThemeColorOverride("font_color", new Color(0.5f, 0.8f, 0.5f));
			playLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(10 * scaleFactor)));
			playBadge.AddChild(playLbl);

			var statsHbox = new HBoxContainer();
			statsHbox.Alignment = BoxContainer.AlignmentMode.Center;
			statsHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(24 * scaleFactor));
			_videoScreenNode.AddChild(statsHbox);

			var ratingsVbox = new VBoxContainer();
			ratingsVbox.Alignment = BoxContainer.AlignmentMode.Center;
			var ratTitle = new Label { Text = "RATINGS", HorizontalAlignment = HorizontalAlignment.Center };
			ratTitle.AddThemeColorOverride("font_color", new Color(0.5f, 0.5f, 0.5f));
			ratTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(9 * scaleFactor)));
			ratingsVbox.AddChild(ratTitle);
			var ratVal = new Label { Text = "4.4 ★★★★★", HorizontalAlignment = HorizontalAlignment.Center };
			ratVal.AddThemeColorOverride("font_color", Colors.White);
			ratVal.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			ratingsVbox.AddChild(ratVal);
			statsHbox.AddChild(ratingsVbox);

			var catVbox = new VBoxContainer();
			catVbox.Alignment = BoxContainer.AlignmentMode.Center;
			var catTitle = new Label { Text = "CATEGORY", HorizontalAlignment = HorizontalAlignment.Center };
			catTitle.AddThemeColorOverride("font_color", new Color(0.5f, 0.5f, 0.5f));
			catTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(9 * scaleFactor)));
			catVbox.AddChild(catTitle);
			var catVal = new Label { Text = "Business", HorizontalAlignment = HorizontalAlignment.Center };
			catVal.AddThemeColorOverride("font_color", Colors.White);
			catVal.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			catVbox.AddChild(catVal);
			statsHbox.AddChild(catVbox);

			var devVbox = new VBoxContainer();
			devVbox.Alignment = BoxContainer.AlignmentMode.Center;
			var devTitle = new Label { Text = "DEVELOPER", HorizontalAlignment = HorizontalAlignment.Center };
			devTitle.AddThemeColorOverride("font_color", new Color(0.5f, 0.5f, 0.5f));
			devTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(9 * scaleFactor)));
			devVbox.AddChild(devTitle);
			var devVal = new Label { Text = "Google LLC", HorizontalAlignment = HorizontalAlignment.Center };
			devVal.AddThemeColorOverride("font_color", Colors.White);
			devVal.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			devVbox.AddChild(devVal);
			statsHbox.AddChild(devVbox);

			var videoPanel = new Panel();
			videoPanel.CustomMinimumSize = new Vector2(1, 180 * scaleFactor);
			videoPanel.SizeFlagsVertical = Control.SizeFlags.ExpandFill;
			var videoStyle = new StyleBoxFlat { BgColor = new Color(0.1f, 0.1f, 0.1f) };
			videoPanel.AddThemeStyleboxOverride("panel", videoStyle);
			_videoScreenNode.AddChild(videoPanel);

			var barsHbox = new HBoxContainer();
			barsHbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			barsHbox.AddThemeConstantOverride("separation", 0);
			videoPanel.AddChild(barsHbox);

			var colors = new Color[] { Colors.Yellow, Colors.Cyan, Colors.Green, Colors.Magenta, Colors.Red, Colors.Blue, Colors.DarkBlue };
			foreach (var col in colors)
			{
				var bar = new ColorRect { Color = col, SizeFlagsHorizontal = Control.SizeFlags.ExpandFill };
				barsHbox.AddChild(bar);
			}

			var manRect = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/format-rewarded-interstitial.svg"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered
			};
			manRect.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			videoPanel.AddChild(manRect);

			var speakerIcon = new Label { Text = "🔊" };
			speakerIcon.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(18 * scaleFactor)));
			speakerIcon.Position = new Vector2(16 * scaleFactor, 16 * scaleFactor);
			videoPanel.AddChild(speakerIcon);

			var pauseIcon = new Label { Text = "⏸" };
			pauseIcon.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(18 * scaleFactor)));
			pauseIcon.Position = new Vector2(48 * scaleFactor, 16 * scaleFactor);
			videoPanel.AddChild(pauseIcon);

			var descLbl = new Label
			{
				Text = "The Google Ads mobile app helps you stay connected to your campaigns while on the go with your smartphone.",
				HorizontalAlignment = HorizontalAlignment.Center,
				AutowrapMode = TextServer.AutowrapMode.Word
			};
			descLbl.AddThemeColorOverride("font_color", new Color(0.8f, 0.8f, 0.8f));
			descLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			_videoScreenNode.AddChild(descLbl);

			var btnStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.5f, 0.7f, 0.9f),
				CornerRadiusTopLeft = (int)Mathf.Round(18 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(18 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(18 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(18 * scaleFactor)
			};

			var installBtn = new Button();
			installBtn.CustomMinimumSize = new Vector2(1, 36 * scaleFactor);
			installBtn.AddThemeStyleboxOverride("normal", btnStyle);
			installBtn.AddThemeStyleboxOverride("hover", btnStyle);
			installBtn.AddThemeStyleboxOverride("pressed", btnStyle);
			installBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			_videoScreenNode.AddChild(installBtn);

			var btnLbl = new Label
			{
				Text = "Install",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			btnLbl.AddThemeColorOverride("font_color", new Color(0.1f, 0.1f, 0.1f));
			btnLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(13 * scaleFactor)));
			btnLbl.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			installBtn.AddChild(btnLbl);

			// 2b. End Screen
			_endScreenNode = new VBoxContainer();
			_endScreenNode.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			_endScreenNode.Alignment = BoxContainer.AlignmentMode.Center;
			_endScreenNode.AddThemeConstantOverride("separation", (int)Mathf.Round(32 * scaleFactor));
			contentControl.AddChild(_endScreenNode);

			var endIcon = new TextureRect
			{
				Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/icon-120.png"),
				ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
				StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered,
				CustomMinimumSize = new Vector2(80 * scaleFactor, 80 * scaleFactor),
				SizeFlagsHorizontal = Control.SizeFlags.ShrinkCenter
			};
			_endScreenNode.AddChild(endIcon);

			var endTitle = new Label
			{
				Text = "Google Ads",
				HorizontalAlignment = HorizontalAlignment.Center
			};
			endTitle.AddThemeColorOverride("font_color", Colors.White);
			endTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(22 * scaleFactor)));
			_endScreenNode.AddChild(endTitle);

			var endInstall = new Button();
			endInstall.CustomMinimumSize = new Vector2(160 * scaleFactor, 36 * scaleFactor);
			endInstall.SizeFlagsHorizontal = Control.SizeFlags.ShrinkCenter;
			endInstall.AddThemeStyleboxOverride("normal", btnStyle);
			endInstall.AddThemeStyleboxOverride("hover", btnStyle);
			endInstall.AddThemeStyleboxOverride("pressed", btnStyle);
			endInstall.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			_endScreenNode.AddChild(endInstall);

			var endBtnLbl = new Label
			{
				Text = "Install",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			endBtnLbl.AddThemeColorOverride("font_color", new Color(0.1f, 0.1f, 0.1f));
			endBtnLbl.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(13 * scaleFactor)));
			endBtnLbl.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			endInstall.AddChild(endBtnLbl);

			// 3. Popup Overlay
			_popupNode = new ColorRect
			{
				Color = new Color(0, 0, 0, 0.6f)
			};
			_popupNode.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ui.AddChild(_popupNode);

			var popupCard = new Panel();
			popupCard.CustomMinimumSize = new Vector2(250 * scaleFactor, 150 * scaleFactor);
			popupCard.SetAnchorsPreset(Control.LayoutPreset.Center);
			popupCard.GrowHorizontal = Control.GrowDirection.Both;
			popupCard.GrowVertical = Control.GrowDirection.Both;
			var cardStyle = new StyleBoxFlat
			{
				BgColor = Colors.White,
				CornerRadiusTopLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(12 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(12 * scaleFactor)
			};
			popupCard.AddThemeStyleboxOverride("panel", cardStyle);
			_popupNode.AddChild(popupCard);

			var cardMargin = new MarginContainer();
			cardMargin.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			cardMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(16 * scaleFactor));
			cardMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(16 * scaleFactor));
			cardMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(16 * scaleFactor));
			cardMargin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(16 * scaleFactor));
			popupCard.AddChild(cardMargin);

			var cardVbox = new VBoxContainer();
			cardVbox.Alignment = BoxContainer.AlignmentMode.Center;
			cardVbox.AddThemeConstantOverride("separation", (int)Mathf.Round(12 * scaleFactor));
			cardMargin.AddChild(cardVbox);

			var giftIcon = new Label { Text = "🎁", HorizontalAlignment = HorizontalAlignment.Center };
			giftIcon.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(24 * scaleFactor)));
			cardVbox.AddChild(giftIcon);

			var popupTitle = new Label
			{
				Text = "Close Video?",
				HorizontalAlignment = HorizontalAlignment.Center
			};
			popupTitle.AddThemeColorOverride("font_color", new Color(0.1f, 0.1f, 0.1f));
			popupTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(15 * scaleFactor)));
			cardVbox.AddChild(popupTitle);

			var popupSub = new Label
			{
				Text = "You will lose your reward",
				HorizontalAlignment = HorizontalAlignment.Center
			};
			popupSub.AddThemeColorOverride("font_color", new Color(0.4f, 0.4f, 0.4f));
			popupSub.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			cardVbox.AddChild(popupSub);

			var popupButtons = new HBoxContainer();
			popupButtons.Alignment = BoxContainer.AlignmentMode.Center;
			popupButtons.AddThemeConstantOverride("separation", (int)Mathf.Round(16 * scaleFactor));
			cardVbox.AddChild(popupButtons);

			var closeVideoBtn = new Button
			{
				Text = "CLOSE VIDEO",
				Flat = true
			};
			closeVideoBtn.AddThemeColorOverride("font_color", new Color(0.3f, 0.5f, 0.8f));
			closeVideoBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			closeVideoBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			popupButtons.AddChild(closeVideoBtn);
			closeVideoBtn.Connect(Button.SignalName.Pressed, Callable.From(OnCloseVideoConfirmed));

			var resumeVideoBtn = new Button
			{
				Text = "RESUME VIDEO"
			};
			var resStyle = new StyleBoxFlat
			{
				BgColor = new Color(0.3f, 0.5f, 0.8f),
				CornerRadiusTopLeft = (int)Mathf.Round(4 * scaleFactor),
				CornerRadiusTopRight = (int)Mathf.Round(4 * scaleFactor),
				CornerRadiusBottomLeft = (int)Mathf.Round(4 * scaleFactor),
				CornerRadiusBottomRight = (int)Mathf.Round(4 * scaleFactor)
			};
			resumeVideoBtn.AddThemeStyleboxOverride("normal", resStyle);
			resumeVideoBtn.AddThemeStyleboxOverride("hover", resStyle);
			resumeVideoBtn.AddThemeStyleboxOverride("pressed", resStyle);
			resumeVideoBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			resumeVideoBtn.AddThemeColorOverride("font_color", Colors.White);
			resumeVideoBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(11 * scaleFactor)));
			popupButtons.AddChild(resumeVideoBtn);
			resumeVideoBtn.Connect(Button.SignalName.Pressed, Callable.From(OnResumeVideoPressed));

			if (_rewardEarned)
			{
				_videoScreenNode.Hide();
				_endScreenNode.Show();
			}
			else
			{
				_videoScreenNode.Show();
				_endScreenNode.Hide();
			}

			if (_popupVisible)
			{
				_popupNode.Show();
			}
			else
			{
				_popupNode.Hide();
			}

			UpdateCountdownUi();
		}

		public void show(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
			{
				_activeUid = uid;
				_timeElapsed = 0.0f;
				_timerActive = true;
				_rewardEarned = false;
				_popupVisible = false;
				UpdateUi(uid);
				ad.Ui.Show();
				EmitSignal(SignalName.on_rewarded_interstitial_ad_showed_full_screen_content, uid);
				EmitSignal(SignalName.on_rewarded_interstitial_ad_impression, uid);
				SetProcess(true);
			}
		}

		public void set_server_side_verification_options(int uid, Godot.Collections.Dictionary options)
		{
			// Do nothing for mock
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
				if (_activeUid == uid)
				{
					_activeUid = -1;
					SetProcess(false);
				}
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

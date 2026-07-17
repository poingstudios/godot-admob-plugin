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

namespace PoingStudios.AdMob.Core
{
	public partial class MockNativeOverlayAdPlugin : Node
	{
		[Signal] public delegate void on_native_overlay_ad_loadedEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_failed_to_loadEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_native_overlay_ad_clickedEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_closedEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_impressionEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_openedEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_paidEventHandler(int uid, Godot.Collections.Dictionary adValue);
		[Signal] public delegate void on_native_overlay_ad_video_startEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_video_playEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_video_pauseEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_video_endEventHandler(int uid);
		[Signal] public delegate void on_native_overlay_ad_video_muteEventHandler(int uid, bool isMuted);
		[Signal] public delegate void on_native_overlay_ad_renderedEventHandler(int uid);

		private class AdData
		{
			public Control Ui;
			public int Position;
			public Godot.Collections.Dictionary CustomPosition;
			public Godot.Collections.Dictionary AdSize;
			public bool IsHidden = false;
			public Godot.Collections.Dictionary Style;
			public int CurrentWidth;
			public int CurrentHeight;

			public bool HasVideoContent = false;
			public bool IsVideoMuted = false;
			public bool IsVideoPlaying = false;
			public double VideoDuration = 15.0;
			public double VideoAspectRatio = 1.777;
		}

		private int _uidCounter = 0;
		private System.Collections.Generic.Dictionary<int, AdData> _ads = new System.Collections.Generic.Dictionary<int, AdData>();

		public override void _Ready()
		{
			((SceneTree)Engine.GetMainLoop()).Root.Connect(Window.SignalName.SizeChanged, Callable.From(() =>
			{
				foreach (var uid in _ads.Keys)
				{
					_updateUiPosition(uid);
				}
			}));
		}

		public int create()
		{
			_uidCounter++;
			int uid = _uidCounter;

			var ui = new ColorRect
			{
				Color = new Color(0.2f, 0.4f, 0.2f, 0.9f)
			};
			ui.Hide();

			var label = new Label
			{
				Text = "Native Ad Mock",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			label.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ui.AddChild(label);

			_ads[uid] = new AdData
			{
				Ui = ui,
				Position = 0,
				CustomPosition = null,
				AdSize = null,
				IsHidden = false
			};

			var canvas = new CanvasLayer
			{
				Layer = 100
			};
			canvas.AddChild(ui);
			AddChild(canvas);

			return uid;
		}

		public void load(string adUnitId, Godot.Collections.Dictionary adRequestDictionary, Godot.Collections.Array keywords, Godot.Collections.Dictionary options, int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad)) return;

			bool isVideo = adUnitId.EndsWith("1044960115") || adUnitId.EndsWith("2521693316");
			ad.HasVideoContent = isVideo;
			ad.IsVideoMuted = false;
			ad.IsVideoPlaying = false;
			ad.VideoDuration = 15.0;
			ad.VideoAspectRatio = 1.777;

			var timer = ((SceneTree)Engine.GetMainLoop()).CreateTimer(0.5f);
			timer.Connect(SceneTreeTimer.SignalName.Timeout, Callable.From(() => 
			{
				EmitSignal(SignalName.on_native_overlay_ad_loaded, uid);
				if (!ad.IsHidden && ad.Ui != null && IsInstanceValid(ad.Ui))
				{
					_updateUiPosition(uid);
					ad.Ui.Show();
					EmitSignal(SignalName.on_native_overlay_ad_impression, uid);
				}
			}));
		}

		public void render_template(int uid, Godot.Collections.Dictionary style, int position, Godot.Collections.Dictionary adSize)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Style = style;
				ad.Position = position;
				ad.CustomPosition = null;
				ad.AdSize = adSize;
				_updateUiPosition(uid);
				EmitSignal(SignalName.on_native_overlay_ad_rendered, uid);
			}
		}

		public void render_template_custom_position(int uid, Godot.Collections.Dictionary style, float x, float y, Godot.Collections.Dictionary adSize)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Style = style;
				ad.Position = -1; // CUSTOM
				ad.CustomPosition = new Godot.Collections.Dictionary { { "x", x }, { "y", y } };
				ad.AdSize = adSize;
				_updateUiPosition(uid);
				EmitSignal(SignalName.on_native_overlay_ad_rendered, uid);
			}
		}

		public void update_position(int uid, int position)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Position = position;
				ad.CustomPosition = null;
				_updateUiPosition(uid);
			}
		}

		public void update_custom_position(int uid, float x, float y)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Position = -1; // CUSTOM
				ad.CustomPosition = new Godot.Collections.Dictionary { { "x", x }, { "y", y } };
				_updateUiPosition(uid);
			}
		}

		private Godot.Collections.Dictionary _getDict(Godot.Collections.Dictionary parent, string key)
		{
			if (parent.TryGetValue(key, out var val) && val.VariantType == Variant.Type.Dictionary)
			{
				return val.AsGodotDictionary();
			}
			return new Godot.Collections.Dictionary();
		}

		private Color _parseColor(string hex, Color defaultColor)
		{
			if (string.IsNullOrEmpty(hex)) return defaultColor;
			if (!hex.StartsWith("#")) hex = "#" + hex;
			return Color.FromString(hex, defaultColor);
		}

		private void _applyTextStyle(Label label, Godot.Collections.Dictionary styleDict, Color defaultTextColor, float defaultFontSize, float scaleFactor)
		{
			Color txtColor = defaultTextColor;
			if (styleDict.TryGetValue("text_color", out var tcVar) && !string.IsNullOrEmpty(tcVar.AsString()))
			{
				txtColor = _parseColor(tcVar.AsString(), defaultTextColor);
			}
			label.AddThemeColorOverride("font_color", txtColor);

			float fontSize = defaultFontSize;
			if (styleDict.TryGetValue("font_size", out var fsVar) && fsVar.AsSingle() > 0.0f)
			{
				fontSize = fsVar.AsSingle();
			}
			label.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(fontSize * scaleFactor)));

			if (styleDict.TryGetValue("background_color", out var bgVar) && !string.IsNullOrEmpty(bgVar.AsString()))
			{
				Color bgColor = _parseColor(bgVar.AsString(), Colors.Transparent);
				if (bgColor.A > 0.0f)
				{
					var sb = new StyleBoxFlat
					{
						BgColor = bgColor,
						ContentMarginLeft = (int)Mathf.Round(4 * scaleFactor),
						ContentMarginRight = (int)Mathf.Round(4 * scaleFactor),
						ContentMarginTop = (int)Mathf.Round(2 * scaleFactor),
						ContentMarginBottom = (int)Mathf.Round(2 * scaleFactor)
					};
					label.AddThemeStyleboxOverride("normal", sb);
				}
			}
		}

		private void _updateUiPosition(int uid)
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

			var style = ad.Style ?? new Godot.Collections.Dictionary();
			string templateId = style.TryGetValue("template_id", out var tIdVar) ? tIdVar.AsString() : "small";

			int widthDp = 0;
			int heightDp = 0;

			if (ad.AdSize != null)
			{
				if (ad.AdSize.TryGetValue("width", out var wVar)) widthDp = wVar.AsInt32();
				if (ad.AdSize.TryGetValue("height", out var hVar)) heightDp = hVar.AsInt32();
			}

			if (templateId == "medium" && heightDp > 0 && heightDp < 120)
			{
				templateId = "small";
			}

			if (templateId == "small")
			{
				heightDp = (heightDp <= 0) ? 90 : Mathf.Min(heightDp, 90);
			}
			else
			{
				heightDp = (heightDp <= 0) ? 250 : Mathf.Min(heightDp, 250);
			}

			float widthInViewport;
			if (widthDp <= 0)
			{
				widthInViewport = viewportSize.X;
				widthDp = (int)Mathf.Round(viewportSize.X / scaleFactor);
			}
			else
			{
				widthInViewport = widthDp * scaleFactor;
			}

			float heightInViewport = heightDp * scaleFactor;

			ad.CurrentWidth = widthDp;
			ad.CurrentHeight = heightDp;

			ad.Ui.ClipContents = true;
			ad.Ui.CustomMinimumSize = new Vector2(widthInViewport, heightInViewport);
			ad.Ui.Size = ad.Ui.CustomMinimumSize;

			var children = ad.Ui.GetChildren();
			foreach (var child in children)
			{
				child.QueueFree();
			}

			Color bgColor = Colors.White;
			if (style.TryGetValue("main_background_color", out var bgVar) && !string.IsNullOrEmpty(bgVar.AsString()))
			{
				bgColor = _parseColor(bgVar.AsString(), Colors.White);
			}
			((ColorRect)ad.Ui).Color = bgColor;

			var primaryStyle = _getDict(style, "primary_text");
			var secondaryStyle = _getDict(style, "secondary_text");
			var tertiaryStyle = _getDict(style, "tertiary_text");
			var ctaStyleDict = _getDict(style, "call_to_action_text");

			Color ctaBg = new Color(0.18f, 0.45f, 0.96f);
			if (ctaStyleDict.TryGetValue("background_color", out var ctaBgVar) && !string.IsNullOrEmpty(ctaBgVar.AsString()))
			{
				ctaBg = _parseColor(ctaBgVar.AsString(), ctaBg);
			}

			Color ctaText = Colors.White;
			if (ctaStyleDict.TryGetValue("text_color", out var ctaTextVar) && !string.IsNullOrEmpty(ctaTextVar.AsString()))
			{
				ctaText = _parseColor(ctaTextVar.AsString(), ctaText);
			}

			if (templateId == "small")
			{
				var margin = new MarginContainer();
				margin.SetAnchorsPreset(Control.LayoutPreset.FullRect);
				float marginLR = Mathf.Clamp(heightDp * 0.1f, 4f, 12f);
				float marginTB = Mathf.Clamp(heightDp * 0.06f, 2f, 8f);
				margin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(marginLR * scaleFactor));
				margin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(marginLR * scaleFactor));
				margin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(marginTB * scaleFactor));
				margin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(marginTB * scaleFactor));
				ad.Ui.AddChild(margin);

				var vboxMain = new VBoxContainer();
				vboxMain.AddThemeConstantOverride("separation", (int)Mathf.Round(Mathf.Clamp(heightDp * 0.05f, 2f, 6f) * scaleFactor));
				margin.AddChild(vboxMain);

				var hboxTop = new HBoxContainer();
				hboxTop.AddThemeConstantOverride("separation", (int)Mathf.Round(8 * scaleFactor));
				hboxTop.SizeFlagsVertical = Control.SizeFlags.ExpandFill;
				vboxMain.AddChild(hboxTop);

				var icon = new TextureRect
				{
					Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/flood_it_icon.svg"),
					ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
					StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered
				};
				float iconSizeDp = Mathf.Clamp(heightDp - 28f, 10f, 40f);
				icon.CustomMinimumSize = new Vector2(iconSizeDp * scaleFactor, iconSizeDp * scaleFactor);
				icon.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;

				var iconBg = new Panel
				{
					CustomMinimumSize = icon.CustomMinimumSize,
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				var iconStyle = new StyleBoxFlat
				{
					BgColor = Colors.Transparent,
					BorderColor = new Color(0.85f, 0.85f, 0.85f),
					BorderWidthLeft = 1,
					BorderWidthRight = 1,
					BorderWidthTop = 1,
					BorderWidthBottom = 1,
					CornerRadiusTopLeft = (int)Mathf.Round(4 * scaleFactor),
					CornerRadiusTopRight = (int)Mathf.Round(4 * scaleFactor),
					CornerRadiusBottomLeft = (int)Mathf.Round(4 * scaleFactor),
					CornerRadiusBottomRight = (int)Mathf.Round(4 * scaleFactor)
				};
				iconBg.AddThemeStyleboxOverride("panel", iconStyle);
				iconBg.AddChild(icon);
				icon.SetAnchorsPreset(Control.LayoutPreset.FullRect);
				hboxTop.AddChild(iconBg);

				var vboxText = new VBoxContainer
				{
					SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				vboxText.AddThemeConstantOverride("separation", 0);
				hboxTop.AddChild(vboxText);

				var title = new Label { Text = "Mock Ad : Flood-It!" };
				float titleFontSize = Mathf.Clamp(heightDp * 0.18f, 8f, 14f);
				_applyTextStyle(title, primaryStyle, new Color(0.1f, 0.1f, 0.1f), titleFontSize, scaleFactor);
				vboxText.AddChild(title);

				var subHbox = new HBoxContainer();
				subHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(4 * scaleFactor));
				vboxText.AddChild(subHbox);

				float badgeHeight = Mathf.Clamp(heightDp * 0.2f, 8f, 14f);
				float badgeWidth = badgeHeight * 1.6f;
				var adBadge = new Panel
				{
					CustomMinimumSize = new Vector2(badgeWidth * scaleFactor, badgeHeight * scaleFactor),
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				Color badgeBg = new Color(0f, 0.53f, 0.28f);
				if (secondaryStyle.TryGetValue("background_color", out var bgCVar) && !string.IsNullOrEmpty(bgCVar.AsString()))
				{
					badgeBg = _parseColor(bgCVar.AsString(), badgeBg);
				}
				var adBadgeStyle = new StyleBoxFlat
				{
					BgColor = badgeBg,
					CornerRadiusTopLeft = 2,
					CornerRadiusTopRight = 2,
					CornerRadiusBottomLeft = 2,
					CornerRadiusBottomRight = 2
				};
				adBadge.AddThemeStyleboxOverride("panel", adBadgeStyle);

				var adBadgeLbl = new Label
				{
					Text = "Ad",
					HorizontalAlignment = HorizontalAlignment.Center,
					VerticalAlignment = VerticalAlignment.Center
				};
				float badgeFontSize = Mathf.Clamp(heightDp * 0.14f, 6f, 9f);
				_applyTextStyle(adBadgeLbl, secondaryStyle, Colors.White, badgeFontSize, scaleFactor);
				adBadge.AddChild(adBadgeLbl);
				adBadgeLbl.SetAnchorsPreset(Control.LayoutPreset.FullRect);
				subHbox.AddChild(adBadge);

				var stars = new Label
				{
					Text = "★ ★ ★ ★ ☆",
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				float starsFontSize = Mathf.Clamp(heightDp * 0.16f, 7f, 12f);
				_applyTextStyle(stars, secondaryStyle, new Color(1.0f, 0.76f, 0.03f), starsFontSize, scaleFactor);
				subHbox.AddChild(stars);

				float btnHeightDp = Mathf.Clamp(heightDp - 32, 14, 28);
				var ctaBtn = new Button
				{
					Text = "INSTALL",
					CustomMinimumSize = new Vector2(1, btnHeightDp * scaleFactor),
					SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				ctaBtn.AddThemeColorOverride("font_color", ctaText);
				ctaBtn.AddThemeColorOverride("font_hover_color", ctaText);
				ctaBtn.AddThemeColorOverride("font_pressed_color", ctaText);

				float ctaFontSize = Mathf.Clamp(heightDp * 0.18f, 8f, 13f);
				if (ctaStyleDict.TryGetValue("font_size", out var ctaFsVar) && ctaFsVar.AsSingle() > 0.0f)
				{
					ctaFontSize = ctaFsVar.AsSingle();
				}
				ctaBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(ctaFontSize * scaleFactor)));

				var ctaBtnNormal = new StyleBoxFlat
				{
					BgColor = ctaBg,
					CornerRadiusTopLeft = (int)Mathf.Round(2 * scaleFactor),
					CornerRadiusTopRight = (int)Mathf.Round(2 * scaleFactor),
					CornerRadiusBottomLeft = (int)Mathf.Round(2 * scaleFactor),
					CornerRadiusBottomRight = (int)Mathf.Round(2 * scaleFactor)
				};

				var ctaBtnHover = (StyleBoxFlat)ctaBtnNormal.Duplicate();
				ctaBtnHover.BgColor = ctaBg.Lightened(0.15f);

				var ctaBtnPressed = (StyleBoxFlat)ctaBtnNormal.Duplicate();
				ctaBtnPressed.BgColor = ctaBg.Darkened(0.15f);

				ctaBtn.AddThemeStyleboxOverride("normal", ctaBtnNormal);
				ctaBtn.AddThemeStyleboxOverride("hover", ctaBtnHover);
				ctaBtn.AddThemeStyleboxOverride("pressed", ctaBtnPressed);
				ctaBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
				vboxMain.AddChild(ctaBtn);
			}
			else
			{
				var margin = new MarginContainer();
				margin.SetAnchorsPreset(Control.LayoutPreset.FullRect);
				margin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(12 * scaleFactor));
				margin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(12 * scaleFactor));
				margin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(10 * scaleFactor));
				margin.AddThemeConstantOverride("margin_bottom", (int)Mathf.Round(10 * scaleFactor));
				ad.Ui.AddChild(margin);

				var vbox = new VBoxContainer();
				vbox.AddThemeConstantOverride("separation", (int)Mathf.Round(10 * scaleFactor));
				margin.AddChild(vbox);

				// 1. Media content panel (Top)
				var mediaPanel = new ColorRect();
				Color mediaBg = new Color(0f, 0f, 0f);
				if (tertiaryStyle.TryGetValue("background_color", out var tBgVar) && !string.IsNullOrEmpty(tBgVar.AsString()))
				{
					mediaBg = _parseColor(tBgVar.AsString(), mediaBg);
				}
				mediaPanel.Color = mediaBg;
				mediaPanel.SizeFlagsVertical = Control.SizeFlags.ExpandFill;
				vbox.AddChild(mediaPanel);

				var mediaVbox = new VBoxContainer();
				mediaVbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
				mediaVbox.Alignment = BoxContainer.AlignmentMode.Center;
				mediaVbox.AddThemeConstantOverride("separation", (int)Mathf.Round(8 * scaleFactor));
				mediaPanel.AddChild(mediaVbox);

				if (has_video_content(uid))
				{
					var videoStatus = new Label
					{
						Text = "Video Ad (Paused)",
						HorizontalAlignment = HorizontalAlignment.Center
					};
					videoStatus.AddThemeColorOverride("font_color", Colors.Yellow);
					videoStatus.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactor)));
					mediaVbox.AddChild(videoStatus);

					var controlsHbox = new HBoxContainer
					{
						Alignment = BoxContainer.AlignmentMode.Center
					};
					controlsHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(10 * scaleFactor));
					mediaVbox.AddChild(controlsHbox);

					var playBtn = new Button
					{
						Text = "Play",
						CustomMinimumSize = new Vector2(60 * scaleFactor, 30 * scaleFactor)
					};
					controlsHbox.AddChild(playBtn);

					var muteBtn = new Button
					{
						Text = "Mute",
						CustomMinimumSize = new Vector2(60 * scaleFactor, 30 * scaleFactor)
					};
					controlsHbox.AddChild(muteBtn);

					bool hasStarted = false;
					playBtn.Pressed += () =>
					{
						bool playing = ad.IsVideoPlaying;
						if (playing)
						{
							ad.IsVideoPlaying = false;
							playBtn.Text = "Play";
							videoStatus.Text = "Video Ad (Paused)";
							videoStatus.AddThemeColorOverride("font_color", Colors.Yellow);
							EmitSignal(SignalName.on_native_overlay_ad_video_pause, uid);
						}
						else
						{
							ad.IsVideoPlaying = true;
							playBtn.Text = "Pause";
							videoStatus.Text = "Video Ad (Playing...)";
							videoStatus.AddThemeColorOverride("font_color", Colors.Green);
							if (!hasStarted)
							{
								hasStarted = true;
								EmitSignal(SignalName.on_native_overlay_ad_video_start, uid);
							}
							EmitSignal(SignalName.on_native_overlay_ad_video_play, uid);
						}
					};

					muteBtn.Pressed += () =>
					{
						bool muted = ad.IsVideoMuted;
						ad.IsVideoMuted = !muted;
						muteBtn.Text = muted ? "Mute" : "Unmute";
						EmitSignal(SignalName.on_native_overlay_ad_video_mute, uid, !muted);
					};
				}
				else
				{
					var mediaTitle = new Label { Text = "Flood-It!" };
					mediaTitle.HorizontalAlignment = HorizontalAlignment.Center;
					mediaTitle.AddThemeColorOverride("font_color", Colors.White);
					mediaTitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(20 * scaleFactor)));
					mediaVbox.AddChild(mediaTitle);

					var grid = new GridContainer
					{
						Columns = 6,
						SizeFlagsHorizontal = Control.SizeFlags.ShrinkCenter
					};
					grid.AddThemeConstantOverride("h_separation", (int)Mathf.Round(4 * scaleFactor));
					grid.AddThemeConstantOverride("v_separation", (int)Mathf.Round(4 * scaleFactor));
					mediaVbox.AddChild(grid);

					Color[] colors = new Color[] {
						Colors.Aqua, Colors.Green, Colors.Yellow, Colors.DeepPink, Colors.Blue, Colors.Red,
						Colors.Yellow, Colors.DeepPink, Colors.Blue, Colors.Red, Colors.Aqua, Colors.Green
					};
					foreach (var c in colors)
					{
						var sq = new ColorRect
						{
							Color = c,
							CustomMinimumSize = new Vector2(8 * scaleFactor, 8 * scaleFactor)
						};
						grid.AddChild(sq);
					}
				}

				// 2. Metadata row (Middle)
				var metaHbox = new HBoxContainer();
				metaHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(10 * scaleFactor));
				vbox.AddChild(metaHbox);

				var icon = new TextureRect
				{
					Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/flood_it_icon.svg"),
					ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize,
					StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered
				};
				float iconSize = 40f * scaleFactor;
				icon.CustomMinimumSize = new Vector2(iconSize, iconSize);
				icon.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;

				var iconBg = new Panel
				{
					CustomMinimumSize = icon.CustomMinimumSize,
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				var iconStyle = new StyleBoxFlat
				{
					BgColor = Colors.Transparent,
					BorderColor = new Color(0.85f, 0.85f, 0.85f),
					BorderWidthLeft = 1,
					BorderWidthRight = 1,
					BorderWidthTop = 1,
					BorderWidthBottom = 1,
					CornerRadiusTopLeft = (int)Mathf.Round(6 * scaleFactor),
					CornerRadiusTopRight = (int)Mathf.Round(6 * scaleFactor),
					CornerRadiusBottomLeft = (int)Mathf.Round(6 * scaleFactor),
					CornerRadiusBottomRight = (int)Mathf.Round(6 * scaleFactor)
				};
				iconBg.AddThemeStyleboxOverride("panel", iconStyle);
				iconBg.AddChild(icon);
				icon.SetAnchorsPreset(Control.LayoutPreset.FullRect);
				metaHbox.AddChild(iconBg);

				var metaVbox = new VBoxContainer
				{
					SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				metaVbox.AddThemeConstantOverride("separation", (int)Mathf.Round(2 * scaleFactor));
				metaHbox.AddChild(metaVbox);

				var title = new Label { Text = "Mock Ad : Flood-It!" };
				_applyTextStyle(title, primaryStyle, new Color(0.1f, 0.1f, 0.1f), 14.0f, scaleFactor);
				metaVbox.AddChild(title);

				var subHbox = new HBoxContainer();
				subHbox.AddThemeConstantOverride("separation", (int)Mathf.Round(6 * scaleFactor));
				metaVbox.AddChild(subHbox);

				var adBadge = new Panel
				{
					CustomMinimumSize = new Vector2((int)Mathf.Round(24 * scaleFactor), (int)Mathf.Round(15 * scaleFactor)),
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				Color badgeBg = new Color(0f, 0.53f, 0.28f);
				if (secondaryStyle.TryGetValue("background_color", out var bgCVar) && !string.IsNullOrEmpty(bgCVar.AsString()))
				{
					badgeBg = _parseColor(bgCVar.AsString(), badgeBg);
				}
				var adBadgeStyle = new StyleBoxFlat
				{
					BgColor = badgeBg,
					CornerRadiusTopLeft = 3,
					CornerRadiusTopRight = 3,
					CornerRadiusBottomLeft = 3,
					CornerRadiusBottomRight = 3
				};
				adBadge.AddThemeStyleboxOverride("panel", adBadgeStyle);

				var adBadgeLbl = new Label
				{
					Text = "Ad",
					HorizontalAlignment = HorizontalAlignment.Center,
					VerticalAlignment = VerticalAlignment.Center
				};
				_applyTextStyle(adBadgeLbl, secondaryStyle, Colors.White, 9.0f, scaleFactor);
				adBadge.AddChild(adBadgeLbl);
				adBadgeLbl.SetAnchorsPreset(Control.LayoutPreset.FullRect);
				subHbox.AddChild(adBadge);

				var stars = new Label
				{
					Text = "★ ★ ★ ★ ☆",
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				_applyTextStyle(stars, secondaryStyle, new Color(1.0f, 0.76f, 0.03f), 12.0f, scaleFactor);
				subHbox.AddChild(stars);

				// 3. Description Label
				var desc = new Label
				{
					Text = "Install Flood-It App for free! Free Popular Casual Game",
					AutowrapMode = TextServer.AutowrapMode.WordSmart,
					SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				_applyTextStyle(desc, tertiaryStyle, Colors.DarkGray, 10.0f, scaleFactor);
				vbox.AddChild(desc);

				// 4. CTA Button (INSTALL) - Full Width
				float ctaFontSize = 13.0f;
				if (ctaStyleDict.TryGetValue("font_size", out var ctaFsVar) && ctaFsVar.AsSingle() > 0.0f)
				{
					ctaFontSize = ctaFsVar.AsSingle();
				}

				var ctaBtn = new Button
				{
					Text = "INSTALL",
					CustomMinimumSize = new Vector2(1, (int)Mathf.Round(36 * scaleFactor)),
					SizeFlagsHorizontal = Control.SizeFlags.ExpandFill,
					SizeFlagsVertical = Control.SizeFlags.ShrinkCenter
				};
				ctaBtn.AddThemeColorOverride("font_color", ctaText);
				ctaBtn.AddThemeColorOverride("font_hover_color", ctaText);
				ctaBtn.AddThemeColorOverride("font_pressed_color", ctaText);
				ctaBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(ctaFontSize * scaleFactor)));

				var ctaBtnNormal = new StyleBoxFlat
				{
					BgColor = ctaBg,
					CornerRadiusTopLeft = (int)Mathf.Round(4 * scaleFactor),
					CornerRadiusTopRight = (int)Mathf.Round(4 * scaleFactor),
					CornerRadiusBottomLeft = (int)Mathf.Round(4 * scaleFactor),
					CornerRadiusBottomRight = (int)Mathf.Round(4 * scaleFactor)
				};

				var ctaBtnHover = (StyleBoxFlat)ctaBtnNormal.Duplicate();
				ctaBtnHover.BgColor = ctaBg.Lightened(0.15f);

				var ctaBtnPressed = (StyleBoxFlat)ctaBtnNormal.Duplicate();
				ctaBtnPressed.BgColor = ctaBg.Darkened(0.15f);

				ctaBtn.AddThemeStyleboxOverride("normal", ctaBtnNormal);
				ctaBtn.AddThemeStyleboxOverride("hover", ctaBtnHover);
				ctaBtn.AddThemeStyleboxOverride("pressed", ctaBtnPressed);
				ctaBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
				vbox.AddChild(ctaBtn);
			}

			var closeBtn = new Button
			{
				Text = "×",
				AnchorLeft = 1f,
				AnchorRight = 1f,
				AnchorTop = 0f,
				AnchorBottom = 0f,
				GrowHorizontal = Control.GrowDirection.Begin,
				CustomMinimumSize = new Vector2(20 * scaleFactor, 20 * scaleFactor),
				Position = new Vector2(ad.Ui.Size.X - 25 * scaleFactor, 5 * scaleFactor)
			};
			ad.Ui.AddChild(closeBtn);

			var closeStyle = new StyleBoxFlat
			{
				BgColor = Colors.White,
				CornerRadiusTopLeft = 999,
				CornerRadiusTopRight = 999,
				CornerRadiusBottomLeft = 999,
				CornerRadiusBottomRight = 999,
				ShadowColor = new Color(0f, 0f, 0f, 0.15f),
				ShadowSize = (int)Mathf.Round(2 * scaleFactor),
				ShadowOffset = new Vector2(0f, (int)Mathf.Round(1 * scaleFactor)),
				ContentMarginTop = 0f,
				ContentMarginBottom = 0f
			};

			closeBtn.AddThemeStyleboxOverride("normal", closeStyle);
			closeBtn.AddThemeStyleboxOverride("hover", closeStyle);
			closeBtn.AddThemeStyleboxOverride("pressed", closeStyle);
			closeBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());
			closeBtn.AddThemeColorOverride("font_color", new Color(0.85f, 0.15f, 0.15f));
			closeBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(14 * scaleFactor)));

			closeBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				ad.IsHidden = true;
				ad.Ui.Hide();
				EmitSignal(SignalName.on_native_overlay_ad_closed, uid);
			}));

			Vector2 scaledSize = ad.Ui.Size;
			switch (ad.Position)
			{
				case -1: // CUSTOM
					float x = ad.CustomPosition != null && ad.CustomPosition.TryGetValue("x", out var xVar) ? xVar.AsSingle() * scaleFactor : 0f;
					float y = ad.CustomPosition != null && ad.CustomPosition.TryGetValue("y", out var yVar) ? yVar.AsSingle() * scaleFactor : 0f;
					ad.Ui.Position = new Vector2(x, y);
					break;
				case 0: // TOP
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2.0f, 0);
					break;
				case 1: // BOTTOM
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2.0f, viewportSize.Y - scaledSize.Y);
					break;
				case 2: // LEFT
					ad.Ui.Position = new Vector2(0, (viewportSize.Y - scaledSize.Y) / 2.0f);
					break;
				case 3: // RIGHT
					ad.Ui.Position = new Vector2(viewportSize.X - scaledSize.X, (viewportSize.Y - scaledSize.Y) / 2.0f);
					break;
				case 4: // TOP_LEFT
					ad.Ui.Position = new Vector2(0, 0);
					break;
				case 5: // TOP_RIGHT
					ad.Ui.Position = new Vector2(viewportSize.X - scaledSize.X, 0);
					break;
				case 6: // BOTTOM_LEFT
					ad.Ui.Position = new Vector2(0, viewportSize.Y - scaledSize.Y);
					break;
				case 7: // BOTTOM_RIGHT
					ad.Ui.Position = new Vector2(viewportSize.X - scaledSize.X, viewportSize.Y - scaledSize.Y);
					break;
				case 8: // CENTER
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2.0f, (viewportSize.Y - scaledSize.Y) / 2.0f);
					break;
				default:
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2.0f, 0);
					break;
			}
		}

		public void hide(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
			{
				ad.IsHidden = true;
				ad.Ui.Hide();
			}
		}

		public void show(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
			{
				ad.IsHidden = false;
				_updateUiPosition(uid);
				ad.Ui.Show();
				EmitSignal(SignalName.on_native_overlay_ad_impression, uid);
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

		public float get_width_in_pixels(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && !ad.IsHidden)
			{
				var viewportSize = GetViewport().GetVisibleRect().Size;
				var windowSize = DisplayServer.WindowGetSize();
				float guiScaleFactor = 1.0f;
				if (windowSize.X > 0)
				{
					guiScaleFactor = viewportSize.X / (float)windowSize.X;
				}

				float scaleFactor = Mathf.Min(viewportSize.X / 360f, viewportSize.Y / 640f);
				if (scaleFactor <= 0.0f)
				{
					scaleFactor = 1.0f;
				}
				float widthInViewport = ad.CurrentWidth * scaleFactor;
				return widthInViewport / guiScaleFactor;
			}
			return 0f;
		}

		public float get_height_in_pixels(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && !ad.IsHidden)
			{
				var viewportSize = GetViewport().GetVisibleRect().Size;
				var windowSize = DisplayServer.WindowGetSize();
				float guiScaleFactor = 1.0f;
				if (windowSize.Y > 0)
				{
					guiScaleFactor = viewportSize.Y / (float)windowSize.Y;
				}

				float scaleFactor = Mathf.Min(viewportSize.X / 360f, viewportSize.Y / 640f);
				if (scaleFactor <= 0.0f)
				{
					scaleFactor = 1.0f;
				}
				float heightInViewport = ad.CurrentHeight * scaleFactor;
				return heightInViewport / guiScaleFactor;
			}
			return 0f;
		}

		public Godot.Collections.Dictionary get_response_info(int uid)
		{
			return new Godot.Collections.Dictionary
			{
				{ "response_id", "mock_response_id" },
				{ "mediation_adapter_class_name", "MockAdapter" },
				{ "adapter_responses", new Godot.Collections.Dictionary() }, { "loaded_adapter_response_info", new Godot.Collections.Dictionary() }, { "response_extras", new Godot.Collections.Dictionary() }
			};
		}


		public bool has_video_content(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				return ad.HasVideoContent;
			}
			return false;
		}


		public float get_video_duration(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				return (float)ad.VideoDuration;
			}
			return 0f;
		}


		public float get_video_aspect_ratio(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				return (float)ad.VideoAspectRatio;
			}
			return 0f;
		}


		public bool is_video_muted(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				return ad.IsVideoMuted;
			}
			return false;
		}


		public bool is_video_custom_controls_enabled(int uid)
		{
			return false;
		}
	}
}

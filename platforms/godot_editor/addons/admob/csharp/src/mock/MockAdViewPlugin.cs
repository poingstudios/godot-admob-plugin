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
using Godot.Collections;
using System.Collections.Generic;

namespace PoingStudios.AdMob.Core
{
	public partial class MockAdViewPlugin : Node
	{
		[Signal] public delegate void on_ad_clickedEventHandler(int uid);
		[Signal] public delegate void on_ad_closedEventHandler(int uid);
		[Signal] public delegate void on_ad_failed_to_loadEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_ad_impressionEventHandler(int uid);
		[Signal] public delegate void on_ad_loadedEventHandler(int uid);
		[Signal] public delegate void on_ad_openedEventHandler(int uid);
		[Signal] public delegate void on_ad_view_paidEventHandler(int uid, Godot.Collections.Dictionary adValueDictionary);

		private class AdData
		{
			public Control Ui;
			public int Position;
			public Godot.Collections.Dictionary CustomPosition;
			public int Width;
			public int Height;
			public int CurrentWidth;
			public int CurrentHeight;
			public bool IsHidden = false;
			public bool IsCollapsible = false;
			public bool IsCollapsed = false;
			public Button ToggleBtn;
			public Button CloseBtn;
			public bool IsAdaptive = false;
		}

		private int _uidCounter = 0;
		private System.Collections.Generic.Dictionary<int, AdData> _ads = new System.Collections.Generic.Dictionary<int, AdData>();

		public override void _Ready()
		{
			((SceneTree)Engine.GetMainLoop()).Root.Connect(Window.SignalName.SizeChanged, Callable.From(() =>
			{
				foreach (var uid in _ads.Keys)
				{
					_updateSize(uid);
				}
			}));
		}

		public int create(Godot.Collections.Dictionary adViewDictionary)
		{
			_uidCounter++;
			int uid = _uidCounter;

			var ui = new ColorRect
			{
				Color = Colors.White
			};
			ui.Hide();

			Godot.Collections.Dictionary adSize = adViewDictionary.TryGetValue("ad_size", out var sizeVar) 
				? sizeVar.AsGodotDictionary()
				: new Godot.Collections.Dictionary { { "width", 320 }, { "height", 50 } };
			
			int width = adSize.TryGetValue("width", out var wVar) ? wVar.AsInt32() : 320;
			int height = adSize.TryGetValue("height", out var hVar) ? hVar.AsInt32() : 50;
			bool isAdaptive = width <= 0;

			if (isAdaptive)
			{
				var windowSize = DisplayServer.WindowGetSize();
				float screenScale = DisplayServer.ScreenGetScale(DisplayServer.WindowGetCurrentScreen());
				width = (int)(windowSize.X / screenScale);
			}
			if (height <= 0) height = 50;

			ui.CustomMinimumSize = new Vector2(width, height);
			ui.Size = ui.CustomMinimumSize;

			int position = adViewDictionary.TryGetValue("ad_position", out var posVar) ? posVar.AsInt32() : 0;
			Godot.Collections.Dictionary customPosition = adViewDictionary.TryGetValue("custom_position", out var cpVar) 
				? cpVar.AsGodotDictionary()
				: new Godot.Collections.Dictionary { { "x", 0 }, { "y", 0 } };

			var canvas = new CanvasLayer
			{
				Layer = 100
			};
			canvas.AddChild(ui);

			var toggleBtn = new Button
			{
				Text = "^",
				AnchorLeft = 1,
				AnchorRight = 1,
				AnchorTop = 0,
				AnchorBottom = 0,
				OffsetLeft = -30,
				OffsetBottom = 30
			};
			toggleBtn.Hide();
			ui.AddChild(toggleBtn);

			toggleBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				if (_ads.TryGetValue(uid, out AdData a))
				{
					a.IsCollapsed = true;
					a.ToggleBtn.Hide();
					_updateSize(uid);
					EmitSignal(SignalName.on_ad_closed, uid);
				}
			}));

			var closeBtn = new Button
			{
				Text = "×",
				AnchorLeft = 1,
				AnchorRight = 1,
				AnchorTop = 0,
				AnchorBottom = 0,
				OffsetLeft = -30,
				OffsetBottom = 30
			};
			ui.AddChild(closeBtn);

			closeBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				if (_ads.TryGetValue(uid, out AdData a))
				{
					a.IsHidden = true;
					a.Ui.Hide();
					EmitSignal(SignalName.on_ad_closed, uid);
				}
			}));

			_ads[uid] = new AdData
			{
				Ui = ui,
				Position = position,
				CustomPosition = customPosition,
				Width = width,
				Height = height,
				CurrentWidth = width,
				CurrentHeight = height,
				ToggleBtn = toggleBtn,
				CloseBtn = closeBtn,
				IsAdaptive = isAdaptive
			};

			AddChild(canvas);

			return uid;
		}

		public void load_ad(int uid, Godot.Collections.Dictionary adRequestDictionary, Godot.Collections.Array keywords)
		{
			if (!_ads.TryGetValue(uid, out AdData ad)) return;

			if (adRequestDictionary.TryGetValue("extras", out var extrasVar))
			{
				var extras = extrasVar.AsGodotDictionary();
				if (extras.ContainsKey("collapsible"))
				{
					ad.IsCollapsible = true;
					ad.IsCollapsed = false;
					if (ad.ToggleBtn != null)
					{
						ad.ToggleBtn.Show();
					}
				}
			}

			var timer = ((SceneTree)Engine.GetMainLoop()).CreateTimer(0.5f);
			timer.Connect(SceneTreeTimer.SignalName.Timeout, Callable.From(() => 
			{
				EmitSignal(SignalName.on_ad_loaded, uid);
				if (!ad.IsHidden && ad.Ui != null && IsInstanceValid(ad.Ui))
				{
					_updateSize(uid);
					ad.Ui.Show();
					EmitSignal(SignalName.on_ad_impression, uid);
				}
			}));
		}

		private void _updateSize(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad) || ad.Ui == null || !IsInstanceValid(ad.Ui)) return;

			var viewportSize = GetViewport().GetVisibleRect().Size;
			viewportSize.X = Mathf.Max(1f, viewportSize.X);
			viewportSize.Y = Mathf.Max(1f, viewportSize.Y);
			float scaleFactor = Mathf.Min(viewportSize.X, viewportSize.Y) / 360f;
			if (scaleFactor <= 0.0f)
			{
				scaleFactor = 1.0f;
			}

			bool isExpanded = ad.IsCollapsible && !ad.IsCollapsed;

			float widthInViewport;
			float heightInViewport;

			if (ad.IsAdaptive)
			{
				widthInViewport = viewportSize.X;
				ad.CurrentWidth = (int)Mathf.Round(viewportSize.X / scaleFactor);
			}
			else
			{
				widthInViewport = ad.Width * scaleFactor;
				ad.CurrentWidth = ad.Width;
			}

			int heightDp = isExpanded ? 250 : ad.Height;
			heightInViewport = heightDp * scaleFactor;
			ad.CurrentHeight = heightDp;

			ad.Ui.CustomMinimumSize = new Vector2(widthInViewport, heightInViewport);
			ad.Ui.Size = ad.Ui.CustomMinimumSize;

			float btnWidth = 28f * scaleFactor;
			float btnHeight = 28f * scaleFactor;

			var localVisibleRect = new Rect2(Vector2.Zero, ad.Ui.Size).Intersection(new Rect2(-ad.Ui.Position, viewportSize));
			float targetTop = 10f * scaleFactor;
			float closeTargetLeft = ad.Ui.Size.X - 38f * scaleFactor;
			float toggleTargetLeft = ad.Ui.Size.X - 71f * scaleFactor;

			if (localVisibleRect.Size.X > 0f && localVisibleRect.Size.Y > 0f)
			{
				targetTop = Mathf.Clamp(localVisibleRect.Position.Y + 10f * scaleFactor, localVisibleRect.Position.Y, localVisibleRect.Position.Y + localVisibleRect.Size.Y - btnHeight);
				closeTargetLeft = localVisibleRect.Position.X + localVisibleRect.Size.X - btnWidth - 10f * scaleFactor;
				closeTargetLeft = Mathf.Clamp(closeTargetLeft, localVisibleRect.Position.X, localVisibleRect.Position.X + localVisibleRect.Size.X - btnWidth);
				toggleTargetLeft = closeTargetLeft - btnWidth - 5f * scaleFactor;
				toggleTargetLeft = Mathf.Clamp(toggleTargetLeft, localVisibleRect.Position.X, localVisibleRect.Position.X + localVisibleRect.Size.X - btnWidth);
			}

			if (ad.CloseBtn != null && IsInstanceValid(ad.CloseBtn))
			{
				ad.CloseBtn.AnchorLeft = 0f;
				ad.CloseBtn.AnchorRight = 0f;
				ad.CloseBtn.AnchorTop = 0f;
				ad.CloseBtn.AnchorBottom = 0f;
				ad.CloseBtn.OffsetLeft = closeTargetLeft;
				ad.CloseBtn.OffsetTop = targetTop;
				ad.CloseBtn.OffsetRight = closeTargetLeft + btnWidth;
				ad.CloseBtn.OffsetBottom = targetTop + btnHeight;

				var styleNormal = new StyleBoxFlat
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

				var styleHover = (StyleBoxFlat)styleNormal.Duplicate();
				styleHover.BgColor = new Color(0.95f, 0.95f, 0.95f);

				var stylePressed = (StyleBoxFlat)styleNormal.Duplicate();
				stylePressed.BgColor = new Color(0.90f, 0.90f, 0.90f);

				ad.CloseBtn.AddThemeStyleboxOverride("normal", styleNormal);
				ad.CloseBtn.AddThemeStyleboxOverride("hover", styleHover);
				ad.CloseBtn.AddThemeStyleboxOverride("pressed", stylePressed);
				ad.CloseBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());

				ad.CloseBtn.AddThemeColorOverride("font_color", new Color(0.85f, 0.15f, 0.15f));
				ad.CloseBtn.AddThemeColorOverride("font_hover_color", new Color(0.95f, 0.2f, 0.2f));
				ad.CloseBtn.AddThemeColorOverride("font_pressed_color", new Color(0.65f, 0.1f, 0.1f));
				ad.CloseBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(18 * scaleFactor)));
			}

			if (ad.ToggleBtn != null && IsInstanceValid(ad.ToggleBtn))
			{
				if (isExpanded)
				{
					ad.ToggleBtn.Text = "^";
					ad.ToggleBtn.Show();
				}
				else
				{
					ad.ToggleBtn.Hide();
				}

				ad.ToggleBtn.AnchorLeft = 0f;
				ad.ToggleBtn.AnchorRight = 0f;
				ad.ToggleBtn.AnchorTop = 0f;
				ad.ToggleBtn.AnchorBottom = 0f;
				ad.ToggleBtn.OffsetLeft = toggleTargetLeft;
				ad.ToggleBtn.OffsetTop = targetTop;
				ad.ToggleBtn.OffsetRight = toggleTargetLeft + btnWidth;
				ad.ToggleBtn.OffsetBottom = targetTop + btnHeight;

				var styleNormal = new StyleBoxFlat
				{
					BgColor = Colors.White,
					CornerRadiusTopLeft = 999,
					CornerRadiusTopRight = 999,
					CornerRadiusBottomLeft = 999,
					CornerRadiusBottomRight = 999,
					ShadowColor = new Color(0f, 0f, 0f, 0.15f),
					ShadowSize = (int)Mathf.Round(2 * scaleFactor),
					ShadowOffset = new Vector2(0f, (int)Mathf.Round(1 * scaleFactor)),
					ContentMarginTop = (int)Mathf.Round(4 * scaleFactor),
					ContentMarginBottom = 0f
				};

				var styleHover = (StyleBoxFlat)styleNormal.Duplicate();
				styleHover.BgColor = new Color(0.95f, 0.95f, 0.95f);

				var stylePressed = (StyleBoxFlat)styleNormal.Duplicate();
				stylePressed.BgColor = new Color(0.90f, 0.90f, 0.90f);

				ad.ToggleBtn.AddThemeStyleboxOverride("normal", styleNormal);
				ad.ToggleBtn.AddThemeStyleboxOverride("hover", styleHover);
				ad.ToggleBtn.AddThemeStyleboxOverride("pressed", stylePressed);
				ad.ToggleBtn.AddThemeStyleboxOverride("focus", new StyleBoxEmpty());

				ad.ToggleBtn.AddThemeColorOverride("font_color", new Color(0.2f, 0.2f, 0.2f));
				ad.ToggleBtn.AddThemeColorOverride("font_hover_color", new Color(0.1f, 0.1f, 0.1f));
				ad.ToggleBtn.AddThemeColorOverride("font_pressed_color", new Color(0f, 0f, 0f));
				ad.ToggleBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(14 * scaleFactor)));
			}

			// Clear old rich UI
			var children = ad.Ui.GetChildren();
			foreach (var child in children)
			{
				if (child == ad.ToggleBtn || child == ad.CloseBtn) continue;
				child.QueueFree();
			}

			// Add floating Mock Ad badge
			var testAdLabel = new Label { Text = "Mock Ad", HorizontalAlignment = HorizontalAlignment.Center };
			testAdLabel.AddThemeColorOverride("font_color", Colors.White);
			testAdLabel.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(10 * scaleFactor)));
			
			var testAdBg = new ColorRect { Color = new Color(0.2f, 0.2f, 0.2f, 0.8f), CustomMinimumSize = new Vector2(45 * scaleFactor, 14 * scaleFactor) };
			testAdBg.SetAnchorsPreset(Control.LayoutPreset.CenterTop);
			testAdBg.GrowHorizontal = Control.GrowDirection.Both;
			testAdBg.AddChild(testAdLabel);
			testAdLabel.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ad.Ui.AddChild(testAdBg);

			var vbox = new VBoxContainer();
			vbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			vbox.AddThemeConstantOverride("separation", (int)Mathf.Round(5 * scaleFactor));
			ad.Ui.AddChild(vbox);

			var floodItTex = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/flood_it_icon.svg");
			var playTex = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/google_play_icon.svg");

			bool useTallLayout = isExpanded || ad.Ui.CustomMinimumSize.Y > 100 * scaleFactor;

			if (useTallLayout)
			{
				var spacerTop = new Control { CustomMinimumSize = new Vector2(1, 20 * scaleFactor) };
				vbox.AddChild(spacerTop);
				
				var icon = new TextureRect { Texture = floodItTex, ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize, StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered, CustomMinimumSize = new Vector2(64 * scaleFactor, 64 * scaleFactor), SizeFlagsHorizontal = Control.SizeFlags.ShrinkCenter };
				vbox.AddChild(icon);

				var title = new Label { Text = "Flood-It!", HorizontalAlignment = HorizontalAlignment.Center };
				title.AddThemeColorOverride("font_color", Colors.Black);
				title.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(24 * scaleFactor)));
				vbox.AddChild(title);

				var subtitle = new Label { Text = "Can you flood it?", HorizontalAlignment = HorizontalAlignment.Center };
				subtitle.AddThemeColorOverride("font_color", Colors.DarkGray);
				subtitle.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(14 * scaleFactor)));
				vbox.AddChild(subtitle);

				var playHbox = new HBoxContainer { Alignment = BoxContainer.AlignmentMode.Center };
				var playIcon = new TextureRect { Texture = playTex, CustomMinimumSize = new Vector2(24 * scaleFactor, 24 * scaleFactor), ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize, StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered };
				var playLabel = new Label { Text = "Google Play" };
				playLabel.AddThemeColorOverride("font_color", Colors.DarkGray);
				playLabel.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(12 * scaleFactor)));
				playHbox.AddChild(playIcon);
				playHbox.AddChild(playLabel);
				vbox.AddChild(playHbox);

				var btnMargin = new MarginContainer();
				btnMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(20 * scaleFactor));
				btnMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(20 * scaleFactor));
				btnMargin.AddThemeConstantOverride("margin_top", (int)Mathf.Round(10 * scaleFactor));
				
				var installBtn = new Button { Text = "Install", CustomMinimumSize = new Vector2(1, 40 * scaleFactor) };
				installBtn.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(14 * scaleFactor)));
				btnMargin.AddChild(installBtn);
				vbox.AddChild(btnMargin);
			}
			else
			{
				var hbox = new HBoxContainer { SizeFlagsVertical = Control.SizeFlags.ExpandFill };
				vbox.AddChild(hbox);

				var leftMargin = new MarginContainer();
				leftMargin.AddThemeConstantOverride("margin_left", (int)Mathf.Round(15 * scaleFactor));
				var niceJob = new Label { Text = "Nice job!" };
				niceJob.AddThemeColorOverride("font_color", new Color(0.26f, 0.52f, 0.96f));
				niceJob.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactor)));
				niceJob.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
				leftMargin.AddChild(niceJob);
				hbox.AddChild(leftMargin);

				var spacer1 = new Control { SizeFlagsHorizontal = Control.SizeFlags.ExpandFill };
				hbox.AddChild(spacer1);

				var centerLabel = new Label { Text = $"This is a {ad.Width}x{ad.Height} mock ad." };
				centerLabel.AddThemeColorOverride("font_color", Colors.Black);
				centerLabel.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactor)));
				centerLabel.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
				hbox.AddChild(centerLabel);

				var spacer2 = new Control { SizeFlagsHorizontal = Control.SizeFlags.ExpandFill };
				hbox.AddChild(spacer2);

				var admobLogo = new TextureRect { Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/icon-120.png"), ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize, StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered, CustomMinimumSize = new Vector2(30 * scaleFactor, 30 * scaleFactor) };
				admobLogo.SizeFlagsHorizontal = Control.SizeFlags.ShrinkCenter;
				admobLogo.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
				
				var rightMargin = new MarginContainer();
				rightMargin.AddThemeConstantOverride("margin_right", (int)Mathf.Round(45 * scaleFactor));
				rightMargin.AddChild(admobLogo);
				hbox.AddChild(rightMargin);
			}

			if (ad.ToggleBtn != null && IsInstanceValid(ad.ToggleBtn))
			{
				ad.ToggleBtn.MoveToFront();
			}
			if (ad.CloseBtn != null && IsInstanceValid(ad.CloseBtn))
			{
				ad.CloseBtn.MoveToFront();
			}

			_updateUiPosition(uid);
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
				{ "adapter_responses", new Godot.Collections.Dictionary() }, { "loaded_adapter_response_info", new Godot.Collections.Dictionary() }, { "response_extras", new Godot.Collections.Dictionary() }
			};
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
				_updateSize(uid);
				ad.Ui.Show();
				EmitSignal(SignalName.on_ad_impression, uid);
			}
		}

		public void update_custom_position(int uid, float x, float y)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Position = -1;
				ad.CustomPosition = new Godot.Collections.Dictionary { { "x", x }, { "y", y } };
				_updateSize(uid);
			}
		}

		public void update_position(int uid, int position)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Position = position;
				_updateSize(uid);
			}
		}

		public int get_width(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				return ad.IsHidden ? 0 : ad.CurrentWidth;
			}
			return 0;
		}

		public int get_height(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				return ad.IsHidden ? 0 : ad.CurrentHeight;
			}
			return 0;
		}

		public int get_width_in_pixels(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad)) return 0;
			if (ad.IsHidden) return 0;

			var viewportSize = GetViewport().GetVisibleRect().Size;
			var windowSize = DisplayServer.WindowGetSize();
			float guiScaleFactor = 1.0f;
			if (windowSize.Y > 0)
			{
				guiScaleFactor = viewportSize.Y / (float)windowSize.Y;
			}

			float scaleFactor = Mathf.Min(viewportSize.X, viewportSize.Y) / 360f;
			if (scaleFactor <= 0.0f)
			{
				scaleFactor = 1.0f;
			}

			float widthInViewport = ad.IsAdaptive ? viewportSize.X : ad.Width * scaleFactor;
			return (int)Mathf.Round(widthInViewport / guiScaleFactor);
		}

		public int get_height_in_pixels(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad)) return 0;
			if (ad.IsHidden) return 0;

			var viewportSize = GetViewport().GetVisibleRect().Size;
			var windowSize = DisplayServer.WindowGetSize();
			float guiScaleFactor = 1.0f;
			if (windowSize.Y > 0)
			{
				guiScaleFactor = viewportSize.Y / (float)windowSize.Y;
			}

			float scaleFactor = Mathf.Min(viewportSize.X, viewportSize.Y) / 360f;
			if (scaleFactor <= 0.0f)
			{
				scaleFactor = 1.0f;
			}

			bool isExpanded = ad.IsCollapsible && !ad.IsCollapsed;
			int heightDp = isExpanded ? 250 : ad.Height;
			float heightInViewport = heightDp * scaleFactor;
			return (int)Mathf.Round(heightInViewport / guiScaleFactor);
		}

		public bool is_collapsible(int uid) => _ads.TryGetValue(uid, out AdData ad) && ad.IsCollapsible;

		private void _updateUiPosition(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad) || ad.Ui == null || !IsInstanceValid(ad.Ui)) return;

			var viewportSize = GetViewport().GetVisibleRect().Size;
			viewportSize.X = Mathf.Max(1f, viewportSize.X);
			viewportSize.Y = Mathf.Max(1f, viewportSize.Y);

			ad.Ui.Scale = Vector2.One;
			var scaledSize = ad.Ui.Size;
			
			switch (ad.Position)
			{
				case -1: // CUSTOM
					float x = 0;
					float y = 0;
					if (ad.CustomPosition != null)
					{
						x = ad.CustomPosition.TryGetValue("x", out var xVar) ? (float)xVar.AsDouble() : 0;
						y = ad.CustomPosition.TryGetValue("y", out var yVar) ? (float)yVar.AsDouble() : 0;
					}
					ad.Ui.Position = new Vector2(x, y);
					break;
				case 0: // TOP
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2f, 0);
					break;
				case 1: // BOTTOM
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2f, viewportSize.Y - scaledSize.Y);
					break;
				case 2: // LEFT
					ad.Ui.Position = new Vector2(0, (viewportSize.Y - scaledSize.Y) / 2f);
					break;
				case 3: // RIGHT
					ad.Ui.Position = new Vector2(viewportSize.X - scaledSize.X, (viewportSize.Y - scaledSize.Y) / 2f);
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
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2f, (viewportSize.Y - scaledSize.Y) / 2f);
					break;
				default:
					ad.Ui.Position = new Vector2((viewportSize.X - scaledSize.X) / 2f, 0);
					break;
			}
		}
	}
}

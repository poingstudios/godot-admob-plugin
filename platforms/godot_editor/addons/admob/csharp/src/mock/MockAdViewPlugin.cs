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
			public bool IsHidden = false;
			public bool IsCollapsible = false;
			public bool IsCollapsed = false;
			public Button ToggleBtn;
		}

		private int _uidCounter = 0;
		private System.Collections.Generic.Dictionary<int, AdData> _ads = new System.Collections.Generic.Dictionary<int, AdData>();

		public int create(Godot.Collections.Dictionary adViewDictionary)
		{
			_uidCounter++;
			int uid = _uidCounter;

			var ui = new ColorRect
			{
				Color = Colors.DarkGray
			};
			ui.Hide();

			var bg_color = new ColorRect
			{
				Color = Colors.White,
			};
			bg_color.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ui.AddChild(bg_color);

			Godot.Collections.Dictionary adSize = adViewDictionary.TryGetValue("ad_size", out var sizeVar) 
				? sizeVar.AsGodotDictionary()
				: new Godot.Collections.Dictionary { { "width", 320 }, { "height", 50 } };
			
			int width = adSize.TryGetValue("width", out var wVar) ? wVar.AsInt32() : 320;
			int height = adSize.TryGetValue("height", out var hVar) ? hVar.AsInt32() : 50;

			if (width <= 0)
			{
				var viewportSize = ((SceneTree)Engine.GetMainLoop()).Root.GetVisibleRect().Size;
				width = (int)viewportSize.X;
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
				}
			}));

			_ads[uid] = new AdData
			{
				Ui = ui,
				Position = position,
				CustomPosition = customPosition,
				Width = width,
				Height = height,
				ToggleBtn = toggleBtn
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

			bool isExpanded = ad.IsCollapsible && !ad.IsCollapsed;

			if (isExpanded)
			{
				ad.Ui.CustomMinimumSize = new Vector2(ad.Width, 250);
				if (ad.ToggleBtn != null) ad.ToggleBtn.Text = "v";
			}
			else
			{
				ad.Ui.CustomMinimumSize = new Vector2(ad.Width, ad.Height);
				if (ad.ToggleBtn != null && ad.IsCollapsible) ad.ToggleBtn.Hide();
			}
			ad.Ui.Size = ad.Ui.CustomMinimumSize;

			// Clear old rich UI
			var children = ad.Ui.GetChildren();
			foreach (var child in children)
			{
				if (child is ColorRect || child == ad.ToggleBtn) continue;
				child.QueueFree();
			}

			// Add floating Test Ad badge
			var testAdLabel = new Label { Text = "Test Ad", HorizontalAlignment = HorizontalAlignment.Center };
			testAdLabel.AddThemeColorOverride("font_color", Colors.White);
			testAdLabel.AddThemeFontSizeOverride("font_size", 10);
			var testAdBg = new ColorRect { Color = new Color(0.2f, 0.2f, 0.2f, 0.8f), CustomMinimumSize = new Vector2(45, 14) };
			testAdBg.SetAnchorsPreset(Control.LayoutPreset.CenterTop);
			testAdBg.GrowHorizontal = Control.GrowDirection.Both;
			testAdBg.AddChild(testAdLabel);
			testAdLabel.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ad.Ui.AddChild(testAdBg);

			var vbox = new VBoxContainer();
			vbox.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			vbox.AddThemeConstantOverride("separation", 5);
			ad.Ui.AddChild(vbox);

			var floodItTex = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/flood_it_icon.svg");
			var playTex = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/google_play_icon.svg");

			bool useTallLayout = isExpanded || ad.Ui.CustomMinimumSize.Y >= 100;

			if (useTallLayout)
			{
				var spacerTop = new Control { CustomMinimumSize = new Vector2(0, 20) };
				vbox.AddChild(spacerTop);
				var icon = new TextureRect { Texture = floodItTex, ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize, StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered, CustomMinimumSize = new Vector2(64, 64), SizeFlagsHorizontal = Control.SizeFlags.ShrinkCenter };
				vbox.AddChild(icon);

				var title = new Label { Text = "Flood-It!", HorizontalAlignment = HorizontalAlignment.Center };
				title.AddThemeColorOverride("font_color", Colors.Black);
				title.AddThemeFontSizeOverride("font_size", 24);
				vbox.AddChild(title);

				var subtitle = new Label { Text = "Can you flood it?", HorizontalAlignment = HorizontalAlignment.Center };
				subtitle.AddThemeColorOverride("font_color", Colors.DarkGray);
				vbox.AddChild(subtitle);

				var playHbox = new HBoxContainer { Alignment = BoxContainer.AlignmentMode.Center };
				var playIcon = new TextureRect { Texture = playTex, CustomMinimumSize = new Vector2(24, 24), ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize, StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered };
				var playLabel = new Label { Text = "Google Play" };
				playLabel.AddThemeColorOverride("font_color", Colors.DarkGray);
				playHbox.AddChild(playIcon);
				playHbox.AddChild(playLabel);
				vbox.AddChild(playHbox);

				var btnMargin = new MarginContainer();
				btnMargin.AddThemeConstantOverride("margin_left", 20);
				btnMargin.AddThemeConstantOverride("margin_right", 20);
				btnMargin.AddThemeConstantOverride("margin_top", 10);
				var installBtn = new Button { Text = "Install", CustomMinimumSize = new Vector2(0, 40) };
				btnMargin.AddChild(installBtn);
				vbox.AddChild(btnMargin);
			}
			else
			{
				var hbox = new HBoxContainer { SizeFlagsVertical = Control.SizeFlags.ExpandFill };
				vbox.AddChild(hbox);

				var leftMargin = new MarginContainer();
				leftMargin.AddThemeConstantOverride("margin_left", 15);
				var niceJob = new Label { Text = "Nice job!" };
				niceJob.AddThemeColorOverride("font_color", new Color(0.26f, 0.52f, 0.96f));
				niceJob.AddThemeFontSizeOverride("font_size", 16);
				niceJob.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
				leftMargin.AddChild(niceJob);
				hbox.AddChild(leftMargin);

				var spacer1 = new Control { SizeFlagsHorizontal = Control.SizeFlags.ExpandFill };
				hbox.AddChild(spacer1);

				var centerLabel = new Label { Text = $"This is a {ad.Width}x{ad.Height} test ad." };
				centerLabel.AddThemeColorOverride("font_color", Colors.Black);
				centerLabel.AddThemeFontSizeOverride("font_size", 16);
				centerLabel.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
				hbox.AddChild(centerLabel);

				var spacer2 = new Control { SizeFlagsHorizontal = Control.SizeFlags.ExpandFill };
				hbox.AddChild(spacer2);

				var admobLogo = new TextureRect { Texture = ResourceLoader.Load<Texture2D>("res://addons/admob/assets/icon-120.png"), ExpandMode = TextureRect.ExpandModeEnum.IgnoreSize, StretchMode = TextureRect.StretchModeEnum.KeepAspectCentered, CustomMinimumSize = new Vector2(30, 30) };
				admobLogo.SizeFlagsVertical = Control.SizeFlags.ShrinkCenter;
				var rightMargin = new MarginContainer();
				rightMargin.AddThemeConstantOverride("margin_right", 15);
				rightMargin.AddChild(admobLogo);
				hbox.AddChild(rightMargin);
			}

			if (ad.ToggleBtn != null && IsInstanceValid(ad.ToggleBtn))
			{
				ad.ToggleBtn.MoveToFront();
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
				{ "adapter_responses", new Godot.Collections.Array() }, { "loaded_adapter_response_info", new Godot.Collections.Dictionary() }, { "response_extras", new Godot.Collections.Dictionary() }
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
			return _ads.TryGetValue(uid, out AdData ad) ? ad.Width : 0;
		}

		public int get_height(int uid)
		{
			return _ads.TryGetValue(uid, out AdData ad) ? ad.Height : 0;
		}

		public int get_width_in_pixels(int uid)
		{
			var windowSize = DisplayServer.WindowGetSize();
			var viewportSize = ((SceneTree)Engine.GetMainLoop()).Root.GetVisibleRect().Size;
			float scaleFactor = windowSize.X / (float)viewportSize.X;
			return (int)(get_width(uid) * scaleFactor);
		}

		public int get_height_in_pixels(int uid)
		{
			var windowSize = DisplayServer.WindowGetSize();
			var viewportSize = ((SceneTree)Engine.GetMainLoop()).Root.GetVisibleRect().Size;
			float scaleFactor = windowSize.Y / (float)viewportSize.Y;
			return (int)(get_height(uid) * scaleFactor);
		}

		public bool is_collapsible(int uid) => _ads.TryGetValue(uid, out AdData ad) && ad.IsCollapsible;

		private void _updateUiPosition(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad) || ad.Ui == null || !IsInstanceValid(ad.Ui)) return;

			var viewportSize = GetViewport().GetVisibleRect().Size;
			
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
					ad.Ui.Position = new Vector2((viewportSize.X - ad.Ui.Size.X) / 2f, 0);
					break;
				case 1: // BOTTOM
					ad.Ui.Position = new Vector2((viewportSize.X - ad.Ui.Size.X) / 2f, viewportSize.Y - ad.Ui.Size.Y);
					break;
				case 2: // LEFT
					ad.Ui.Position = new Vector2(0, (viewportSize.Y - ad.Ui.Size.Y) / 2f);
					break;
				case 3: // RIGHT
					ad.Ui.Position = new Vector2(viewportSize.X - ad.Ui.Size.X, (viewportSize.Y - ad.Ui.Size.Y) / 2f);
					break;
				case 4: // TOP_LEFT
					ad.Ui.Position = new Vector2(0, 0);
					break;
				case 5: // TOP_RIGHT
					ad.Ui.Position = new Vector2(viewportSize.X - ad.Ui.Size.X, 0);
					break;
				case 6: // BOTTOM_LEFT
					ad.Ui.Position = new Vector2(0, viewportSize.Y - ad.Ui.Size.Y);
					break;
				case 7: // BOTTOM_RIGHT
					ad.Ui.Position = new Vector2(viewportSize.X - ad.Ui.Size.X, viewportSize.Y - ad.Ui.Size.Y);
					break;
				case 8: // CENTER
					ad.Ui.Position = new Vector2((viewportSize.X - ad.Ui.Size.X) / 2f, (viewportSize.Y - ad.Ui.Size.Y) / 2f);
					break;
				default:
					ad.Ui.Position = new Vector2((viewportSize.X - ad.Ui.Size.X) / 2f, 0);
					break;
			}
		}
	}
}

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

		private class AdData
		{
			public Control Ui;
			public int Position;
			public Godot.Collections.Dictionary CustomPosition;
			public Godot.Collections.Dictionary AdSize;
			public bool IsHidden = false;
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
				Color = new Color(0.2f, 0.4f, 0.2f, 0.9f) // Greenish mock for Native Ad
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
				ad.Position = position;
				ad.CustomPosition = null;
				ad.AdSize = adSize;
				_updateUiPosition(uid);
			}
		}

		public void render_template_custom_position(int uid, Godot.Collections.Dictionary style, float x, float y, Godot.Collections.Dictionary adSize)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Position = 2; // CUSTOM
				ad.CustomPosition = new Godot.Collections.Dictionary { { "x", x }, { "y", y } };
				ad.AdSize = adSize;
				_updateUiPosition(uid);
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
				ad.Position = 2; // CUSTOM
				ad.CustomPosition = new Godot.Collections.Dictionary { { "x", x }, { "y", y } };
				_updateUiPosition(uid);
			}
		}

		private void _updateUiPosition(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad) || ad.Ui == null || !IsInstanceValid(ad.Ui)) return;
			var viewport = GetViewport();
			if (viewport == null) return;
			var viewportSize = viewport.GetVisibleRect().Size;

			var windowSize = DisplayServer.WindowGetSize();
			float screenScale = DisplayServer.ScreenGetScale(DisplayServer.WindowGetCurrentScreen());

			float scaleX = windowSize.X / (float)viewportSize.X;
			float scaleY = windowSize.Y / (float)viewportSize.Y;

			float scaleFactorX = scaleX > 0f ? (screenScale / scaleX) : 1.0f;
			float scaleFactorY = scaleY > 0f ? (screenScale / scaleY) : 1.0f;

			int width = 320;
			int height = 50;

			if (ad.AdSize != null)
			{
				width = ad.AdSize.TryGetValue("width", out var wVar) ? wVar.AsInt32() : 320;
				height = ad.AdSize.TryGetValue("height", out var hVar) ? hVar.AsInt32() : 50;
			}
			
			if (width <= 0) width = 320;
			if (height <= 0) height = 50;

			ad.Ui.CustomMinimumSize = new Vector2(width * scaleFactorX, height * scaleFactorY);
			ad.Ui.Size = ad.Ui.CustomMinimumSize;

			var label = ad.Ui.GetChildOrNull<Label>(0);
			if (label != null)
			{
				label.AddThemeFontSizeOverride("font_size", Mathf.Max(1, (int)Mathf.Round(16 * scaleFactorY)));
			}

			if (ad.Position == 2) // CUSTOM
			{
				float x = ad.CustomPosition != null && ad.CustomPosition.TryGetValue("x", out var xVar) ? xVar.AsSingle() : 0f;
				float y = ad.CustomPosition != null && ad.CustomPosition.TryGetValue("y", out var yVar) ? yVar.AsSingle() : 0f;
				ad.Ui.Position = new Vector2(x * scaleFactorX, y * scaleFactorY);
			}
			else if (ad.Position == 1) // BOTTOM
			{
				ad.Ui.Position = new Vector2((viewportSize.X - ad.Ui.Size.X) / 2.0f, viewportSize.Y - ad.Ui.Size.Y);
			}
			else // TOP and defaults
			{
				ad.Ui.Position = new Vector2((viewportSize.X - ad.Ui.Size.X) / 2.0f, 0);
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
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				float screenScale = DisplayServer.ScreenGetScale(DisplayServer.WindowGetCurrentScreen());
				int width = 320;
				if (ad.AdSize != null)
				{
					width = ad.AdSize.TryGetValue("width", out var wVar) ? wVar.AsInt32() : 320;
				}
				if (width <= 0) width = 320;
				return width * screenScale;
			}
			return 0f;
		}

		public float get_height_in_pixels(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				float screenScale = DisplayServer.ScreenGetScale(DisplayServer.WindowGetCurrentScreen());
				int height = 50;
				if (ad.AdSize != null)
				{
					height = ad.AdSize.TryGetValue("height", out var hVar) ? hVar.AsInt32() : 50;
				}
				if (height <= 0) height = 50;
				return height * screenScale;
			}
			return 0f;
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
	}
}

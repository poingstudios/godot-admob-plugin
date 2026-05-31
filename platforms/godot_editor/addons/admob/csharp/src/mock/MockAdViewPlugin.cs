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

			var label = new Label
			{
				Text = "AdMob Banner Mock",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			label.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ui.AddChild(label);

			Godot.Collections.Dictionary adSize = adViewDictionary.TryGetValue("ad_size", out var sizeVar) 
				? sizeVar.AsGodotDictionary()
				: new Godot.Collections.Dictionary { { "width", 320 }, { "height", 50 } };
			
			int width = adSize.TryGetValue("width", out var wVar) ? wVar.AsInt32() : 320;
			int height = adSize.TryGetValue("height", out var hVar) ? hVar.AsInt32() : 50;

			if (width <= 0) width = 320;
			if (height <= 0) height = 50;

			ui.CustomMinimumSize = new Vector2(width, height);
			ui.Size = ui.CustomMinimumSize;

			int position = adViewDictionary.TryGetValue("ad_position", out var posVar) ? posVar.AsInt32() : 0;
			Godot.Collections.Dictionary customPosition = adViewDictionary.TryGetValue("custom_position", out var cpVar) 
				? cpVar.AsGodotDictionary()
				: new Godot.Collections.Dictionary { { "x", 0 }, { "y", 0 } };

			_ads[uid] = new AdData
			{
				Ui = ui,
				Position = position,
				CustomPosition = customPosition,
				Width = width,
				Height = height
			};

			var canvas = new CanvasLayer
			{
				Layer = 100
			};
			canvas.AddChild(ui);
			AddChild(canvas);

			return uid;
		}

		public void load_ad(int uid, Godot.Collections.Dictionary adRequestDictionary, Godot.Collections.Array keywords)
		{
			if (!_ads.TryGetValue(uid, out AdData ad)) return;

			var timer = ((SceneTree)Engine.GetMainLoop()).CreateTimer(0.5f);
			timer.Connect(SceneTreeTimer.SignalName.Timeout, Callable.From(() => 
			{
				EmitSignal(SignalName.on_ad_loaded, uid);
				if (!ad.IsHidden && ad.Ui != null && IsInstanceValid(ad.Ui))
				{
					_updateUiPosition(uid);
					ad.Ui.Show();
					EmitSignal(SignalName.on_ad_impression, uid);
				}
			}));
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
				_updateUiPosition(uid);
				ad.Ui.Show();
				EmitSignal(SignalName.on_ad_impression, uid);
			}
		}

		public void update_custom_position(int uid, float x, float y)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.CustomPosition = new Godot.Collections.Dictionary { { "x", x }, { "y", y } };
				_updateUiPosition(uid);
			}
		}

		public void update_position(int uid, int position)
		{
			if (_ads.TryGetValue(uid, out AdData ad))
			{
				ad.Position = position;
				_updateUiPosition(uid);
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

		public int get_width_in_pixels(int uid) => get_width(uid);

		public int get_height_in_pixels(int uid) => get_height(uid);

		public bool is_collapsible(int uid) => false;

		private void _updateUiPosition(int uid)
		{
			if (!_ads.TryGetValue(uid, out AdData ad) || ad.Ui == null || !IsInstanceValid(ad.Ui)) return;

			var viewportSize = GetViewport().GetVisibleRect().Size;
			
			if (ad.Position == 2) // CUSTOM
			{
				float x = ad.CustomPosition.TryGetValue("x", out var xVar) ? xVar.AsSingle() : 0f;
				float y = ad.CustomPosition.TryGetValue("y", out var yVar) ? yVar.AsSingle() : 0f;
				ad.Ui.Position = new Vector2(x, y);
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
	}
}

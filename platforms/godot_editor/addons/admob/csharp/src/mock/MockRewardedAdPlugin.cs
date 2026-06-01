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
	public partial class MockRewardedAdPlugin : Node
	{
		[Signal] public delegate void on_rewarded_ad_clickedEventHandler(int uid);
		[Signal] public delegate void on_rewarded_ad_dismissed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_rewarded_ad_failed_to_show_full_screen_contentEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_rewarded_ad_impressionEventHandler(int uid);
		[Signal] public delegate void on_rewarded_ad_showed_full_screen_contentEventHandler(int uid);
		[Signal] public delegate void on_rewarded_ad_loadedEventHandler(int uid);
		[Signal] public delegate void on_rewarded_ad_failed_to_loadEventHandler(int uid, Godot.Collections.Dictionary errorDictionary);
		[Signal] public delegate void on_rewarded_ad_paidEventHandler(int uid, Godot.Collections.Dictionary adValue);
		[Signal] public delegate void on_rewarded_ad_user_earned_rewardEventHandler(int uid, Godot.Collections.Dictionary rewardItemDictionary);

		private class AdData
		{
			public Control Ui;
			public Button RewardBtn;
			public string AdUnitId;
		}

		private int _uidCounter = 0;
		private System.Collections.Generic.Dictionary<int, AdData> _ads = new System.Collections.Generic.Dictionary<int, AdData>();

		public int create()
		{
			_uidCounter++;
			int uid = _uidCounter;

			var ui = new ColorRect
			{
				Color = new Color(0.1f, 0.1f, 0.1f, 0.9f)
			};
			ui.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ui.Hide();

			var label = new Label
			{
				Text = "AdMob Mock\nRewarded",
				HorizontalAlignment = HorizontalAlignment.Center,
				VerticalAlignment = VerticalAlignment.Center
			};
			label.SetAnchorsPreset(Control.LayoutPreset.FullRect);
			ui.AddChild(label);

			var closeBtn = new Button
			{
				Text = "Close Ad"
			};
			closeBtn.SetAnchorsPreset(Control.LayoutPreset.TopRight);
			closeBtn.Position = new Vector2(-100, 20);
			ui.AddChild(closeBtn);

			var rewardBtn = new Button
			{
				Text = "Earn Reward"
			};
			rewardBtn.SetAnchorsPreset(Control.LayoutPreset.CenterBottom);
			rewardBtn.Position = new Vector2(-50, -60);
			ui.AddChild(rewardBtn);

			rewardBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				var reward = new Godot.Collections.Dictionary
				{
					{ "amount", 10 },
					{ "type", "coins" }
				};
				EmitSignal(SignalName.on_rewarded_ad_user_earned_reward, uid, reward);
				rewardBtn.Disabled = true;
				rewardBtn.Text = "Reward Earned";
			}));

			closeBtn.Connect(Button.SignalName.Pressed, Callable.From(() =>
			{
				ui.Hide();
				EmitSignal(SignalName.on_rewarded_ad_dismissed_full_screen_content, uid);
			}));

			_ads[uid] = new AdData
			{
				Ui = ui,
				RewardBtn = rewardBtn
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
				EmitSignal(SignalName.on_rewarded_ad_loaded, uid);
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

		public void show(int uid)
		{
			if (_ads.TryGetValue(uid, out AdData ad) && ad.Ui != null && IsInstanceValid(ad.Ui))
			{
				if (ad.RewardBtn != null && IsInstanceValid(ad.RewardBtn))
				{
					ad.RewardBtn.Disabled = false;
					ad.RewardBtn.Text = "Earn Reward";
				}
				ad.Ui.Show();
				EmitSignal(SignalName.on_rewarded_ad_showed_full_screen_content, uid);
				EmitSignal(SignalName.on_rewarded_ad_impression, uid);
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
			}
		}

		public Godot.Collections.Dictionary get_response_info(int uid)
		{
			return new Godot.Collections.Dictionary
			{
				{ "response_id", "mock_response_id" },
				{ "mediation_adapter_class_name", "MockAdapter" },
				{ "adapter_responses", new Godot.Collections.Array() },
				{ "loaded_adapter_response_info", new Godot.Collections.Dictionary() },
				{ "response_extras", new Godot.Collections.Dictionary() }
			};
		}
	}
}
// 

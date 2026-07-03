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

namespace PoingStudios.AdMob.Core
{
	public partial class MockMobileAdsPlugin : Node
	{
		[Signal]
		public delegate void on_initialization_completeEventHandler(Dictionary initializationStatusDictionary);

		[Signal]
		public delegate void on_ad_inspector_closedEventHandler(Dictionary errorDictionary);

		private bool _isInitialized = false;
		private float _volume = 1.0f;
		private bool _muted = false;
		private bool _publisherFirstPartyIdEnabled = true;
		private Dictionary _requestConfiguration = new Dictionary();
		private bool _gadHasConsentForCookies = true;

		public void initialize()
		{
			var timer = ((SceneTree)Engine.GetMainLoop()).CreateTimer(0.5f);
			timer.Connect(SceneTreeTimer.SignalName.Timeout, Callable.From(() => 
			{
				var adapterDict = new Godot.Collections.Dictionary
				{
					{ "latency", 42 },
					{ "initializationState", 1 },
					{ "description", "Mock Adapter Ready" }
				};
				var initStatus = new Godot.Collections.Dictionary
				{
					{ "MockAdapter", adapterDict }
				};
				EmitSignal(SignalName.on_initialization_complete, initStatus);
			}));
		}

		public Dictionary get_initialization_status()
		{
			return new Dictionary
			{
				{
					"com.google.android.gms.ads.MobileAds", new Dictionary
					{
						{ "initializationState", 1 }, // READY
						{ "description", "Mock Ads Ready" },
						{ "latency", 500 }
					}
				}
			};
		}

		public void set_request_configuration(Dictionary requestConfigurationDictionary, Array testDeviceIds)
		{
			_requestConfiguration = requestConfigurationDictionary;
		}

		public void set_ios_app_pause_on_background(bool pause)
		{
		}

		public void set_app_volume(float volume)
		{
			_volume = volume;
		}

		public void set_app_muted(bool muted)
		{
			_muted = muted;
		}

		public void set_publisher_first_party_id_enabled(bool enabled)
		{
			_publisherFirstPartyIdEnabled = enabled;
		}

		public void set_gad_has_consent_for_cookies(bool enabled)
		{
			_gadHasConsentForCookies = enabled;
		}

		public bool get_gad_has_consent_for_cookies()
		{
			return _gadHasConsentForCookies;
		}

		public void disable_sdk_crash_reporting()
		{
		}

		public string get_version()
		{
			return "1.0.0-mock";
		}

		public string get_platform_version()
		{
			return "1.0.0-mock";
		}

		public void open_ad_inspector()
		{
			var timer = ((SceneTree)Engine.GetMainLoop()).CreateTimer(0.5f);
			timer.Connect(SceneTreeTimer.SignalName.Timeout, Callable.From(() =>
			{
				EmitSignal(SignalName.on_ad_inspector_closed, new Dictionary());
			}));
		}
	}
}

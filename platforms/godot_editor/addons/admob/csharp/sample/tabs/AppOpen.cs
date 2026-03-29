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
using PoingStudios.AdMob.Api;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Sample;

namespace PoingStudios.AdMob.Sample
{
    public partial class AppOpen : BaseTab
    {
        private AppOpenAd _appOpenAd;
        private readonly AppOpenAdLoadCallback _loadCallback = new AppOpenAdLoadCallback();
        private readonly FullScreenContentCallback _contentCallback = new FullScreenContentCallback();
        private long _loadTime = 0;

        private Button _loadButton;
        private Button _showButton;
        private Button _destroyButton;

        public override void _Ready()
        {
            base._Ready();
            _loadButton = GetNode<Button>("Load");
            _showButton = GetNode<Button>("Show");
            _destroyButton = GetNode<Button>("Destroy");

            _loadCallback.OnAdFailedToLoad = OnAdFailedToLoad;
            _loadCallback.OnAdLoaded = OnAdLoaded;

            _contentCallback.OnAdClicked = () => Log("Ad clicked");
            _contentCallback.OnAdDismissedFullScreenContent = () =>
            {
                Log("Ad dismissed");
                DestroyAd();
            };

            _contentCallback.OnAdFailedToShowFullScreenContent = (err) => Log("Failed to show: " + err.Message);
            _contentCallback.OnAdImpression = () => Log("Impression recorded");
            _contentCallback.OnAdShowedFullScreenContent = () => Log("Ad showed");

            UpdateUiState(false);
        }

        private void UpdateUiState(bool isLoaded)
        {
            _loadButton.Disabled = isLoaded;
            _showButton.Disabled = !isLoaded;
            _destroyButton.Disabled = !isLoaded;
        }

        private const string AdUnitIdAndroid = "ca-app-pub-3940256099942544/9257395921";
        private const string AdUnitIdIos = "ca-app-pub-3940256099942544/5575463023";

        private string AdUnitId => OS.GetName() == "iOS" ? AdUnitIdIos : AdUnitIdAndroid;

        private void _on_load_pressed()
        {
            Log("Loading app open ad...");
            new AppOpenAdLoader().Load(AdUnitId, new AdRequest(), _loadCallback);
        }

        private void _on_show_pressed()
        {
            if (_appOpenAd != null)
            {
                if (IsAdExpired())
                {
                    Log("Ad expired (more than 4 hours). Destroying and please load again.");
                    DestroyAd();
                }
                else
                {
                    Log("Showing app open ad...");
                    _appOpenAd.Show();
                }
            }
        }

        private bool IsAdExpired()
        {
            long now = (long)Time.GetUnixTimeFromSystem();
            long elapsedSeconds = now - _loadTime;
            long fourHoursInSeconds = 4 * 60 * 60;
            return elapsedSeconds >= fourHoursInSeconds;
        }

        private void _on_destroy_pressed()
        {
            DestroyAd();
        }

        private void DestroyAd()
        {
            if (_appOpenAd != null)
            {
                _appOpenAd.Destroy();
                _appOpenAd = null;
                _loadTime = 0;
                Log("Ad destroyed");
                UpdateUiState(false);
            }
        }

        private void OnAdFailedToLoad(LoadAdError error)
        {
            Log("Failed to load: " + error.Message);
            UpdateUiState(false);
        }

        private void OnAdLoaded(AppOpenAd ad)
        {
            Log("Ad loaded successfully");
            Log(" - Ad Unit ID: " + ad.GetAdUnitId());

            var responseInfo = ad.GetResponseInfo();
            if (responseInfo != null)
            {
                Log(" - Response ID: " + responseInfo.ResponseId);
                Log(" - Adapter: " + responseInfo.MediationAdapterClassName);
            }

            ad.FullScreenContentCallback = _contentCallback;
            ad.OnAdPaid = (adValue) =>
            {
                string adSourceName = ad?.GetResponseInfo()?.LoadedAdapterResponseInfo?.AdSourceName ?? "N/A";
                Log(string.Format("Ad paid: {0:F} {1} (precision: {2}, source: {3})", adValue.ValueMicros / 1000000.0, adValue.CurrencyCode, adValue.Precision, adSourceName));
            };

            _appOpenAd = ad;
            _loadTime = (long)Time.GetUnixTimeFromSystem();
            UpdateUiState(true);
        }

        private void Log(string message)
        {
            if (SampleRegistry.Logger != null)
            {
                SampleRegistry.Logger.LogMessage("[App Open] " + message);
            }
            else
            {
                GD.Print("[App Open] " + message);
            }
        }
    }
}

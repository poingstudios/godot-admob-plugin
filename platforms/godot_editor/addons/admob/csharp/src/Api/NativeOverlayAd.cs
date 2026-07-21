// MIT License
// Copyright (c) 2023-present Poing Studios

using System.Collections.Generic;
using System;
using Godot;
using Godot.Collections;
using PoingStudios.AdMob.Api.Core;
using PoingStudios.AdMob.Api.Listeners;
using PoingStudios.AdMob.Core;

namespace PoingStudios.AdMob.Api
{
    public class NativeOverlayAd : MobileSingletonPlugin
    {
        private static readonly GodotObject _plugin = GetPlugin("PoingGodotAdMobNativeOverlayAd");

        // Prevent GC during async load
        private static readonly HashSet<NativeOverlayAd> _activeAds = new HashSet<NativeOverlayAd>();

        public AdListener AdListener { get; set; } = new AdListener();
        public Action<AdValue> OnAdPaid { get; set; }
        public Action OnTemplateRendered { get; set; }
        private readonly int _uid;
        private Action<NativeOverlayAd, LoadAdError> _adLoadCallback;
        private MediaContent _mediaContent;

        private readonly Callable _onAdClickedCallable;
        private readonly Callable _onAdClosedCallable;
        private readonly Callable _onAdImpressionCallable;
        private readonly Callable _onAdOpenedCallable;
        private readonly Callable _onAdLoadedCallable;
        private readonly Callable _onAdFailedToLoadCallable;
        private readonly Callable _onAdPaidCallable;
        private readonly Callable _onVideoStartCallable;
        private readonly Callable _onVideoPlayCallable;
        private readonly Callable _onVideoPauseCallable;
        private readonly Callable _onVideoEndCallable;
        private readonly Callable _onVideoMuteCallable;
        private readonly Callable _onTemplateRenderedCallable;

        private NativeOverlayAd(int uid)
        {
            _uid = uid;

            _onAdClickedCallable = Callable.From<int>(OnAdClicked);
            _onAdClosedCallable = Callable.From<int>(OnAdClosed);
            _onAdImpressionCallable = Callable.From<int>(OnAdImpression);
            _onAdOpenedCallable = Callable.From<int>(OnAdOpened);
            _onAdLoadedCallable = Callable.From<int>(InternalOnAdLoaded);
            _onAdFailedToLoadCallable = Callable.From<int, Dictionary>(InternalOnAdFailedToLoad);
            _onAdPaidCallable = Callable.From<int, Dictionary>(InternalOnAdPaid);
            _onVideoStartCallable = Callable.From<int>(OnVideoStart);
            _onVideoPlayCallable = Callable.From<int>(OnVideoPlay);
            _onVideoPauseCallable = Callable.From<int>(OnVideoPause);
            _onVideoEndCallable = Callable.From<int>(OnVideoEnd);
            _onVideoMuteCallable = Callable.From<int, bool>(OnVideoMute);
            _onTemplateRenderedCallable = Callable.From<int>(InternalOnTemplateRendered);

            if (_plugin != null)
            {
                SafeConnect(_plugin, "on_native_overlay_ad_clicked", _onAdClickedCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_closed", _onAdClosedCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_impression", _onAdImpressionCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_opened", _onAdOpenedCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_paid", _onAdPaidCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_video_start", _onVideoStartCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_video_play", _onVideoPlayCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_video_pause", _onVideoPauseCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_video_end", _onVideoEndCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_video_mute", _onVideoMuteCallable);
                SafeConnect(_plugin, "on_native_overlay_ad_rendered", _onTemplateRenderedCallable);
            }
        }

        public MediaContent GetMediaContent()
        {
            return _mediaContent;
        }

        public static void Load(string adUnitId, AdRequest adRequest, NativeAdOptions options, Action<NativeOverlayAd, LoadAdError> adLoadCallback)
        {
            if (_plugin == null) return;

            var uid = (int)_plugin.Call("create");
            var ad = new NativeOverlayAd(uid);
            ad._adLoadCallback = adLoadCallback;
            _activeAds.Add(ad);

            SafeConnect(_plugin, "on_native_overlay_ad_loaded", ad._onAdLoadedCallable, (uint)GodotObject.ConnectFlags.Deferred);
            SafeConnect(_plugin, "on_native_overlay_ad_failed_to_load", ad._onAdFailedToLoadCallable, (uint)GodotObject.ConnectFlags.Deferred);

            _plugin.Call("load", adUnitId, adRequest.ConvertToDictionary(), new Array<string>(adRequest.Keywords), options.ConvertToDictionary(), uid);
        }

        public void RenderTemplate(NativeTemplateStyle style, AdPosition adPosition, AdSize adSize = null)
        {
            if (_plugin == null) return;

            var adSizeDict = new Dictionary();
            if (adSize != null)
            {
                adSizeDict.Add("width", adSize.Width);
                adSizeDict.Add("height", adSize.Height);
            }

            if (adPosition.Value == AdPosition.Values.Custom)
            {
                _plugin.Call("render_template_custom_position", _uid, style.ConvertToDictionary(), adPosition.Offset.X, adPosition.Offset.Y, adSizeDict);
            }
            else
            {
                _plugin.Call("render_template", _uid, style.ConvertToDictionary(), (int)adPosition.Value, adSizeDict);
            }
        }

        public void SetTemplatePosition(AdPosition adPosition)
        {
            if (_plugin == null) return;

            if (adPosition.Value == AdPosition.Values.Custom)
            {
                _plugin.Call("update_custom_position", _uid, adPosition.Offset.X, adPosition.Offset.Y);
            }
            else
            {
                _plugin.Call("update_position", _uid, (int)adPosition.Value);
            }
        }

        public void Destroy()
        {
            _plugin?.Call("destroy", _uid);
        }

        public ResponseInfo GetResponseInfo()
        {
            var responseInfoDictionary = (Dictionary)_plugin.Call("get_response_info", _uid);
            return ResponseInfo.Create(responseInfoDictionary);
        }

        public void Hide()
        {
            _plugin?.Call("hide", _uid);
        }

        public void Show()
        {
            _plugin?.Call("show", _uid);
        }

        public float GetTemplateWidthInPixels()
        {
            if (_plugin != null)
                return (float)_plugin.Call("get_width_in_pixels", _uid);
            return 0.0f;
        }

        public float GetTemplateHeightInPixels()
        {
            if (_plugin != null)
                return (float)_plugin.Call("get_height_in_pixels", _uid);
            return 0.0f;
        }

        private void InternalOnAdLoaded(int uid)
        {
            if (uid != _uid) return;

            SafeDisconnect(_plugin, "on_native_overlay_ad_loaded", _onAdLoadedCallable);
            SafeDisconnect(_plugin, "on_native_overlay_ad_failed_to_load", _onAdFailedToLoadCallable);

            _mediaContent = new MediaContent(_uid, _plugin);
            _adLoadCallback?.Invoke(this, null);
            _activeAds.Remove(this);
        }

        private void InternalOnAdFailedToLoad(int uid, Dictionary errorDict)
        {
            if (uid != _uid) return;

            SafeDisconnect(_plugin, "on_native_overlay_ad_loaded", _onAdLoadedCallable);
            SafeDisconnect(_plugin, "on_native_overlay_ad_failed_to_load", _onAdFailedToLoadCallable);

            var error = LoadAdError.Create(errorDict);
            _adLoadCallback?.Invoke(null, error);
            _activeAds.Remove(this);
        }

        private void OnAdClicked(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => AdListener.OnAdClicked?.Invoke()).CallDeferred();
        }

        private void OnAdClosed(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => AdListener.OnAdClosed?.Invoke()).CallDeferred();
        }

        private void OnAdImpression(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => AdListener.OnAdImpression?.Invoke()).CallDeferred();
        }

        private void OnAdOpened(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => AdListener.OnAdOpened?.Invoke()).CallDeferred();
        }

        private void InternalOnAdPaid(int uid, Dictionary adValueDictionary)
        {
            if (uid != _uid) return;
            var adValue = AdValue.Create(adValueDictionary);
            Callable.From(() => OnAdPaid?.Invoke(adValue)).CallDeferred();
        }

        private void OnVideoStart(int uid)
        {
            if (uid != _uid) return;
            var callbacks = _mediaContent?.GetVideoController()?.VideoLifecycleCallbacks;
            if (callbacks != null)
            {
                Callable.From(() => callbacks.OnVideoStart?.Invoke()).CallDeferred();
            }
        }

        private void OnVideoPlay(int uid)
        {
            if (uid != _uid) return;
            var callbacks = _mediaContent?.GetVideoController()?.VideoLifecycleCallbacks;
            if (callbacks != null)
            {
                Callable.From(() => callbacks.OnVideoPlay?.Invoke()).CallDeferred();
            }
        }

        private void OnVideoPause(int uid)
        {
            if (uid != _uid) return;
            var callbacks = _mediaContent?.GetVideoController()?.VideoLifecycleCallbacks;
            if (callbacks != null)
            {
                Callable.From(() => callbacks.OnVideoPause?.Invoke()).CallDeferred();
            }
        }

        private void OnVideoEnd(int uid)
        {
            if (uid != _uid) return;
            var callbacks = _mediaContent?.GetVideoController()?.VideoLifecycleCallbacks;
            if (callbacks != null)
            {
                Callable.From(() => callbacks.OnVideoEnd?.Invoke()).CallDeferred();
            }
        }

        private void OnVideoMute(int uid, bool isMuted)
        {
            if (uid != _uid) return;
            var callbacks = _mediaContent?.GetVideoController()?.VideoLifecycleCallbacks;
            if (callbacks != null)
            {
                Callable.From(() => callbacks.OnVideoMute?.Invoke(isMuted)).CallDeferred();
            }
        }

        private void InternalOnTemplateRendered(int uid)
        {
            if (uid != _uid) return;
            Callable.From(() => OnTemplateRendered?.Invoke()).CallDeferred();
        }
    }
}

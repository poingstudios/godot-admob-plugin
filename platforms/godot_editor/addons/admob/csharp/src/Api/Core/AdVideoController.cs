// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using PoingStudios.AdMob.Api.Listeners;

namespace PoingStudios.AdMob.Api.Core
{
    public class AdVideoController
    {
        private readonly int _uid;
        private readonly GodotObject _plugin;

        public VideoLifecycleCallbacks VideoLifecycleCallbacks { get; set; }

        public AdVideoController(int uid, GodotObject plugin)
        {
            _uid = uid;
            _plugin = plugin;
        }

        public bool IsMuted()
        {
            if (_plugin != null)
            {
                return (bool)_plugin.Call("is_video_muted", _uid);
            }
            return true;
        }

        public bool IsCustomControlsEnabled()
        {
            if (_plugin != null)
            {
                return (bool)_plugin.Call("is_video_custom_controls_enabled", _uid);
            }
            return false;
        }
    }
}

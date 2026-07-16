// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;

namespace PoingStudios.AdMob.Api.Core
{
    public class MediaContent
    {
        private readonly int _uid;
        private readonly GodotObject _plugin;
        private readonly AdVideoController _videoController;

        public MediaContent(int uid, GodotObject plugin)
        {
            _uid = uid;
            _plugin = plugin;
            _videoController = new AdVideoController(uid, plugin);
        }

        public bool HasVideoContent()
        {
            if (_plugin != null)
            {
                return (bool)_plugin.Call("has_video_content", _uid);
            }
            return false;
        }

        public AdVideoController GetVideoController()
        {
            return _videoController;
        }

        public float GetDuration()
        {
            if (_plugin != null)
            {
                return (float)_plugin.Call("get_video_duration", _uid);
            }
            return 0.0f;
        }

        public float GetAspectRatio()
        {
            if (_plugin != null)
            {
                return (float)_plugin.Call("get_video_aspect_ratio", _uid);
            }
            return 0.0f;
        }
    }
}

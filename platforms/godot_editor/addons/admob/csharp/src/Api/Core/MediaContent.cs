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

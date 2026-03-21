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
    public class AdPosition
    {
        public enum Values
        {
            Top = 0,
            Bottom = 1,
            Left = 2,
            Right = 3,
            TopLeft = 4,
            TopRight = 5,
            BottomLeft = 6,
            BottomRight = 7,
            Center = 8,
            Custom = -1
        }

        public readonly Values Value;
        public readonly Vector2I Offset;

        public static readonly AdPosition Top = new AdPosition(Values.Top);
        public static readonly AdPosition Bottom = new AdPosition(Values.Bottom);
        public static readonly AdPosition Left = new AdPosition(Values.Left);
        public static readonly AdPosition Right = new AdPosition(Values.Right);
        public static readonly AdPosition TopLeft = new AdPosition(Values.TopLeft);
        public static readonly AdPosition TopRight = new AdPosition(Values.TopRight);
        public static readonly AdPosition BottomLeft = new AdPosition(Values.BottomLeft);
        public static readonly AdPosition BottomRight = new AdPosition(Values.BottomRight);
        public static readonly AdPosition Center = new AdPosition(Values.Center);

        private AdPosition(Values value, Vector2I? offset = null)
        {
            Value = value;
            Offset = offset ?? new Vector2I((int)Values.Custom, (int)Values.Custom);
        }

        public static AdPosition Custom(int x, int y)
        {
            return new AdPosition(Values.Custom, new Vector2I(x, y));
        }


    }
}

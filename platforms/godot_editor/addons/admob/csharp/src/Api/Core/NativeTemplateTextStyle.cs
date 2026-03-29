// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class NativeTemplateTextStyle
    {
        public Color? BackgroundColor;
        public Color? TextColor;
        public float FontSize;
        public NativeTemplateFontStyle Style = NativeTemplateFontStyle.Normal;

        public Dictionary ConvertToDictionary()
        {
            var dict = new Dictionary();
            dict.Add("background_color", BackgroundColor?.ToHtml(true) ?? "");
            dict.Add("text_color", TextColor?.ToHtml(true) ?? "");
            dict.Add("font_size", FontSize);
            dict.Add("style", (int)Style);
            return dict;
        }
    }
}

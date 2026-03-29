// MIT License
// Copyright (c) 2023-present Poing Studios

using Godot;
using Godot.Collections;

namespace PoingStudios.AdMob.Api.Core
{
    public class NativeTemplateStyle
    {
        public const string Small = "small";
        public const string Medium = "medium";

        public string TemplateId = Medium;
        public Color? MainBackgroundColor;
        public NativeTemplateTextStyle PrimaryText;
        public NativeTemplateTextStyle SecondaryText;
        public NativeTemplateTextStyle TertiaryText;
        public NativeTemplateTextStyle CallToActionText;

        public Dictionary ConvertToDictionary()
        {
            var dict = new Dictionary();
            dict.Add("template_id", TemplateId);
            dict.Add("main_background_color", MainBackgroundColor?.ToHtml(true) ?? "");
            dict.Add("primary_text", PrimaryText?.ConvertToDictionary());
            dict.Add("secondary_text", SecondaryText?.ConvertToDictionary());
            dict.Add("tertiary_text", TertiaryText?.ConvertToDictionary());
            dict.Add("call_to_action_text", CallToActionText?.ConvertToDictionary());
            return dict;
        }
    }
}

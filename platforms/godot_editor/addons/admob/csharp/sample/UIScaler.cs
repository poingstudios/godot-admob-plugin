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

namespace PoingStudios.AdMob.Sample
{
    public static class UIScaler
    {
        public static void ScaleUi(Node node, float totalFactor, float scaleFactor)
        {
            if (!(node is Control control))
            {
                foreach (Node child in node.GetChildren())
                {
                    ScaleUi(child, totalFactor, scaleFactor);
                }
                return;
            }

            OptimizeMouseFilter(control);
            ApplyComponentScaling(control, totalFactor);

            foreach (Node child in control.GetChildren())
            {
                ScaleUi(child, totalFactor, scaleFactor);
            }
        }

        private static void OptimizeMouseFilter(Control control)
        {
            bool isInteractive = control is BaseButton ||
                                 control is LineEdit ||
                                 control is TextEdit ||
                                 control is RichTextLabel ||
                                 control is Slider ||
                                 control is OptionButton ||
                                 control is CheckButton ||
                                 control is CheckBox ||
                                 control is ColorPickerButton ||
                                 control is MenuButton;

            if (!isInteractive && !(control is PanelContainer || control is ScrollContainer || control is TabContainer))
            {
                control.MouseFilter = Control.MouseFilterEnum.Ignore;
            }
            else if (isInteractive && control is BaseButton)
            {
                control.MouseFilter = Control.MouseFilterEnum.Stop;
            }
        }

        private static void ApplyComponentScaling(Control control, float totalFactor)
        {
            if (control is OptionButton optionButton)
            {
                ScaleOptionButton(optionButton, totalFactor);
            }
            else if (control is Button button)
            {
                ScaleButton(button, totalFactor);
            }
            else if (control is Label label)
            {
                ScaleLabel(label, totalFactor);
            }
            else if (control is LineEdit lineEdit)
            {
                lineEdit.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(12.0f * totalFactor), 12, 80));
            }
            else if (control is RichTextLabel richTextLabel)
            {
                richTextLabel.AddThemeFontSizeOverride("normal_font_size", Mathf.Clamp((int)Mathf.Round(11.0f * totalFactor), 11, 80));
            }
            else if (control is CheckButton checkButton)
            {
                ScaleCheckButton(checkButton, totalFactor);
            }
            else if (control is HSlider slider)
            {
                ScaleSlider(slider, totalFactor);
            }
            else if (control is TabContainer tabContainer)
            {
                ScaleTabContainer(tabContainer, totalFactor);
            }

            if (control.Name == "Patreon")
            {
                control.CustomMinimumSize = new Vector2(Mathf.Round(96.0f * totalFactor), Mathf.Round(29.0f * totalFactor));
            }
            else if (control.Name == "Ko-fi")
            {
                control.CustomMinimumSize = new Vector2(Mathf.Round(76.0f * totalFactor), Mathf.Round(29.0f * totalFactor));
            }
            else if (control.Name == "PayPal")
            {
                control.CustomMinimumSize = new Vector2(Mathf.Round(80.0f * totalFactor), Mathf.Round(29.0f * totalFactor));
            }
            else if (control.Name == "AppIcon")
            {
                int iconSize = Mathf.Clamp((int)Mathf.Round(40.0f * totalFactor), 32, 96);
                control.CustomMinimumSize = new Vector2(iconSize, iconSize);
            }
            else if (control.Name == "ConsolePanel")
            {
                control.CustomMinimumSize = new Vector2(0, Mathf.Clamp((int)Mathf.Round(120.0f * totalFactor), 120, 300));
            }
        }

        private static void ScaleOptionButton(OptionButton optionButton, float totalFactor)
        {
            optionButton.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(12.0f * totalFactor), 12, 80));

            Control themeOwner = optionButton;
            while (themeOwner != null && themeOwner.Theme == null)
            {
                themeOwner = themeOwner.GetParent() as Control;
            }
            Theme activeTheme = (themeOwner != null && themeOwner.Theme != null) ?
                themeOwner.Theme : GD.Load<Theme>("res://addons/admob/assets/theme_modern.tres");

            Theme duplicatedTheme = (Theme)activeTheme.Duplicate();
            optionButton.Theme = duplicatedTheme;

            int popupFontSize = Mathf.Clamp((int)Mathf.Round(8.0f * totalFactor), 8, 52);
            duplicatedTheme.SetFontSize("font_size", "PopupMenu", popupFontSize);
            duplicatedTheme.SetConstant("v_separation", "PopupMenu", Mathf.Clamp((int)Mathf.Round(8.0f * totalFactor), 8, 40));

            var popupPanel = duplicatedTheme.GetStylebox("panel", "PopupMenu") as StyleBoxFlat;
            if (popupPanel != null)
            {
                var newPanel = (StyleBoxFlat)popupPanel.Duplicate();
                newPanel.ContentMarginLeft = Mathf.Round(10.0f * totalFactor);
                newPanel.ContentMarginRight = Mathf.Round(10.0f * totalFactor);
                newPanel.ContentMarginTop = Mathf.Round(10.0f * totalFactor);
                newPanel.ContentMarginBottom = Mathf.Round(10.0f * totalFactor);
                duplicatedTheme.SetStylebox("panel", "PopupMenu", newPanel);
            }

            var popupHover = duplicatedTheme.GetStylebox("hover", "PopupMenu") as StyleBoxFlat;
            if (popupHover != null)
            {
                var newHover = (StyleBoxFlat)popupHover.Duplicate();
                newHover.ContentMarginLeft = Mathf.Round(15.0f * totalFactor);
                newHover.ContentMarginRight = Mathf.Round(15.0f * totalFactor);
                newHover.ContentMarginTop = Mathf.Round(10.0f * totalFactor);
                newHover.ContentMarginBottom = Mathf.Round(10.0f * totalFactor);
                duplicatedTheme.SetStylebox("hover", "PopupMenu", newHover);
            }

            PopupMenu popup = optionButton.GetPopup();
            if (popup != null)
            {
                popup.Theme = duplicatedTheme;
                popup.SetDeferred("theme", duplicatedTheme);
                popup.AddThemeFontSizeOverride("font_size", popupFontSize);
                popup.CallDeferred("add_theme_font_size_override", "font_size", popupFontSize);
            }
        }

        private static void ScaleButton(Button button, float totalFactor)
        {
            if (button.GetParent() != null && button.GetParent().Name == "PositionGrid")
            {
                int targetSize = Mathf.Clamp((int)Mathf.Round(51.0f * totalFactor), 38, 130);
                button.CustomMinimumSize = new Vector2(targetSize, targetSize);
                float marginSize = Mathf.Clamp((int)Mathf.Round(8.5f * totalFactor), 5, 25);
                string[] styleNames = new string[] { "normal", "hover", "pressed", "disabled" };
                foreach (string styleName in styleNames)
                {
                    StyleBox originalSb = button.GetThemeStylebox(styleName);
                    if (originalSb is StyleBoxFlat originalSbFlat)
                    {
                        StyleBoxFlat newSb = (StyleBoxFlat)originalSbFlat.Duplicate();
                        newSb.ContentMarginLeft = marginSize;
                        newSb.ContentMarginRight = marginSize;
                        newSb.ContentMarginTop = marginSize;
                        newSb.ContentMarginBottom = marginSize;
                        button.AddThemeStyleboxOverride(styleName, newSb);
                    }
                }
            }
            else
            {
                int fontSize = Mathf.Clamp((int)Mathf.Round(12.5f * totalFactor), 12, 80);
                button.AddThemeFontSizeOverride("font_size", fontSize);
                string[] styleboxNames = { "normal", "hover", "pressed", "disabled" };
                foreach (var sbName in styleboxNames)
                {
                    var sb = button.GetThemeStylebox(sbName) as StyleBoxFlat;
                    if (sb != null)
                    {
                        var newSb = (StyleBoxFlat)sb.Duplicate();
                        newSb.ContentMarginTop = Mathf.Round(8.0f * totalFactor);
                        newSb.ContentMarginBottom = Mathf.Round(8.0f * totalFactor);
                        newSb.ContentMarginLeft = Mathf.Round(16.0f * totalFactor);
                        newSb.ContentMarginRight = Mathf.Round(16.0f * totalFactor);
                        button.AddThemeStyleboxOverride(sbName, newSb);
                    }
                }
            }
        }

        private static void ScaleLabel(Label label, float totalFactor)
        {
            if (label.Name == "AppTitle")
            {
                label.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(16.0f * totalFactor), 16, 120));
            }
            else if (label.Name == "AppSubtitle")
            {
                label.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(10.0f * totalFactor), 10, 50));
            }
            else if (label.Name == "SupportLabel")
            {
                label.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(10.5f * totalFactor), 10, 70));
            }
            else
            {
                label.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(13.0f * totalFactor), 12, 80));
            }
        }

        private static void ScaleCheckButton(CheckButton checkButton, float totalFactor)
        {
            checkButton.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(12.0f * totalFactor), 12, 80));
            int minH = Mathf.Clamp((int)Mathf.Round(50.0f * totalFactor), 50, 200);
            checkButton.CustomMinimumSize = new Vector2(checkButton.CustomMinimumSize.X, minH);
        }

        private static void ScaleSlider(HSlider slider, float totalFactor)
        {
            int minH = Mathf.Clamp((int)Mathf.Round(30.0f * totalFactor), 30, 100);
            int minW = Mathf.Clamp((int)Mathf.Round(200.0f * totalFactor), 100, 800);
            slider.CustomMinimumSize = new Vector2(minW, minH);
        }

        private static void ScaleTabContainer(TabContainer tabContainer, float totalFactor)
        {
            tabContainer.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(11.5f * totalFactor), 11, 80));
            var panelSb = tabContainer.GetThemeStylebox("panel") as StyleBoxFlat;
            if (panelSb != null)
            {
                var newPanelSb = (StyleBoxFlat)panelSb.Duplicate();
                newPanelSb.ContentMarginTop = Mathf.Round(12.0f * totalFactor);
                newPanelSb.ContentMarginBottom = Mathf.Round(12.0f * totalFactor);
                newPanelSb.ContentMarginLeft = Mathf.Round(12.0f * totalFactor);
                newPanelSb.ContentMarginRight = Mathf.Round(12.0f * totalFactor);
                tabContainer.AddThemeStyleboxOverride("panel", newPanelSb);
            }
            string[] tabStyleboxes = { "tab_selected", "tab_unselected", "tab_hovered" };
            foreach (var sbName in tabStyleboxes)
            {
                var sb = tabContainer.GetThemeStylebox(sbName) as StyleBoxFlat;
                if (sb != null)
                {
                    var newSb = (StyleBoxFlat)sb.Duplicate();
                    newSb.ContentMarginTop = Mathf.Round(6.0f * totalFactor);
                    newSb.ContentMarginBottom = Mathf.Round(6.0f * totalFactor);
                    newSb.ContentMarginLeft = Mathf.Round(11.0f * totalFactor);
                    newSb.ContentMarginRight = Mathf.Round(11.0f * totalFactor);
                    tabContainer.AddThemeStyleboxOverride(sbName, newSb);
                }
            }
        }
    }
}

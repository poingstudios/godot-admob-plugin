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
            if (node is Control control)
            {
                // 1. Mouse filter optimization
                bool isInteractive = control is Button ||
                                     control is LineEdit ||
                                     control is TextEdit ||
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

                // 2. Font scaling and StyleBox overrides based on node type
                if (control is Button button)
                {
                    if (button.GetParent() != null && button.GetParent().Name == "PositionGrid")
                    {
                        // Predefined position buttons
                        int targetSize = Mathf.Clamp((int)Mathf.Round(60.0f * totalFactor), 45, 150);
                        button.CustomMinimumSize = new Vector2(targetSize, targetSize);
                        float marginSize = Mathf.Clamp((int)Mathf.Round(10.0f * totalFactor), 6, 30);
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
                        // Scale Button StyleBoxes for padding
                        string[] styleboxNames = { "normal", "hover", "pressed", "disabled" };
                        foreach (var sbName in styleboxNames)
                        {
                            var sb = button.GetThemeStylebox(sbName) as StyleBoxFlat;
                            if (sb != null)
                            {
                                var newSb = (StyleBoxFlat)sb.Duplicate();
                                newSb.ContentMarginTop = Mathf.Round(8.0f * scaleFactor);
                                newSb.ContentMarginBottom = Mathf.Round(8.0f * scaleFactor);
                                button.AddThemeStyleboxOverride(sbName, newSb);
                            }
                        }
                    }
                }
                else if (control is Label label)
                {
                    if (label.Name == "AppTitle")
                    {
                        label.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(16.0f * totalFactor), 16, 120));
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
                else if (control is OptionButton optionButton)
                {
                    optionButton.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(12.0f * totalFactor), 12, 80));
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
                    checkButton.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(12.0f * totalFactor), 12, 80));
                }
                else if (control is TabContainer tabContainer)
                {
                    tabContainer.AddThemeFontSizeOverride("font_size", Mathf.Clamp((int)Mathf.Round(11.5f * totalFactor), 11, 80));
                    // Scale TabContainer Header StyleBoxes
                    string[] tabStyleboxes = { "tab_selected", "tab_unselected", "tab_hovered" };
                    foreach (var sbName in tabStyleboxes)
                    {
                        var sb = tabContainer.GetThemeStylebox(sbName) as StyleBoxFlat;
                        if (sb != null)
                        {
                            var newSb = (StyleBoxFlat)sb.Duplicate();
                            newSb.ContentMarginTop = Mathf.Round(6.0f * scaleFactor);
                            newSb.ContentMarginBottom = Mathf.Round(6.0f * scaleFactor);
                            newSb.ContentMarginLeft = Mathf.Round(10.0f * scaleFactor);
                            newSb.ContentMarginRight = Mathf.Round(10.0f * scaleFactor);
                            tabContainer.AddThemeStyleboxOverride(sbName, newSb);
                        }
                    }
                }

                // 3. Dynamic sizing for custom components/panels
                if (control.Name == "Patreon")
                {
                    control.CustomMinimumSize = new Vector2(Mathf.Round(120.0f * totalFactor), Mathf.Round(36.0f * totalFactor));
                }
                else if (control.Name == "Ko-fi")
                {
                    control.CustomMinimumSize = new Vector2(Mathf.Round(95.0f * totalFactor), Mathf.Round(36.0f * totalFactor));
                }
                else if (control.Name == "PayPal")
                {
                    control.CustomMinimumSize = new Vector2(Mathf.Round(100.0f * totalFactor), Mathf.Round(36.0f * totalFactor));
                }
                else if (control.Name == "AppIcon" || control.Name == "CenteringSpacer")
                {
                    int iconSize = Mathf.Clamp((int)Mathf.Round(50.0f * totalFactor), 40, 120);
                    control.CustomMinimumSize = new Vector2(iconSize, control.Name == "AppIcon" ? iconSize : 0);
                }
                else if (control.Name == "ConsolePanel")
                {
                    control.CustomMinimumSize = new Vector2(0, Mathf.Clamp((int)Mathf.Round(120.0f * totalFactor), 120, 300));
                }
            }

            foreach (Node child in node.GetChildren())
            {
                ScaleUi(child, totalFactor, scaleFactor);
            }
        }
    }
}

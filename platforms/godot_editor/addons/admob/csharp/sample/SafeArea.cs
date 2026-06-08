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
using PoingStudios.AdMob.Sample;

public partial class SafeArea : MarginContainer
{
	private float _ad_margin_top = 0.0f;
	private float _ad_margin_bottom = 0.0f;

	public override void _Ready()
	{
		SampleRegistry.SafeArea = this;
		UpdateSafeArea();
		GetViewport().SizeChanged += UpdateSafeArea;
	}

	public void UpdateAdOverlap(AdView adView)
	{
		ResetAdOverlap();

		if (adView == null)
		{
			return;
		}

		var pos = adView.Position.Value;
		var height = (float)adView.GetHeightInPixels();

		// Mapping AdPosition enum values to top/bottom margins
		if (pos == AdPosition.Values.Top || pos == AdPosition.Values.TopLeft || pos == AdPosition.Values.TopRight)
		{
			_ad_margin_top = height;
		}
		else if (pos == AdPosition.Values.Bottom || pos == AdPosition.Values.BottomLeft || pos == AdPosition.Values.BottomRight)
		{
			_ad_margin_bottom = height;
		}

		UpdateSafeArea();
	}

	public void ResetAdOverlap()
	{
		_ad_margin_top = 0.0f;
		_ad_margin_bottom = 0.0f;
		UpdateSafeArea();
	}

	private void UpdateSafeArea()
	{
		var safeArea = DisplayServer.GetDisplaySafeArea();
		var windowSize = DisplayServer.WindowGetSize();
		var viewportSize = GetViewport().GetVisibleRect().Size;

		// Apply safe area and ad margins
		var platform = OS.GetName();
		bool isMobile = platform == "iOS" || platform == "Android";

		if (windowSize.X == 0 || windowSize.Y == 0)
		{
			return;
		}

		// Scale factor calculation to convert physical pixels to logical UI pixels
		var scaleFactor = viewportSize.Y / (float)windowSize.Y;

		if (float.IsNaN(scaleFactor) || float.IsInfinity(scaleFactor) || scaleFactor <= 0.0f)
		{
			scaleFactor = 1.0f;
		}

		// DisplayServer returns physical screen coordinates for the safe area
		var safeTop = 0f;
		var safeLeft = 0f;
		var safeBottom = 0f;
		var safeRight = 0f;

		if (isMobile)
		{
			safeTop = (float)safeArea.Position.Y;
			safeLeft = (float)safeArea.Position.X;
			safeBottom = (float)(windowSize.Y - (safeArea.Position.Y + safeArea.Size.Y));
			safeRight = (float)(windowSize.X - (safeArea.Position.X + safeArea.Size.X));
		}

		// Apply final margins scaled to the viewport
		ApplyMargins(
			Mathf.Max(0f, (safeTop + _ad_margin_top) * scaleFactor),
			Mathf.Max(0f, safeLeft * scaleFactor),
			Mathf.Max(0f, (safeBottom + _ad_margin_bottom) * scaleFactor),
			Mathf.Max(0f, safeRight * scaleFactor)
		);
	}

	private void ApplyMargins(float top, float left, float bottom, float right)
	{
		AddThemeConstantOverride("margin_top", (int)top);
		AddThemeConstantOverride("margin_left", (int)left);
		AddThemeConstantOverride("margin_bottom", (int)bottom);
		AddThemeConstantOverride("margin_right", (int)right);
	}
}

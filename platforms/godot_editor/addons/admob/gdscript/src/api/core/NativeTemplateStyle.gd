# MIT License
#
# Copyright (c) 2023-present Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name NativeTemplateStyle

const SMALL = "small"
const MEDIUM = "medium"

var template_id: String = MEDIUM # small or medium
var main_background_color: Variant # Color or null
var primary_text: NativeTemplateTextStyle
var secondary_text: NativeTemplateTextStyle
var tertiary_text: NativeTemplateTextStyle
var call_to_action_text: NativeTemplateTextStyle

func convert_to_dictionary() -> Dictionary:
	return {
		"template_id": template_id,
		"main_background_color": main_background_color.to_html(true) if typeof(main_background_color) == TYPE_COLOR else "",
		"primary_text": primary_text.convert_to_dictionary() if primary_text != null else null,
		"secondary_text": secondary_text.convert_to_dictionary() if secondary_text != null else null,
		"tertiary_text": tertiary_text.convert_to_dictionary() if tertiary_text != null else null,
		"call_to_action_text": call_to_action_text.convert_to_dictionary() if call_to_action_text != null else null
	}

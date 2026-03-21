# MIT License

# Copyright (c) 2023-present Poing Studios

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name AdColonyMediationExtras
extends MediationExtras

const SHOW_PRE_POPUP_KEY  = "SHOW_PRE_POPUP_KEY"
const SHOW_POST_POPUP_KEY = "SHOW_POST_POPUP_KEY"

var show_pre_popup : bool : 
	set(value):
		extras[SHOW_PRE_POPUP_KEY] = value

var show_post_popup : bool : 
	set(value):
		extras[SHOW_POST_POPUP_KEY] = value

func _get_android_mediation_extra_class_name() -> String:
	return "com.poingstudios.godot.admob.mediation.adcolony.AdColonyExtrasBuilder"

func _get_ios_mediation_extra_class_name() -> String:
	return "AdColonyExtrasBuilder"

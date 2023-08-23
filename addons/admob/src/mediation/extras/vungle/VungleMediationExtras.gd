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

class_name VungleMediationExtras
extends MediationExtras

const ALL_PLACEMENTS_KEY := "ALL_PLACEMENTS_KEY"
const USER_ID_KEY := "USER_ID_KEY"
const SOUND_ENABLED_KEY := "SOUND_ENABLED_KEY"

var all_placements : Array[String] : 
	set(value):
		extras[ALL_PLACEMENTS_KEY] = str(value)

var user_id : String : 
	set(value):
		extras[USER_ID_KEY] = value

var sound_enabled : bool : 
	set(value):
		extras[SOUND_ENABLED_KEY] = value

func _get_ios_mediation_extra_class_name() -> String:
	return "VunglePoingExtrasBuilder"

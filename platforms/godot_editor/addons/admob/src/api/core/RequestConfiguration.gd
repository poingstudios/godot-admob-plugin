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

class_name RequestConfiguration

const DEVICE_ID_EMULATOR := "B3EEABB8EE11C2BE770B684D95219ECB"

enum TagForChildDirectedTreatment{
	UNSPECIFIED = -1,
	FALSE = 0,
	TRUE = 1
}

enum TagForUnderAgeOfConsent{
	UNSPECIFIED = -1,
	FALSE = 0,
	TRUE = 1
}

const MAX_AD_CONTENT_RATING_UNSPECIFIED := ""
const MAX_AD_CONTENT_RATING_G := "G"
const MAX_AD_CONTENT_RATING_PG := "PG"
const MAX_AD_CONTENT_RATING_T := "T"
const MAX_AD_CONTENT_RATING_MA := "MA"

var max_ad_content_rating : String = MAX_AD_CONTENT_RATING_UNSPECIFIED
var tag_for_child_directed_treatment : int = TagForChildDirectedTreatment.UNSPECIFIED
var tag_for_under_age_of_consent : int = TagForUnderAgeOfConsent.UNSPECIFIED
var test_device_ids : Array[String]

func convert_to_dictionary() -> Dictionary:
	return {
		"max_ad_content_rating" : max_ad_content_rating,
		"tag_for_child_directed_treatment" : tag_for_child_directed_treatment,
		"tag_for_under_age_of_consent" : tag_for_under_age_of_consent
	}

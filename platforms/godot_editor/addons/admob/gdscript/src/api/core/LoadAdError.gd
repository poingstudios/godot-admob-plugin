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

class_name LoadAdError
extends AdError

var response_info : ResponseInfo

func _init(response_info : ResponseInfo, code : int, domain : String, message : String, cause : AdError):
	super._init(code, domain, message, cause)
	self.response_info = response_info


static func create(load_ad_error_dictionary : Dictionary) -> AdError:
	if not load_ad_error_dictionary.is_empty():
		var adError := AdError.create(load_ad_error_dictionary)
		var responseInfo := ResponseInfo.create(load_ad_error_dictionary["response_info"])
		
		return LoadAdError.new(responseInfo, adError.code, adError.domain, adError.message, adError.cause)
	return null

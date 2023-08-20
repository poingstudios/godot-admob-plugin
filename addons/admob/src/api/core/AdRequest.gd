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

class_name AdRequest

var keywords : Array[String]
var mediation_extras : Array[MediationExtras]
var extras : Dictionary

func convert_to_dictionary() -> Dictionary:
	return {
		"mediation_extras" : _transform_mediation_extras_to_dictionary(),
		"extras" : extras
	}

func _transform_mediation_extras_to_dictionary() -> Dictionary:
	var mediation_extras_dictionary : Dictionary
	for i in mediation_extras.size():
		var extra = mediation_extras[i] as MediationExtras
		mediation_extras_dictionary[i] = {
			"class_name" : extra.get_class_name(),
			"extras" : extra.extras
		}
	return mediation_extras_dictionary

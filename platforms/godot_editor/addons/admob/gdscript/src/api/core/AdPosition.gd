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

class_name AdPosition

enum Values {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
	CENTER,
	CUSTOM = -1
}

static var TOP := AdPosition.new(Values.TOP)
static var BOTTOM := AdPosition.new(Values.BOTTOM)
static var LEFT := AdPosition.new(Values.LEFT)
static var RIGHT := AdPosition.new(Values.RIGHT)
static var TOP_LEFT := AdPosition.new(Values.TOP_LEFT)
static var TOP_RIGHT := AdPosition.new(Values.TOP_RIGHT)
static var BOTTOM_LEFT := AdPosition.new(Values.BOTTOM_LEFT)
static var BOTTOM_RIGHT := AdPosition.new(Values.BOTTOM_RIGHT)
static var CENTER := AdPosition.new(Values.CENTER)

var value: int
var offset := Vector2i(Values.CUSTOM, Values.CUSTOM)

func _init(value: int, offset := Vector2i(Values.CUSTOM, Values.CUSTOM)) -> void:
	self.value = value
	self.offset = offset

static func custom(x: int, y: int) -> AdPosition:
	return AdPosition.new(Values.CUSTOM, Vector2i(x, y))

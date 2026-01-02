# MIT License

# Copyright (c) 2026-present Poing Studios

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

extends PopupMenu

enum Items {
	Patreon,
	KoFi,
	PayPal
}

func _init() -> void:
	name = "Support"
	
	add_item(str(Items.keys()[Items.Patreon]))
	add_item(str(Items.keys()[Items.KoFi]))
	add_item(str(Items.keys()[Items.PayPal]))
	
	id_pressed.connect(_on_id_pressed)

func _on_id_pressed(id: int) -> void:
	match id:
		Items.Patreon:
			OS.shell_open("https://www.patreon.com/poingstudios")
		Items.KoFi:
			OS.shell_open("https://ko-fi.com/poingstudios")
		Items.PayPal:
			OS.shell_open("https://www.paypal.com/donate/?hosted_button_id=EBUVPEGF4BUR8")

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

func show_confirmation(text: String, on_confirmed: Callable, ok_text := "OK") -> void:
	var dialog := ConfirmationDialog.new()
	dialog.title = "AdMob"
	dialog.dialog_text = text
	dialog.ok_button_text = ok_text
	dialog.exclusive = false
	
	EditorInterface.get_base_control().add_child(dialog)
	dialog.get_cancel_button().text = "Close"
	
	dialog.confirmed.connect(on_confirmed)
	dialog.visibility_changed.connect(func(): if not dialog.visible: dialog.queue_free())
	
	dialog.popup_centered()

# MIT License
#
# Copyright (c) 2026 Poing Studios
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

import subprocess
import sys


def get_git_diff(base_ref):
    try:
        diff = subprocess.check_output(
            ["git", "diff", f"origin/{base_ref}...HEAD"]
        ).decode("utf-8")
    except Exception as e:
        print(f"Failed to get git diff: {e}", file=sys.stderr)
        sys.exit(1)
    return diff


def annotate_diff(diff_text):
    lines = diff_text.splitlines()
    annotated = []
    current_file = None
    new_line_num = 0
    valid_lines = set()

    for line in lines:
        if line.startswith("diff --git"):
            parts = line.split(" ")
            if len(parts) >= 4:
                current_file = parts[3][2:]
            new_line_num = 0
            annotated.append(line)
        elif line.startswith("+++ b/"):
            current_file = line[6:]
            annotated.append(line)
        elif line.startswith("--- a/") or line.startswith("index "):
            annotated.append(line)
        elif line.startswith("\\ No newline at end of file"):
            annotated.append(line)
        elif line.startswith("@@"):
            annotated.append(line)
            try:
                header = line.split("@@")[1].strip()
                new_part = header.split(" ")[1]
                new_start = int(new_part.split(",")[0][1:])
                new_line_num = new_start
            except (ValueError, IndexError):
                pass
        elif current_file:
            if line.startswith("+"):
                annotated.append(f"[{current_file} L{new_line_num}] {line}")
                valid_lines.add((current_file, new_line_num))
                new_line_num += 1
            elif line.startswith("-"):
                annotated.append(f"[{current_file} DELETED] {line}")
            else:
                annotated.append(f"[{current_file} L{new_line_num}] {line}")
                valid_lines.add((current_file, new_line_num))
                new_line_num += 1
        else:
            annotated.append(line)

    return "\n".join(annotated), valid_lines


def split_diff_by_file(diff_text):
    lines = diff_text.splitlines(keepends=True)
    blocks = []
    current = []
    for line in lines:
        if line.startswith("diff --git") and current:
            blocks.append("".join(current))
            current = [line]
        else:
            current.append(line)
    if current:
        blocks.append("".join(current))
    return blocks


def split_batches(file_blocks, max_chars):
    batches = []
    current = []
    current_size = 0
    for block in file_blocks:
        if current and current_size + len(block) > max_chars:
            batches.append(current)
            current = []
            current_size = 0
        current.append(block)
        current_size += len(block)
    if current:
        batches.append(current)
    return batches

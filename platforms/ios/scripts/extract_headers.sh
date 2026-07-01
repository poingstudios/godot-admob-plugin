#!/bin/bash

rsync -a -m -R --include '*/' --include '*.h' --include '*.inc' --exclude '*' ./godot ./bin/extracted_headers

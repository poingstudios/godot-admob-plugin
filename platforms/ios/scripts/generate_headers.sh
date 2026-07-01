#!/bin/bash
if [[ "$1" == "3.x" ]];
then
    cd ./godot && \
        ./../scripts/timeout scons platform=iphone target=release_debug --keep-going core/version_generated.gen.h core/method_bind.gen.inc modules/modules_enabled.gen.h
else
    cd ./godot && \
        ./../scripts/timeout scons platform=ios target=template_release --keep-going core/version_generated.gen.h core/disabled_classes.gen.h modules/modules_enabled.gen.h
fi
# Godot-AdMob-Editor-Plugin
This repository is for Godot's Addons to integrate natively AdMob to your Game Project without much configurations, with a beautiful UI and directly inside Godot Editor!

<u>is pretty basic right now, but with time will be improved</u>

# Installation:

Please read this tutorial: https://docs.godotengine.org/pt_BR/stable/tutorials/plugins/editor/installing_plugins.html

Manual:
1. Go to Tags of the project: https://github.com/Poing-Studios/Godot-AdMob-Editor-Plugin/tags
2. Download and extract the `.zip` or `.tar.gz`
3. Put the "addons/admob" folder which was extracted into your "res://addons" of your Game Project

Godot Asset Library:
1. Find the Plugin `AdMob` then download and install
2. Enable the Plugin: https://docs.godotengine.org/pt_BR/stable/tutorials/plugins/editor/installing_plugins.html#enabling-a-plugin

# Usage: 

After you installed, the Plugin will automaticly add an AutoLoad called `MobileAds`, this is the AdMob for Godot and you can call methods like: `MobileAds.load_banner()` to show a banner ad!

A example scene is here: `res://addons/admob/develop/Example.tscn`

To your plugin work, you need to download the `AdMob Plugin` here: https://github.com/Poing-Studios/Godot-AdMob-Android-iOS#readme

On `Export -> Resources -> Filters to export non-resources...`, you need to put this: `res://addons/admob/*.json`

A video tutorial is in work progress.

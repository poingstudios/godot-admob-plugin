# Poing Studios Godot AdMob AppLovin Mediation
-keep class com.poingstudios.godot.admob.applovin.** { *; }
-keepclassmembers class com.poingstudios.godot.admob.applovin.** { *; }
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

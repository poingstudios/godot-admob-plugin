# Poing Studios Godot AdMob Meta Mediation
-keep class com.poingstudios.godot.admob.mediation.meta.** { *; }
-keepclassmembers class com.poingstudios.godot.admob.mediation.meta.** { *; }
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

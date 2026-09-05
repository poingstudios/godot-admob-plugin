# Poing Studios Godot AdMob IronSource Mediation
-keep class com.poingstudios.godot.admob.mediation.ironsource.** { *; }
-keepclassmembers class com.poingstudios.godot.admob.mediation.ironsource.** { *; }
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

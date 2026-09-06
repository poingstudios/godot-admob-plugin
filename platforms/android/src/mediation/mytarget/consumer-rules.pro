# Poing Studios Godot AdMob myTarget Mediation
-keep class com.poingstudios.godot.admob.mytarget.** { *; }
-keepclassmembers class com.poingstudios.godot.admob.mytarget.** { *; }
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

# Suppress harmless warning from myTarget tracer service provider
-dontwarn ru.ok.tracer.**

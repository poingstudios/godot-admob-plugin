# Poing Studios Godot AdMob Plugin
-keep class com.poingstudios.godot.admob.** { *; }
-keepclassmembers class com.poingstudios.godot.admob.** { *; }

# Preserve Godot Plugin entry points and exported methods
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

# Preserve native JNI methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Suppress harmless warnings from Kotlin metadata and optional mediation dependencies
-dontwarn kotlin.Metadata
-dontwarn com.android.billingclient.**
-dontwarn com.bytedance.sdk.**
-dontwarn com.tiktok.**
-dontwarn jp.maio.sdk.**

# Poing Studios Godot AdMob BidMachine Mediation
-keep class com.poingstudios.godot.admob.mediation.bidmachine.** { *; }
-keepclassmembers class com.poingstudios.godot.admob.mediation.bidmachine.** { *; }
-keep class * extends org.godotengine.godot.plugin.GodotPlugin { *; }
-keepclassmembers class * extends org.godotengine.godot.plugin.GodotPlugin {
    @org.godotengine.godot.plugin.UsedByGodot <methods>;
}

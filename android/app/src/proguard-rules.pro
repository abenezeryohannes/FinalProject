## Flutter wrapper
 -keep class io.flutter.app.** { *; }
 -keep class io.flutter.plugin.** { *; }
 -keep class io.flutter.util.** { *; }
 -keep class io.flutter.view.** { *; }
 -keep class io.flutter.** { *; }
 -keep class io.flutter.plugins.** { *; }
 -dontwarn io.flutter.embedding.**

#
# ##---------------Begin: proguard configuration for Gson ----------
# # Gson uses generic type information stored in a class file when working with
# #fields. Proguard removes such information by default, so configure it to keep
# #all of it.
# -keepattributes Signature
#
# # For using GSON @Expose annotation
# -keepattributes *Annotation*
#
# # Gson specific classes
# -keep class sun.misc.Unsafe { *; }
# #-keep class com.google.gson.stream.** { *; }
#
# # Application classes that will be serialized/deserialized over Gson
# -keep class com.askual.ethiocare.databasepackage.** { *; }
# -keepclassmembers class com.askual.ethiocare.databasepackage.** { *; }

 ##---------------End: proguard configuration for Gson ----------

 -ignorewarnings

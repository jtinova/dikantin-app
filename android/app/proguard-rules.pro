# ----------------------------------
# FLUTTER & DART CORE
# ----------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.google.flutter.** { *; }

# Mencegah R8 membuang kode penting penghubung (bridge)
-keepattributes SourceFile,LineNumberTable
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes *Annotation*

# ----------------------------------
# FIREBASE & GOOGLE SERVICES (FCM, Auth, Maps)
# ----------------------------------
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.googlequicksearchbox.** { *; }
-keep class com.google.ads.** { *; }

# Mencegah warning umum Firebase
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.errorprone.annotations.**

# ----------------------------------
# PLUGINS KHUSUS DI PROJECT 
# ----------------------------------

# 1. Lottie Animations
-keep class com.airbnb.lottie.** { *; }
-dontwarn com.airbnb.lottie.**

# 2. Barcode Scanner / QR Code
# Mencegah penghapusan library scanning (ZXing sering dipakai library ini)
-keep class com.google.zxing.** { *; }
-keep class de.mintware.barcode_scan.** { *; }
-dontwarn de.mintware.barcode_scan.**

# 3. Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# 4. Sqflite (Database)
-keep class com.tekartik.sqflite.** { *; }

# 5. Connectivity Plus
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# 6. WebView (Jika dipakai oleh plugin pembayaran/midtrans/dll)
-keep class android.webkit.** { *; }

# ----------------------------------
# OKHTTP & RETROFIT (Dipakai oleh library network)
# ----------------------------------
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**
-dontwarn okio.**
-dontwarn javax.annotation.**

# ----------------------------------
# SAFETY NET 
# ----------------------------------
# Abaikan warning yang tidak kritikal agar build tidak gagal
-ignorewarnings
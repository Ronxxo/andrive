plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Gradle Plugin
}

android {
    namespace = "com.example.food_trailer_quotation"
    compileSdkVersion = 33 // Cambia "33" por la versión que estés utilizando
    ndkVersion = "25.2.9519653" // Asegúrate de que esta versión esté instalada

    defaultConfig {
        applicationId = "com.example.food_trailer_quotation"
        minSdkVersion = 21 // Cambia "21" según las necesidades de tu proyecto
        targetSdkVersion = 33 // Cambia "33" por la versión que estés utilizando
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}
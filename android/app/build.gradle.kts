import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Code to load key.properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.electron_iq"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.electron_iq"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // The signingConfigs block for your release key
    signingConfigs {
        create("release") {
            // Add null checks and proper error handling
            if (keystorePropertiesFile.exists() && 
                keystoreProperties.containsKey("keyAlias") &&
                keystoreProperties.containsKey("keyPassword") &&
                keystoreProperties.containsKey("storeFile") &&
                keystoreProperties.containsKey("storePassword")) {
                
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            } else {
                // Fallback or error handling
                println("Warning: key.properties file is missing or incomplete. Using debug signing for release build.")
                // You can either use debug config or throw an error
                keyAlias = "androiddebugkey"
                keyPassword = "android"
                storeFile = file(System.getProperty("user.home") + "/.android/debug.keystore")
                storePassword = "android"
            }
        }
    }

    buildTypes {
        getByName("release") {
            // Only apply signing config if keystore file exists
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
            // For Flutter apps, it's generally recommended to keep minification disabled
            // to avoid potential issues with reflection and dynamic code
            isMinifyEnabled = false
            isShrinkResources = false // This must be false when minification is disabled
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
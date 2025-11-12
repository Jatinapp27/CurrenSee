plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
    // Google services plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.currensee_pkr"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.currensee_pkr"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use debug signing config for now
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))

    // Firebase dependencies (versions are managed by BoM)
    implementation("com.google.firebase:firebase-analytics")

    // Add any other Firebase dependencies you need, e.g.
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
}

// Apply the Google services plugin at the bottom (optional if using plugins block)
 apply plugin: 'com.google.gms.google-services'

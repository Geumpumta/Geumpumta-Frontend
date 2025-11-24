import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.geumpumta"
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
        applicationId = "com.geumpumgalchwi.geumpumta"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            val keyAliasValue = keystoreProperties["keyAlias"] as? String
            val keyPasswordValue = keystoreProperties["keyPassword"] as? String
            val storeFileValue = keystoreProperties["storeFile"] as? String
            val storePasswordValue = keystoreProperties["storePassword"] as? String
            
            if (keyAliasValue != null && keyPasswordValue != null && 
                storeFileValue != null && storePasswordValue != null) {
                create("release") {
                    keyAlias = keyAliasValue
                    keyPassword = keyPasswordValue
                    storeFile = file(storeFileValue)
                    storePassword = storePasswordValue
                }
            }
        }
    }

    buildTypes {
        release {
            if (keystorePropertiesFile.exists() && 
                signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            }

            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

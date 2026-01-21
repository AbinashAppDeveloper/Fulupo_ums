plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    flavorDimensions("flavor-type")
    productFlavors {
    create("dev") {
        dimension = "flavor-type"
        applicationId = "com.tabsquare.FulupoUMS.dev"
        resValue("string", "app_name", "FulupoUMS Dev")
    }
    create("prod") {
        dimension = "flavor-type"
        applicationId = "com.tabsquare.FulupoUMS"
        resValue("string", "app_name", "FulupoUMS")
    }
    create("demo") {
        dimension = "flavor-type"
        applicationId = "com.tabsquare.FulupoUMS.demo"
        resValue("string", "app_name", "FulupoUMS Demo")
    }
}

    namespace = "com.tabsquare.FulupoUMS"
    compileSdk = 36
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
        applicationId = "com.tabsquare.FulupoUMS"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
       
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

                    isMinifyEnabled = true
        isShrinkResources = true

        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Existing dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    
    // Add OkHttp dependencies
    implementation("com.squareup.okhttp3:okhttp:4.9.3")
    implementation("com.squareup.okhttp3:okhttp-urlconnection:4.9.3")
}

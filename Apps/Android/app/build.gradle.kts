/**
 * app/build.gradle.kts
 *
 * @package Sngine
 * @author Zamblek
 */

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.baselineprofile)
}

android {
    namespace = "sngine.app.webview"
    compileSdk = 37

    defaultConfig {
        applicationId = "sngine.app.webview"
        minSdk = 27
        targetSdk = 36
        versionCode = 19
        versionName = "5.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    lint {
        abortOnError = true
        // The density PNG launcher icons are required fallbacks for the adaptive icon.
        disable += "IconXmlAndPng"
    }
}

dependencies {
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.core.splashscreen)
    implementation(libs.androidx.activity.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.androidx.lifecycle.runtime.ktx)
    implementation(libs.androidx.webkit)
    implementation(libs.androidx.swiperefreshlayout)
    implementation(libs.androidx.profileinstaller)
    implementation(libs.material)
    implementation(libs.play.services.location)
    implementation(libs.play.review.ktx)
    implementation(libs.kotlinx.coroutines.play.services)
    implementation(libs.onesignal)

    baselineProfile(project(":baselineprofile"))

    testImplementation(libs.junit)
}

# flutter_offerwall_module

A new Flutter module project.

# Getting Started

## Docs flutter module

- [documentation android](https://docs.flutter.dev/add-to-app/android/project-setup?tab=with-android-studio).

- [documentation ios](https://docs.flutter.dev/add-to-app/ios/project-setup).

## Android

### Step 1: Build AAR

```
    flutter build aar
```

![Alt text](image.png)

- More specifically, this command creates (by default all debug/profile/release modes) a local repository, with the following files:

```
build/host/outputs/repo
└── com
    └── example
        └── flutter_module
            ├── flutter_release
            │   ├── 1.0
            │   │   ├── flutter_release-1.0.aar
            │   │   ├── flutter_release-1.0.aar.md5
            │   │   ├── flutter_release-1.0.aar.sha1
            │   │   ├── flutter_release-1.0.pom
            │   │   ├── flutter_release-1.0.pom.md5
            │   │   └── flutter_release-1.0.pom.sha1
            │   ├── maven-metadata.xml
            │   ├── maven-metadata.xml.md5
            │   └── maven-metadata.xml.sha1
            ├── flutter_profile
            │   ├── ...
            └── flutter_debug
                └── ...

```

- To depend on the AAR, the host app must be able to find these files. To do that, edit app/build.gradle in your host app so that it includes the local repository and the dependency:

```
android {
  // ...
}

repositories {
  maven {
    url 'some/path/flutter_module/build/host/outputs/repo'
    // This is relative to the location of the build.gradle file
    // if using a relative path.
  }
  maven {
    url 'https://storage.googleapis.com/download.flutter.io'
  }
}

dependencies {
  // ...
  debugImplementation 'com.example.flutter_module:flutter_debug:1.0'
  profileImplementation 'com.example.flutter_module:flutter_profile:1.0'
  releaseImplementation 'com.example.flutter_module:flutter_release:1.0'
}
```
### Step 2: Add a normal Flutter screen

- Add FlutterActivity to AndroidManifest.xml
  
Flutter provides FlutterActivity to display a Flutter experience within an Android app. Like any other Activity, FlutterActivity must be registered in your AndroidManifest.xml. Add the following XML to your AndroidManifest.xml file under your application tag:

```
<activity
  android:name="io.flutter.embedding.android.FlutterActivity"
  android:theme="@style/LaunchTheme"
  android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
  android:hardwareAccelerated="true"
  android:windowSoftInputMode="adjustResize"
  />
```
The reference to @style/LaunchTheme can be replaced by any Android theme that want to apply to your FlutterActivity. The choice of theme dictates the colors applied to Android’s system chrome, like Android’s navigation bar, and to the background color of the FlutterActivity just before the Flutter UI renders itself for the first time.



- Launch FlutterActivity
  
With FlutterActivity registered in your manifest file, add code to launch FlutterActivity from whatever point in your app that you’d like. The following example shows FlutterActivity being launched from an OnClickListener.
```
import io.flutter.embedding.android.FlutterActivity;

```

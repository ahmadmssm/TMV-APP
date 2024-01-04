
tasks.register<customTasks.versioning.android.IncrementAndroidVersionName>("incrementAndroidMajorVersionName") {
  releaseType = customTasks.versioning.android.IncrementAndroidVersionName.ReleaseType.Major
}

tasks.register<customTasks.versioning.android.IncrementAndroidVersionName>("incrementAndroidMinorVersionName") {
  releaseType = customTasks.versioning.android.IncrementAndroidVersionName.ReleaseType.Minor
}

tasks.register<customTasks.versioning.android.IncrementAndroidVersionName>("incrementAndroidFixVersionName") {
  releaseType = customTasks.versioning.android.IncrementAndroidVersionName.ReleaseType.Fix
}

tasks.register<customTasks.versioning.android.IncrementAndroidVersionCode>("incrementAndroidVersionCode") {
  doLast {
    println("Version Code ${Versions.versionCode}")
  }
}

tasks.register<Exec>("uploadDebugApkToFirebaseAppDistribution") {
  dependsOn("incrementAndroidVersionCode", "assembleDebug")
  val apkPath = "APK_PATH=$rootDir${properties["APK_PATH"]}"
  val firebaseProjectId = "FIB_PID=${properties["FIB_PID"]}"
  commandLine("$rootDir/.scripts/UploadApkToFirebaseAppDistribution.sh").args(apkPath, firebaseProjectId)
}

//tasks.register<Exec>("uploadReleaseApkToFirebaseAppDistribution") {
//  dependsOn("incrementAndroidVersionCode", "assembleRelease")
//  val apkPath = "APK_PATH=$rootDir${properties["APK_PATH"]}"
//  val firebaseProjectId = "FIB_PID=${properties["FIB_PID"]}"
//  commandLine("$rootDir/.scripts/UploadApkToFirebaseAppDistribution.sh").args(apkPath, firebaseProjectId)
//}
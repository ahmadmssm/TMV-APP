
tasks.register<customTasks.versioning.iOS.IncrementIosBundleShortVersion>("incrementIosMajorVersionNameDev") {
    buildType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.BuildType.Development
    releaseType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.ReleaseType.Major
}

tasks.register<customTasks.versioning.iOS.IncrementIosBundleShortVersion>("incrementIosMajorVersionNameProd") {
    buildType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.BuildType.Production
    releaseType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.ReleaseType.Major
}

tasks.register<customTasks.versioning.iOS.IncrementIosBundleShortVersion>("incrementIosMinorVersionNameDev") {
    buildType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.BuildType.Development
    releaseType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.ReleaseType.Minor
}

tasks.register<customTasks.versioning.iOS.IncrementIosBundleShortVersion>("incrementIosMinorVersionNameProd") {
    buildType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.BuildType.Production
    releaseType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.ReleaseType.Minor
}

tasks.register<customTasks.versioning.iOS.IncrementIosBundleShortVersion>("incrementIosFixVersionNameDev") {
    buildType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.BuildType.Development
    releaseType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.ReleaseType.Fix
}

tasks.register<customTasks.versioning.iOS.IncrementIosBundleShortVersion>("incrementIosFixVersionNameProd") {
    buildType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.BuildType.Production
    releaseType = customTasks.versioning.iOS.IncrementIosBundleShortVersion.ReleaseType.Fix
}

tasks.register<Exec>("uploadDebugIpaToFirebaseAppDistribution") {
    dependsOn("incrementIosFixVersionNameDev")
    val iOSProjectName = "PROJECT_NAME=iosApp"
    val firebaseProjectId = "FIB_PID=${properties["FIB_PID"]}"
    val xCodeScheme = "XCODE_SCHEME=${properties["XCODE_SCHEME"]}"
    commandLine("$rootDir/.scripts/FirebaseBuildArchiveUploadIPA.sh").args(iOSProjectName, firebaseProjectId, xCodeScheme)
}

tasks.register<Exec>("uploadReleaseIpaToAppStore") {
    if (properties["VERSION"] == "Major")
        dependsOn("incrementIosMajorVersionNameProd")
    else if (properties["VERSION"] == "Minor")
        dependsOn("incrementIosMinorVersionNameProd")
    else
        dependsOn("incrementIosFixVersionNameProd")
    val iOSProjectName = "PROJECT_NAME=iosApp"
    val appStoreUserName = "APP_STORE_USER=${properties["APP_STORE_USER"]}"
    val appStorePass = "APP_STORE_PASS=${properties["APP_STORE_PASS"]}"
    val xCodeScheme = "XCODE_SCHEME=${properties["XCODE_SCHEME"]}"
    commandLine("$rootDir/.scripts/AppStoreBuildArchiveDistributeIPA.sh").args(iOSProjectName, appStoreUserName, appStorePass, xCodeScheme)
}
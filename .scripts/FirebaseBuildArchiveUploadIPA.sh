#!/bin/bash
for ((i=0; i<=$#; i++))
do
	IFS== read -r ARG_NAME ARG_VALUE <<< "${!i}"
	if [[ "$ARG_NAME" == *"PROJECT_NAME"* ]]; then
		PROJECT_NAME=$(echo $ARG_VALUE)
	elif [[ "$ARG_NAME" == *"FIB_PID"* ]]; then
		FIB_PID=$(echo $ARG_VALUE)
	elif [[ "$ARG_NAME" == *"XCODE_SCHEME"* ]]; then
	  XCODE_SCHEME=$(echo $ARG_VALUE)
	fi
done
#
SCRIPT_NAME=${0##*/}
#
if [ -z "$PROJECT_NAME" ] || [ "$PROJECT_NAME" == null ]; then
	echo "⚠️ iOS project name is not set, please make sure to run the gradle task as shown in the Commands.md file";
	exit 1
elif [ -z "$FIB_PID" ] || [ "$FIB_PID" == null ]; then
	echo "⚠️ Firebase Project ID is not set, please make sure to run the gradle task as shown in the Commands.md file";
	exit 1
elif [ -z "$XCODE_SCHEME" ] || [ "$XCODE_SCHEME" == null ]; then
  echo "⚠️ Scheme name is not set, please make sure to run the gradle task as shown in the Commands.md file";
	exit 1
else
	PROJECT_ROOT_DIRECTORY=${PWD%/*}
	source "$PROJECT_ROOT_DIRECTORY/secrets/tokens.properties"
	FIREBASE_TOKEN="$firebaseToken"
	cd "$PROJECT_ROOT_DIRECTORY/$PROJECT_NAME"
	echo "➡️ cd to $PWD"
	ARCHIVE_PATH="build/iosApp.xcarchive"
	echo "➡️ iOS project name : $PROJECT_NAME"
	echo "➡️ Firebase Project ID : $FIB_PID"
	echo "➡️ Archive Path : $PWD/$ARCHIVE_PATH"
	fi
	#
	echo "➡️ Building IPA"
	xcodebuild archive -scheme "$XCODE_SCHEME" -sdk iphoneos -allowProvisioningUpdates -archivePath "$ARCHIVE_PATH" -destination "generic/platform=iOS"
	#
	if xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportPath "build/IPA" -exportOptionsPlist "iosApp/DevExportOptions.plist" ; then
		rm -rf "$ARCHIVE_PATH"
		echo "➡️ IPA Generated Successfully ✅"
		# Ref: https://firebase.google.com/docs/app-distribution/android/distribute-cli#step_2_distribute_your_app_to_testers
		if firebase appdistribution:distribute "$PWD/build/IPA/iosApp.ipa" --app $FIB_PID --token "$FIREBASE_TOKEN"  --release-notes-file  "$PROJECT_ROOT_DIRECTORY/ChangeLog.txt"  --groups-file "$PROJECT_ROOT_DIRECTORY/firebaseDistribution/groups.txt" --debug ; then
			# Remove build folder
			rm -rf "$PWD/build"
			echo "➡️ Successfully uploaded a new IPA to Firebase distribution ✅"
			exit 0
		else
			rm -rf "$ARCHIVE_PATH"
			echo "➡️ Upload IPA to Firebase distribution failed 🚫"
			exit 1
		fi
	else
		echo "➡️ Failed to build an IPA 🚫"
		exit 1
	fi
fi
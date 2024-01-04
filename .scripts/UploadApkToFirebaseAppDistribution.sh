#!/bin/bash
for ((i=1; i<=$#; i++))
do
	IFS== read -r ARG_NAME ARG_VALUE <<< "${!i}"
	if [[ "$ARG_NAME" == *"APK_PATH"* ]]; then
		APK_PATH=$(echo $ARG_VALUE)
	elif [[ "$ARG_NAME" == *"FIB_PID"* ]]; then
		FIB_PID=$(echo $ARG_VALUE)
	fi
done
#
SCRIPT_NAME=${0##*/}
#
if [ -z "$APK_PATH" ] || [ "$APK_PATH" == null ]; then 
	echo "⚠️ APK path is not set, please path the APK path as a a pram when running this $SCRIPT_NAME command";
	exit 1
elif [ -z "$FIB_PID" ] || [ "$FIB_PID" == null ]; then 
	echo "⚠️ Firebase Project ID is not set, please path the Firebase Project ID as a aprams when running this $SCRIPT_NAME command"; 
	exit 1
else 
	echo "➡️ APK path : $APK_PATH"
	echo "➡️ Firebase Project ID : $FIB_PID"
	#
	FIREBASE_TOKEN="$firebaseToken"
	PROJECT_ROOT_DIRECTORY=${PWD%/*}
	#
	source "$PROJECT_ROOT_DIRECTORY/secrets/tokens.properties"
	#
	files=("$APK_PATH/"*.apk)
	APK=${files[0]}
	# Ref: https://firebase.google.com/docs/app-distribution/android/distribute-cli#step_2_distribute_your_app_to_testers
	if firebase appdistribution:distribute "$APK" --app $FIB_PID --token "$firebaseToken"  --release-notes-file "$PROJECT_ROOT_DIRECTORY/ChangeLog.txt"  --groups-file "$PROJECT_ROOT_DIRECTORY/firebaseDistribution/groups.txt" --debug ; then
		echo "➡️ Successfully uploaded a new APK to Firebase App distribution ✅"
	else
		echo "➡️ Uploading APK to Firebase App distribution failed 🚫"
	fi
fi
#!/bin/bash
for ((i=0; i<=$#; i++))
do
	IFS== read -r ARG_NAME ARG_VALUE <<< "${!i}"
	if [[ "$ARG_NAME" == *"PROJECT_NAME"* ]]; then
		PROJECT_NAME=$(echo $ARG_VALUE)
	elif [[ "$ARG_NAME" == *"APP_STORE_USER"* ]]; then
		APP_STORE_USER=$(echo $ARG_VALUE)
	elif [[ "$ARG_NAME" == *"APP_STORE_PASS"* ]]; then
		APP_STORE_PASS=$(echo $ARG_VALUE)
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
elif [ -z "$APP_STORE_USER" ] || [ "$APP_STORE_USER" == null ]; then 
	echo "⚠️ Invlid app store user Id, please path the app store user Id as a param when running this $SCRIPT_NAME command";
	exit 1
elif [ -z "$APP_STORE_PASS" ] || [ "$APP_STORE_PASS" == null ]; then 
	echo "⚠️ Invlid app store user password, please path the app store password as a param when running this $SCRIPT_NAME command";
	exit 1
elif [ -z "$XCODE_SCHEME" ] || [ "$XCODE_SCHEME" == null ]; then
	echo "⚠️ Scheme name is not set, please make sure to run the gradle task as shown in the Commands.md file";
	exit 1
else
	PROJECT_ROOT_DIRECTORY=${PWD%/*}
	
	cd "$PROJECT_ROOT_DIRECTORY/$PROJECT_NAME"
	echo "➡️ cd to $PWD"
	ARCHIVE_PATH="build/iosApp.xcarchive"
	echo "➡️ Appstore User : $APP_STORE_USER"
	echo "➡️ Appstore Pass: $APP_STORE_PASS"
	echo "➡️ iOS project name : $PROJECT_NAME"
	echo "➡️ Archive Path : $PWD$ARCHIVE_PATH"
	echo "➡️ Project Scheme : $XCODE_SCHEME"
	#
	echo "➡️ Building IPA"
	xcodebuild archive -scheme "$XCODE_SCHEME" -sdk iphoneos -allowProvisioningUpdates -archivePath "$ARCHIVE_PATH" -destination "generic/platform=iOS"
	#
	if xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportPath "build/IPA" -allowProvisioningUpdates -exportOptionsPlist "iosApp/ProdExportOptions.plist" ; then
		rm -rf "$ARCHIVE_PATH"
		echo "➡️ IPA Generated Successfully ✅"
		# 
		# Validate IPA
		if xcrun altool --validate-app --type ios -f "$PWD/build/IPA/iosApp.ipa" -u $APP_STORE_USER -p $APP_STORE_PASS --output-format json --verbose ; then
			echo "➡️ Generated IPA passed validated ✅"
			echo "➡️ Uploading to App store...."
			# Upload to App Store => IPA Path => "$PWD/build/IPA/iosApp.ipa"
			if xcrun altool --upload-app --type ios -f "$PWD/build/IPA/iosApp.ipa" -u $APP_STORE_USER -p $APP_STORE_PASS --output-format json --verbose ; then
				# Remove build folder
				rm -rf "$PWD/build"
				echo "➡️ Successfully uploaded a new IPA to App Store ✅"
				exit 0
			else
				rm -rf "$ARCHIVE_PATH"
				echo "➡️ Upload IPA to App Store failed 🚫"
				exit 1
			fi
		else
			echo "➡️ IPA validation failed 🚫"
			exit 1
		fi
	else
		echo "➡️ Failed to build an IPA 🚫"
		exit 1
	fi
fi
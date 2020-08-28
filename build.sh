#!/bin/bash

flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
cd ~/Projects/2fellows/EXAT-Traffic/app/exat_traffic/build/app/outputs/apk/release || exit
adb -d uninstall isymphonyz.exat
adb -d install app-armeabi-v7a-release.apk
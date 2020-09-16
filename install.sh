#!/bin/bash

cd ~/Projects/2fellows/EXAT-Traffic/app/exat_traffic/build/app/outputs/apk/release || exit
adb -d uninstall isymphonyz.exat
adb -d install app-armeabi-v7a-release.apk
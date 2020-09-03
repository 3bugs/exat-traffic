#!/bin/bash

cd ~/Projects/2fellows/EXAT-Traffic/app/exat_traffic/build/app/outputs/apk/release || exit
adb -e uninstall isymphonyz.exat
adb -e install app-armeabi-v7a-release.apk
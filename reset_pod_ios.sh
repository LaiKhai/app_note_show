#!/bin/bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf ~/.pub-cache/hosted/pub.dartlang.org/
pod cache clean --all
pod repo update
pod install

cd ..
flutter clean
flutter run
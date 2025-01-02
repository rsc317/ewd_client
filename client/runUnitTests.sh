#!/bin/bash
# runServer.sh
# Created by Johannes Grothe on 28.12.24.

killall Simulator || true
xcrun simctl shutdown all
xcrun simctl erase all
xcrun simctl boot "iPhone 16 Pro"
xcodebuild test \
    -project "client.xcodeproj" \
    -scheme "clientTests" \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -testPlan clientUnitTests
killall Simulator || true

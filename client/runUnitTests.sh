#!/bin/bash
# runServer.sh
# Created by Johannes Grothe on 28.12.24.

echo "Stopping and erasing all Eimulators"
killall Simulator || true
xcrun simctl shutdown all
xcrun simctl erase all
xcrun simctl boot "iPhone 16 Pro"

echo "Checking available Simulators"
xcrun simctl list devices

xcodebuild test \
    -project "client.xcodeproj" \
    -scheme "clientTests" \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -testPlan clientUnitTests | xcpretty
TEST_EXIT_CODE=$?
    
killall Simulator || true

# Exit with exit-code from test execution
exit $TEST_EXIT_CODE

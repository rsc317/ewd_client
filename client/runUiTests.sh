#!/bin/bash
# runServer.sh
# Created by Johannes Grothe on 28.12.24.

VERSION=2.9.0
PORT=8443

if ! [ -f "mockServer/wiremock-standalone-$VERSION.jar" ];
then
   cd mockServer & curl -O -L https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/$VERSION/wiremock-standalone-$VERSION.jar
fi

cd mockServer
java -jar wiremock-standalone-$VERSION.jar --port=$PORT &
WIREMOCK_PID=$!

echo "WireMock-Server gestartet mit PID $WIREMOCK_PID"

cd ..

echo "Stopping and erasing all Eimulators"
killall Simulator || true
xcrun simctl shutdown all
xcrun simctl erase all
xcrun simctl boot "iPhone 16 Pro"

echo "Checking available Simulators"
xcrun simctl list devices

xcodebuild test \
    -project "client.xcodeproj" \
    -scheme "clientUITests" \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -testPlan clientUITests \
    -parallel-testing-enabled NO
TEST_EXIT_CODE=$?

echo "Tests returned exit code $TEST_EXIT_CODE"

killall Simulator || true

# Close WireMock-Server
echo "Beende WireMock-Server mit PID $WIREMOCK_PID"
kill $WIREMOCK_PID

# OMake sure, the process was terminated
wait $WIREMOCK_PID 2>/dev/null

# Exit with exit-code from test execution
exit $TEST_EXIT_CODE

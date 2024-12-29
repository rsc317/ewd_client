#!/bin/bash
# runServer.sh
# Created by Johannes Grothe on 28.12.24.

VERSION=2.9.0
PORT=8443

if ! [ -f "wiremock-standalone-$VERSION.jar" ];
then
   curl -O -L https://repo1.maven.org/maven2/com/github/tomakehurst/wiremock-standalone/$VERSION/wiremock-standalone-$VERSION.jar
fi

# java -jar wiremock-standalone-$VERSION.jar --https-port=$PORT --https-keystore=secrets/keystore.jks --keystore-password=ewdbackend

java -jar wiremock-standalone-$VERSION.jar --port=$PORT --verbose

FROM gradle:5.5-jdk8

MAINTAINER Christian Westhoff
LABEL version="0.0.1"
LABEL description="Docker image for react native with android 28"

USER root
ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=28 \
    ANDROID_BUILD_TOOLS_VERSION=28.0.3

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL --silent \
    && unzip sdk.zip \
    && rm sdk.zip \
    && mkdir "$ANDROID_HOME/licenses" || true \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license"
#    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

# Install Build Essentials
RUN apt-get update -yq \
    && apt-get install build-essential -yq \
    && apt-get install file -yq \
    && apt-get install apt-utils -yq

# Install curl and gnupg
RUN apt-get install curl gnupg -yq

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get install nodejs -yq

# Install yarn
RUN npm install yarn -g --silent
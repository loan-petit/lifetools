# Stage 0, "build-stage", to build and compile the client
# Note: updating past stretch (Debian 9) will bump Java past version 8,
# which will break the Android SDK.
FROM debian:stretch as build-stage

ARG FLUTTER_VERSION

# Install required packages
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    git \
    wget \
    curl \
    zip \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    default-jdk-headless

# Install the Android SDK Dependency.
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_HOME="/opt/android_sdk"
RUN mkdir -p "${ANDROID_HOME}"
RUN mkdir -p ~/.android
# Silence warning.
RUN touch ~/.android/repositories.cfg
ENV ANDROID_SDK_ARCHIVE="${ANDROID_HOME}/archive"
RUN wget --progress=dot:giga "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
RUN unzip -q -d "${ANDROID_HOME}" "${ANDROID_SDK_ARCHIVE}"
# Suppressing output of sdkmanager to keep log size down
# (it prints install progress WAY too often).
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" "tools" > /dev/null
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" "build-tools;28.0.3" > /dev/null
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" "platforms;android-28" > /dev/null
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" "platform-tools" > /dev/null
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" "extras;android;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" "extras;google;m2repository" > /dev/null
RUN yes "y" | "${ANDROID_HOME}/tools/bin/sdkmanager" "patcher;v4" > /dev/null
RUN rm "${ANDROID_SDK_ARCHIVE}"
ENV PATH="${ANDROID_HOME}/tools:${PATH}"
ENV PATH="${ANDROID_HOME}/tools/bin:${PATH}"
# Silence warnings when accepting android licenses.
RUN mkdir -p ~/.android
RUN touch ~/.android/repositories.cfg

# Install and check Flutter
ENV FLUTTER_ROOT ${HOME}/sdks/flutter
RUN git clone --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_ROOT}
ENV PATH ${PATH}:${FLUTTER_ROOT}/bin:${FLUTTER_ROOT}/bin/cache/dart-sdk/bin
RUN flutter doctor
ENV PATH ${PATH}:${HOME}/.pub-cache/bin

# Enable flutter web
RUN flutter config --enable-web

WORKDIR /app

# Install dependencies before pushing the rest of the code in order to use
# cached dependencies when a file other than the package.json is changed in
# the current host directory
ADD pubspec.* /app/
RUN pub get

# Copy code ressources
ADD . /app/
ADD nginx.conf /app/
RUN pub get --offline

# Build client files which will be served by nginx
RUN flutter build web -t lib/main_prod.dart

# Build apk file which will be served by nginx.
RUN flutter build apk --debug -t lib/main_prod.dart

# Stage 1, based on Nginx, with the production-ready compiled app
FROM nginx:alpine

RUN mkdir -p /app-packages/

# Copy files builded in stage 0
COPY --from=build-stage /app/build/web/ /usr/share/nginx/html
COPY --from=build-stage /app/build/app/outputs/apk/debug/app-debug.apk /app-packages/app.apk

# Copy the nginx.conf from stage 0
COPY --from=build-stage /app/nginx.conf /etc/nginx/conf.d/default.conf

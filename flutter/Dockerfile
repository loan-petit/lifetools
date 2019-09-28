# Stage 0, "build-stage", based on alpine, to build and compile the frontend
FROM google/dart:latest as build-stage

ARG FLUTTER_VERSION

# Install unzip which is required for flutter doctor
RUN apt-get update && apt-get install unzip

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

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:alpine

COPY --from=build-stage /app/build/web/ /usr/share/nginx/html

# Copy the nginx.conf from stage 0
COPY --from=build-stage /app/nginx.conf /etc/nginx/conf.d/default.conf

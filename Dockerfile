# An example of using a custom Dockerfile with Dart Frog
# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build

ARG DATABASE_HOST
ARG DATABASE_NAME
ARG DATABASE_USERNAME
ARG DATABASE_PASSWORD

WORKDIR /app

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .

# Generate a production build.
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Ensure packages are still up-to-date if anything has changed.


RUN export DATABASE_HOST=${DATABASE_HOST}
RUN export DATABASE_PORT=${DATABASE_PORT}
RUN export DATABASE_NAME=${DATABASE_NAME}
RUN export DATABASE_USERNAME=${DATABASE_USERNAME}
RUN export DATABASE_PASSWORD=${DATABASE_PASSWORD}


RUN dart pub get --offline
RUN dart compile exe build/bin/server.dart -o build/bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/server /app/bin/
# Uncomment the following line if you are serving static files.
# COPY --from=build /app/build/public /public/

# Start the server.
CMD ["/app/bin/server"]
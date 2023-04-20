# Use latest stable channel SDK.
FROM dart:latest AS build

# Create working directory
WORKDIR /app

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY . .

# Resolve app dependencies.
RUN dart pub get
RUN dart pub global activate melos
RUN dart pub run melos bs

# compile server
RUN dart compile exe apps/api/bin/server.dart -o apps/api/bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/apps/api/bin/server /app/bin/

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]

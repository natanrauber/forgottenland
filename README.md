# Forgotten Land Monorepo!

## Environment Variables

Since environment variables are not trivial in Dart/Flutter, we decided on a hybrid approach:

- PROD / remote: The environment variables must be defined on Railway and then configured on the build command of the Dockerfile. See the "Building Cron Scheduler" for example.
- DEV / local: The environment variables must be defined in a .env file inside the root directory of each app.

   Warning: For now, environment variables are configured only for the backend with Dart + Railway.

## Building

### Client

```sh
cd apps/client/
flutter build web --web-renderer html --release
cd ...
```

Warning: For now, it is necessary to build the web client before commiting the changes, since the automatic build is not working on Vercel.

### API

```sh
docker build . -t forgottenland-api -f ./Dockerfile.api
```

```sh
cd apps/api/
dart run bin/server.dart
cd ...
```

### ETL

```sh
docker build . -t forgottenland-etl -f ./Dockerfile.etl
```

```sh
cd apps/etl/
dart run bin/server.dart
cd ...
```

### Cron Scheduler

```sh
docker build . -t forgottenland-cron -f ./Dockerfile.cron --build-arg="PATH_ETL=https://..."
```

```sh
cd apps/cron_scheduler/
dart run bin/cron_scheduler.dart
cd ...
```
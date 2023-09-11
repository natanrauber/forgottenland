# Forgotten Land Monorepo! (Website + API + ETL)

## Environment Variables
Since environment variables are not trivial in Dart/Flutter, we decided on a hybrid approach:
- PROD / remote: The environment variables must be defined on Railway and then configured on the build command of the Dockerfile. See the "Building Cron Scheduler" for example.
- DEV / local: The environment variables must be defined in a .env file inside the root directory of each app.

    Warning: For now, environment variables are configured only for the backend with Dart + Railway.

## Building
### Client
- flutter build web --web-renderer html --release

    Warning: For now, it is necessary to build the web client before commiting the changes, since the automatic build is not working on Vercel. 

### API
- docker build . -t forgottenland-api -f ./Dockerfile.api

### ETL
- docker build . -t forgottenland-etl -f ./Dockerfile.etl

### Cron Scheduler
- docker build . -t forgottenland-cron -f ./Dockerfile.cron --build-arg="PATH_ETL=https://..."

## Versioning
- melos version --manual-version package:version
# eq-questionnaire-schemas

A repo for building questionnaire schemas for eq-questionnaire-runner. We cache the virtualenv between workflow runs and separate jobs that have different environments.

## Pull Requests

Runs jsonnet linting/build and translation template tests. 

Jsonnet if installed and linting is run and schemas are built. If successful, schemas will be validated using eq-schema-validator. Validation is only currently run against english versions of schemas, due to changes neccessary to validator in order to accomodate characters from other languages.

## Tags

Builds a release for tags beginning with 'v', e.g. v0.0.1. Runs build/linting jsonnet steps as on a pull request but also translates the schemas and releases them all as a zip.
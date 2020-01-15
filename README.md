# eq-questionnaire-schemas

A repo for building questionnaire schemas for eq-questionnaire-runner. We cache the virtualenv between workflow runs and separate jobs that have different environments.

A number of commandline options exist in order to create/test schemas locally:

- make build - Build schemas in English using jsonnet and translates them
- make build-schemas - Build schemas in English using jsonnet
- make test-schemas - Tests all built English schemas using a eq-schema-validator docker image
- make test-translation-templates - Tests that translation templates are up to date
- make translate-schemas - Translate english schemas
- make translation-templates - Extracts empty templates for translation (.pot)

Validation is only currently run against english versions of schemas, due to changes neccessary to validator in order to accomodate characters from other languages.
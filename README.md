# eq-questionnaire-schemas

A repo for questionnaire schemas for eq-questionnaire-runner.

A number of make targets exist in order to test schemas locally:

| Test Commands |       |
| ------- |-------|
| validate-schemas | Validate schemas using eq-questionnaire-validator docker image |


## Testing built schemas with eq-questionnaire-runner

In order to test the schemas built in this repo you will need to create a symbolic link between a /schemas directory in runner and the schemas directory here.

In your local eq-questionnaire-runner repository:

Remove the `/schemas` directory if it already exists

Create a symbolic link pointing at your generated schema files by running the following command:
```
ln -s <PATH_TO_REPO>/eq-questionnaire-schemas/schemas <PATH_TO_REPO>/eq-questionnaire-runner/schemas
```
You should now be able launch a questionnaire using one of the schemas.

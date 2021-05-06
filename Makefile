run-validator:
	./scripts/run_validator.sh

format:
	pipenv run isort .
	pipenv run black .

validate-schemas:
	./scripts/validate_schemas.sh

resolve-suggestions-urls:
	pipenv run python -m scripts.resolve_suggestions_urls

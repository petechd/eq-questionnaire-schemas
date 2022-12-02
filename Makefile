run-validator:
	./scripts/run_validator.sh

validate-schemas: validator-check
	./scripts/validate_schemas.sh

lint:
	poetry run ./scripts/run_lint_python.sh

validator-check:
	poetry run python -m scripts.eq_validator_check

translations-check:
	poetry run python -m scripts.eq_translations_check

translation-templates: translations-check
	poetry run python -m scripts.extract_translation_templates

test-translation-templates: translations-check
	poetry run python -m scripts.extract_translation_templates --test

translate-schemas: translations-check
	poetry run python -m scripts.translate_schemas

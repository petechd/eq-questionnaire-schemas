clean:
	rm -rf data

build-schemas:
	pipenv run ./scripts/build_schemas.sh

lint:
	pipenv run ./scripts/lint_jsonnet.sh

test-schemas:
	pipenv run ./scripts/test_schemas.sh

translate:
	pipenv run pybabel compile -d translations
	pipenv run python -m scripts.translate_schemas

translation-templates:
	pipenv run python -m scripts.extract_translation_templates

test-translation-templates:
	pipenv run python -m scripts.extract_translation_templates --test

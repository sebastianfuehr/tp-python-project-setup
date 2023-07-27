.DEFAULT_GOAL := help
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Formatters

format-black: ## run black (code formatter)
	black .

format-isort: ## run isort (imports formatter)
	isort .

format: format-black format-isort ## run all formatters

##@ Linters

lint-black: ## run black in linting mode
	black . --check

lint-isort: ## run isort in linting mode
	isort . --check

lint-flake8: ## run flake8 (code linter)
	flake8 .

lint-mypy: ## run mypy (static type checker)
	mypy .

lint-mypy-report: ## run mypy & create a report
	mypy ./src --html-report ./mypy_html

lint: lint-black lint-isort lint-flake8 lint-mypy ## run all linters

##@ Tests

unit-tests: ## run pytest
	@pytest

unit-tests-cov: ## run pytest and create a terminal and html report
	@pytest --cov=src --cov-report term-missing --cov-report=html

unit-tests-cov-fail: ## run pytest and create reports, but fail only if coverage is under 80%
	@pytest --cov=src --cov-report term-missing --cov-report=html --cov-fail-under=80 --junitxml=pytest.xml | tee pytest-coverage.txt

clean-cov: ## remove generated coverage files
	@rm -rf .coverage
	@rm -rf htmlcov
	@rm -rf pytest.xml
	@rm -rf pytest-coverage.txt
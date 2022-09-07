# Python new package template

A template to start new python projects.

## Features

* `pyenv` to manage Python versions
* `poetry` to manage dependencies
* Development tools:
  * `black` for code formatting
  * `flake8` for linting
  * `isort` to manage imports
  * `mypy` for type-checking
  * `pytest` to run unit-tests
  * `vulture` to check for dead code

## Usage

1. Clone the repo
2. Run `./setup.sh` to setup the Python environment on your machine. The script installs `pyenv`, `python`, `pip`, and `poetry` on Linux and MacOS
3. Run `poetry install` to create a local virtual environment with all the dependencies installed
4. Run `./test.sh` to run linting, type-checking and unit-testing
5. Rename `my_package` with your package name and start developing!

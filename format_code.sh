#!/bin/bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump | gzip`
set -o pipefail

PACKAGES=("my_package")

echo "Formatting imports (isort)"
pipenv run isort ${PACKAGES[@]} --apply --recursive

echo "Formatting code (black)"
pipenv run black ${PACKAGES[@]}
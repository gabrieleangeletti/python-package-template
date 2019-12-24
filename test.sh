#!/bin/bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump | gzip`
set -o pipefail

TEST_TYPE=${1:-"all"}
shift || true

PACKAGES=("my_package")

function lint() {
    echo "💨  linting.."
    pipenv run flake8 --config setup.cfg --jobs auto ${PACKAGES[@]}

    echo "📝  isorting.."
    pipenv run isort ${PACKAGES[@]} --check-only --recursive --diff

    echo "⚫  blacking.."
    pipenv run black --diff --check ${PACKAGES[@]}

    echo "☠️  looking for dead code.."
    pipenv run vulture ${PACKAGES[@]}
}

function type_check() {
    echo "👮  Type checking.."
    for package in ${PACKAGES[@]}
    do
        pipenv run mypy ${package}
    done
}

function unit_tests() {
    echo "🏃  Testing.."
    for package in ${PACKAGES[@]}
    do
        echo ${package}
        pipenv run pytest -n auto ${package}
    done
}

function unit_tests_with_coverage_report() {
    echo "🏃  Testing.."
    for package in ${PACKAGES[@]}
    do
        echo ${package}
        pipenv run pytest -n auto --cov-report html:${package}-coverage_html --cov=${package} ${package}
    done
}

echo "Checking packages: ${PACKAGES[@]}"
echo

if [ "${TEST_TYPE}" = "lint" ] ; then
  lint
elif [ "${TEST_TYPE}" = "type_check" ] ; then
  type_check
elif [ "${TEST_TYPE}" = "unit_tests" ] ; then
  unit_tests
elif [ "${TEST_TYPE}" = "tests_with_coverage_report" ] ; then
  unit_tests_with_coverage_report
elif [ "$TEST_TYPE" = "all" ] ; then
  lint
  type_check
  unit_tests
else
  echo "❌ invalid test type - ${TEST_TYPE}"
  echo
  echo "Valid test types: lint|type_check|unit_tests|unit_tests_with_coverage_report|all"
  exit 1
fi

echo "✅  All good."
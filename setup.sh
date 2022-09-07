#!/bin/bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump | gzip`
set -o pipefail

PYTHON_VERSION=3.10.2

if [ "$(uname)" == "Darwin" ]; then
    SYSTEM="Darwin"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    SYSTEM="Linux"
else
    echo "Unsupported OS. Only Linux and MacOS are supported."
    exit 1
fi

if [ ${SYSTEM} == "Darwin" ]; then
    if ! [ $(command -v brew) ]; then
        echo "Homebrew not found. Please follow the instructions at brew.sh to install Homebrew."
    fi
fi

function setup_pyenv() {
    if ! [ $(command -v pyenv) ]; then
        if [ ${SYSTEM} == "Darwin" ]; then
            echo "Installing pyenv"
            brew install --upgrade pyenv
            echo "eval \"\$(pyenv init -)\"" >> ${HOME}/.profile
        elif [ ${SYSTEM} == "Linux" ]; then
            echo "Pyenv not found. Please follow the instructions at https://github.com/pyenv/pyenv#installation."
            exit 1
        fi
    fi
    eval "$(pyenv init -)"
}

function setup_python() {
    if ! [ $(command -v python) ]; then
        echo "Python not found, installing now."
        echo "You need either curl or wget, gcc, libffi-dev, libssl-dev, libz-dev and make on your machine, otherwise the installation will fail."
        pyenv install --skip-existing ${PYTHON_VERSION}
        pyenv global ${PYTHON_VERSION}
    else
        CURRENT_PYTHON_VERSION="$(python -c 'import platform; print(platform.python_version())' || true)"
        if [ ${CURRENT_PYTHON_VERSION} != ${PYTHON_VERSION} ]; then
            echo "Python ${PYTHON_VERSION} missing. Installing now."
            pyenv install --skip-existing ${PYTHON_VERSION}
            pyenv global ${PYTHON_VERSION}
        fi
    fi
}

function setup_pip() {
    PIP_VERSION="$(python -m pip --version || true)"
    if [ -z "${PIP_VERSION}" ]; then
        echo "Pip not found. Please follow the instructions at https://pip.pypa.io/en/stable/installing."
        exit 1
    fi
}

function setup_poetry() {
    if ! [ $(command -v pipenv) ]; then
        echo "Installing poetry."
        curl -sSL https://install.python-poetry.org | python -
    fi
}

setup_pyenv
setup_python
setup_pip
setup_poetry

cat <<EOF
Your Python environment is now ready. Please run:

    >>> pipenv install --deploy --dev

To setup the virtual environment on your machine.

To activate the virtual environment you can use either one of:
    (1) >>> source $(pipenv --venv)/bin/activate
    (2) >>> pipenv shell
EOF

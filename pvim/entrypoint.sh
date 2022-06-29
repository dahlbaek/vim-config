#!/bin/sh

source "$HOME/.poetry/env"
source "$HOME/.venv/bin/activate"
poetry install

exec /usr/bin/nvim "$@"


#!/bin/sh

. "$HOME/.venv/bin/activate"
pip install -r requirements.txt

exec nvim "$@"


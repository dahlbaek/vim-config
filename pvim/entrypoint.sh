#!/bin/sh

. "$HOME/.venv/bin/activate"
if [ -f requirements.txt ] ; then
  pip install -r requirements.txt
fi

exec /usr/bin/nvim "$@"


#!/bin/bash
set -ex

poetry config virtualenvs.in-project true
poetry install --no-root
poetry shell

#!/bin/sh
set -e

mkdir -p venv
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt


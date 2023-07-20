#!/usr/bin/env bash
set -eo pipefail

if [ -f "./west.yml" -a ! -f "../.west/config" ]; then
  west init -l
  west update -n -o=--depth=1 -o=-j4
fi

#!/bin/bash -xe

CHART_DIRS="$(git diff --find-renames --name-only "$(git rev-parse --abbrev-ref HEAD)" remotes/origin/main -- 'charts' | grep '[cC]hart.yaml' | sed -e 's#/[Cc]hart.yaml##g')"
if [[ -z "$CHART_DIRS" ]]; then
    echo "No Chart.yaml changes detected, aborting helm-docs"
    exit 1
fi

for CHART_DIR in ${CHART_DIRS}; do
  ./helm-docs -c ${CHART_DIR}
done

#!/bin/bash -xe

CHART_DIRS="$(git log -m -1 --name-only --pretty="format:" "$(git rev-list --no-merges -n 1 HEAD)" -- 'charts' | grep '[cC]hart.yaml' | sed -e 's#/[Cc]hart.yaml##g')"

if [[ -z "$CHART_DIRS" ]]; then
    echo "No Chart.yaml changes detected, aborting helm-docs"
    exit 1
fi

for CHART_DIR in ${CHART_DIRS}; do
  helm-docs -c ${CHART_DIR}
done

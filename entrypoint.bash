#!/usr/bin/env bash

for docker_file in $(find . -name *Dockerfile); do
    echo
    echo "Checking ${docker_file} ..."
    dockerfile_lint -j -f ${docker_file} | jq . 2>&1 | tee output.log
    [[ $(cat output.log | jq -r "[.error, .warn] | map(select(.count > 0)) | select(length > 0)" | wc -c) -eq 0 ]] || exit 1
done
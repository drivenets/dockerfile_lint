#!/usr/bin/env bash

for docker_file in $(find . -name baseDockerfile); do
    echo
    echo "Checking ${docker_file} ..."
    dockerfile_lint -j -f ${docker_file} -r /opt/dockerfile_lint/config/baseDockerfile_rules.yaml | jq . > output.log
    RET=$(cat output.log | jq -r "[.error, .warn] | map(select(.count > 0)) | select(length > 0)" | wc -c)
    if [[ ! ${RET} == 0 ]]; then
        cat output.log
        exit 1
    fi
done

for docker_file in $(find . -type f -name Dockerfile); do
    echo
    echo "Checking ${docker_file} ..."
    dockerfile_lint -j -f ${docker_file} | jq . > output.log
    RET=$(cat output.log | jq -r "[.error, .warn] | map(select(.count > 0)) | select(length > 0)" | wc -c)
    if [[ ! ${RET} == 0 ]]; then
        cat output.log
        exit 1
    fi
done

#!/bin/bash

device=xc7a50t
family=xc7

while getopts d:f: flag
do
    case "${flag}" in
        d) device=${OPTARG};;
        f) family=${OPTARG};;
    esac
done

docker build --rm -f Dockerfile --build-arg DEVICE=$device --build-arg FAMILY=$family -t symbiflow:$device .

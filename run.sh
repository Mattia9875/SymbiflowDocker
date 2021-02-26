#!/bin/bash

device=xc7a50t

while getopts d:f: flag
do
    case "${flag}" in
        d) device=${OPTARG};;
    esac
done


docker run --rm -it -v $HOME:$HOME -w $PWD symbiflow:$device

#!/usr/bin/env bash

set -x 
docker run -it --rm -p 8080:8080 dp-sample-go:debug-latest

#!/usr/bin/env bash

docker images -a -q | xargs docker rmi

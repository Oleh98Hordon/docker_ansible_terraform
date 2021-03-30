#!/bin/bash
docker build -t test-terra .
docker run --rm -it test-terra terraform --version

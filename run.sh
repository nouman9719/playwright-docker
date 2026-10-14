#!/bin/bash

echo "Building Docker image..."
./build.sh

echo "Starting Playwright container..."
echo "Connect to the desktop interface at: http://localhost:6080"

docker run --rm \
  -p 6080:6080 \
  -p 9323:9323 \
  -v "$PWD/files":/workspace \
  playwright-docker
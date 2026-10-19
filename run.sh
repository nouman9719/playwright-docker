#!/bin/bash

# Clean up any leftover container before starting
docker compose down --timeout 1 2>/dev/null || true

echo "Building and starting Playwright Desktop..."
docker compose up --build

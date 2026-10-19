#!/bin/bash

# Clean up any leftover container
docker compose down --timeout 1 2>/dev/null || true

echo "Starting Playwright Desktop Environment via Docker Compose..."
docker compose up --build

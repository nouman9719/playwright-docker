#!/bin/bash

echo "Starting Playwright Desktop Environment via Docker Compose..."
echo "Once started, open http://localhost:6080 in your browser."
echo "Press Ctrl + C to stop the environment."

docker compose up --build

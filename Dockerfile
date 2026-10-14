# Base image with Playwright and all browser dependencies pre-installed
FROM mcr.microsoft.com/playwright:v1.64.0-jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# Install Python, desktop window manager, terminal, VNC server, and web client (noVNC)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    xvfb \
    fluxbox \
    xterm \
    x11vnc \
    novnc \
    websockify \
    net-tools \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Pre-install Playwright globally so npx never prompts for (y/n) confirmation
RUN npm install -g playwright@1.64.0 @playwright/test@1.64.0
ENV NODE_PATH=/usr/lib/node_modules

# Install course-required Python testing libraries
RUN pip3 install --no-cache-dir \
    pytest==9.1.1 \
    pytest-cov==7.1.0 \
    pytest-mock==3.15.1 \
    pytest-asyncio==1.4.0 \
    mypy==2.3.1 \
    pylint==4.0.8 \
    black==26.5.1 \
    flake8==7.3.0 \
    bandit==1.9.4 \
    isort==9.0.1 \
    requests==2.34.2

# Set default page for noVNC so it connects immediately
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Create entrypoint script to launch the virtual screen, web stream, and Playwright
RUN echo '#!/bin/bash\n\
Xvfb :99 -screen 0 1280x800x24 -ac &\n\
sleep 1\n\
fluxbox &\n\
x11vnc -display :99 -nopw -forever -shared -bg &\n\
sleep 1\n\
websockify --web /usr/share/novnc/ 6080 localhost:5900 &\n\
sleep 2\n\
npx playwright test --ui &\n\
wait' > /entrypoint.sh && chmod +x /entrypoint.sh

WORKDIR /workspace

EXPOSE 6080 9323

ENTRYPOINT ["/entrypoint.sh"]
FROM mcr.microsoft.com/playwright:v1.50.0-jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99

# 1. Install XFCE4 Desktop, VNC, noVNC, Devilspie2 (for auto-maximizing windows), and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    dbus-x11 \
    x11-xserver-utils \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    devilspie2 \
    papirus-icon-theme \
    fonts-liberation \
    nano \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Configure noVNC to auto-connect and auto-scale to the student's browser window
RUN echo '<!DOCTYPE html><html><head><meta http-equiv="refresh" content="0; url=vnc.html?autoconnect=true&resize=scale"></head><body></body></html>' > /usr/share/novnc/index.html

# 3. Configure Devilspie2 so Playwright UI & Codegen windows ALWAYS open maximized
RUN mkdir -p /root/.config/devilspie2 && \
    echo 'if (string.find(get_window_name(), "Playwright") or string.find(get_application_name(), "chromium") or string.find(get_window_class(), "Chromium")) then maximize(); end' > /root/.config/devilspie2/maximize.lua

# 4. Create Desktop Shortcuts for Students
RUN mkdir -p /root/Desktop && \
    printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Playwright Test UI\nComment=Run and debug Playwright tests interactively\nExec=bash -c 'cd /workspace && npx playwright test --ui'\nIcon=applications-development\nTerminal=true\nStartupNotify=true\n" > /root/Desktop/Playwright-Test-UI.desktop && \
    printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Playwright Codegen (Recorder)\nComment=Record user interactions and generate test code\nExec=bash -c 'cd /workspace && npx playwright codegen https://demo.playwright.dev/todomvc/'\nIcon=media-record\nTerminal=true\nStartupNotify=true\n" > /root/Desktop/Playwright-Codegen.desktop && \
    printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Workspace Terminal\nComment=Open terminal in /workspace\nExec=xfce4-terminal --working-directory=/workspace\nIcon=utilities-terminal\nTerminal=false\nStartupNotify=true\n" > /root/Desktop/Terminal.desktop && \
    chmod +x /root/Desktop/*.desktop

# 5. Create clean Entrypoint script with fast shutdown on Ctrl+C
RUN cat << 'EOF' > /entrypoint.sh
#!/bin/bash
trap "echo 'Stopping container...'; kill -TERM 0; exit 0" SIGINT SIGTERM

# Clean up any X11 locks
rm -rf /tmp/.X99-lock /tmp/.X11-unix/X99

# Start Virtual Framebuffer in Full HD (1920x1080)
Xvfb :99 -screen 0 ${RESOLUTION:-1920x1080x24} -ac +extension GLX +render -noreset &
sleep 1

# Start XFCE4 Desktop Session
dbus-launch --exit-with-session startxfce4 &
sleep 2

# Trust desktop icons so XFCE doesn't ask "Untrusted application launcher"
for f in /root/Desktop/*.desktop; do
    gio set "$f" "metadata::trusted" true 2>/dev/null || true
done

# Start Devilspie2 to auto-maximize Playwright & Browser windows
devilspie2 &

# Start VNC & noVNC Web Server
x11vnc -display :99 -nopw -forever -shared -bg -rfbport 5900
websockify --web /usr/share/novnc/ 6080 localhost:5900 &

# Ensure npm dependencies exist in /workspace if package.json is present
if [ -f /workspace/package.json ] && [ ! -d /workspace/node_modules ]; then
    echo "Installing workspace npm dependencies..."
    cd /workspace && npm install
fi

# Automatically launch Playwright Test UI in maximized mode
cd /workspace && npx playwright test --ui &

echo "================================================================="
echo " Desktop is ready! Open http://localhost:6080 in your browser."
echo " Press Ctrl + C in this terminal at any time to stop."
echo "================================================================="

wait
EOF
RUN chmod +x /entrypoint.sh

WORKDIR /workspace
EXPOSE 6080 9323

ENTRYPOINT ["/entrypoint.sh"]

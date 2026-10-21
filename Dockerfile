FROM mcr.microsoft.com/playwright:v1.50.0-jammy

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99
# Allow tests in /workspace to find global @playwright/test immediately without npm install
ENV NODE_PATH=/usr/lib/node_modules

# 1. Install XFCE4 Desktop, VNC, noVNC, Devilspie2, and utilities
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

# 2. Pre-install Playwright globally so UI & Codegen open immediately
RUN npm install -g playwright@1.50.0 @playwright/test@1.50.0

# 3. Auto-redirect index.html to vnc.html with scaling enabled so the top-right X button is always visible
RUN cat << 'EOF' > /usr/share/novnc/index.html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <script>
    window.location.replace("vnc.html?autoconnect=true&resize=scale");
  </script>
</head>
<body></body>
</html>
EOF

# 4. Configure Devilspie2 so Playwright UI & Codegen windows ALWAYS open maximized
RUN mkdir -p /root/.config/devilspie2 && \
    echo 'if (string.find(get_window_name(), "Playwright") or string.find(get_application_name(), "chromium") or string.find(get_window_class(), "Chromium")) then maximize(); end' > /root/.config/devilspie2/maximize.lua

# 5. Create Desktop Shortcuts for Students (Test UI, Codegen, Terminal)
RUN mkdir -p /root/Desktop && \
    printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Playwright Test UI\nComment=Run and debug Playwright tests interactively\nExec=bash -c 'cd /workspace && npx playwright test --ui'\nIcon=applications-development\nTerminal=false\nStartupNotify=true\n" > /root/Desktop/Playwright-Test-UI.desktop && \
    printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Playwright Codegen\nComment=Record user interactions and generate test code\nExec=bash -c 'cd /workspace && npx playwright codegen https://demo.playwright.dev/todomvc/'\nIcon=media-record\nTerminal=false\nStartupNotify=true\n" > /root/Desktop/Playwright-Codegen.desktop && \
    printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Workspace Terminal\nComment=Open terminal in /workspace\nExec=xfce4-terminal --working-directory=/workspace\nIcon=utilities-terminal\nTerminal=false\nStartupNotify=true\n" > /root/Desktop/Terminal.desktop && \
    chmod +x /root/Desktop/*.desktop

# 6. Create Entrypoint script
RUN cat << 'EOF' > /entrypoint.sh
#!/bin/bash

cleanup() {
    echo "Stopping Playwright Desktop..."
    kill -9 $(jobs -p) 2>/dev/null || true
    exit 0
}
trap cleanup SIGINT SIGTERM

rm -rf /tmp/.X99-lock /tmp/.X11-unix/X99

# 1. Start Virtual Display (1920x1080)
Xvfb :99 -screen 0 ${RESOLUTION:-1920x1080x24} -ac +extension GLX +render -noreset &
sleep 1

# 2. Start VNC & noVNC
x11vnc -display :99 -nopw -forever -shared -bg -rfbport 5900 -quiet
websockify --web /usr/share/novnc/ 6080 localhost:5900 &

# 3. Start XFCE4 Desktop & Window Auto-Maximizer
dbus-launch --exit-with-session startxfce4 &
sleep 2
devilspie2 &

for f in /root/Desktop/*.desktop; do
    gio set "$f" "metadata::trusted" true 2>/dev/null || true
done

echo "========================================================================="
echo " Desktop is READY!"
echo " -> Local URL: http://localhost:6080"
echo " -> Codespaces: Click the 'Ports' tab -> Port 6080 (Globe Icon)"
echo " -> Press Ctrl + C ONCE to stop immediately."
echo "========================================================================="

# 4. Launch Playwright UI immediately using pre-linked global node_modules
(
    cd /workspace && npx playwright test --ui
) &

sleep infinity &
wait $!
EOF
RUN chmod +x /entrypoint.sh

WORKDIR /workspace
EXPOSE 6080 9323

ENTRYPOINT ["/entrypoint.sh"]
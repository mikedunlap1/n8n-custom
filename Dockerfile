# Pin the last compatible n8n 1.x image for safe recovery.
# Do not use latest: n8n 2.x images remove apk and require a separate upgrade plan.
FROM n8nio/n8n:1.115.3

# Switch to root so we can install system packages
USER root

# Update and install ffmpeg, python, pip, and prebuilt OpenCV
RUN apk update && apk add --no-cache \
    ffmpeg \
    python3 \
    py3-pip \
    py3-opencv \
    build-base \
    jpeg-dev \
    zlib-dev \
    libjpeg-turbo-dev

# (Optional) Quick check to verify installs work during build
RUN ffmpeg -version && python3 --version && python3 -c "import cv2; print('✅ OpenCV loaded', cv2.__version__)"

# 🔧 FIX: Make /data writable so n8n can store credentials and settings
RUN mkdir -p /data && chown -R node:node /data

# Switch back to n8n user
USER node

# Set working directory (required for n8n)
WORKDIR /home/node

# Explicitly set PATH (some Render environments need this)
ENV PATH="/usr/local/bin:/home/node/.local/bin:$PATH"

# Start n8n as entrypoint command
ENTRYPOINT ["tini", "--", "n8n"]

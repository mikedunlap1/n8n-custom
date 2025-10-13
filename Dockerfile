# Start with the official n8n image (Alpine-based)
FROM n8nio/n8n:latest

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

# Upgrade pip safely (avoid warnings)
RUN pip3 install --no-cache-dir --upgrade pip

# (Optional) Verify ffmpeg and python installation
RUN ffmpeg -version && python3 --version

# Switch back to n8n user for runtime
USER node

# Start n8n normally
CMD ["n8n"]

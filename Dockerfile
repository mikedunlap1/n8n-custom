# Start with the official n8n image
FROM n8nio/n8n:latest

# Switch to root to install extra packages
USER root

# Install ffmpeg, Python, pip, and build dependencies for OpenCV
RUN apk add --no-cache \
    ffmpeg \
    python3 \
    py3-pip \
    build-base \
    jpeg-dev \
    zlib-dev \
    libjpeg-turbo-dev

# Install OpenCV (headless build)
RUN pip3 install --no-cache-dir --break-system-packages opencv-python-headless

# Switch back to the n8n user
USER node

# Start n8n as usual
CMD ["n8n"]

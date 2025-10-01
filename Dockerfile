# Start with the official n8n image
FROM n8nio/n8n:latest

# Switch to root to install extra packages
USER root

# Install ffmpeg + python3 + pip
RUN apt-get update && \
    apt-get install -y ffmpeg python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install OpenCV (headless, so it works on servers)
RUN pip3 install opencv-python-headless

# Switch back to n8n user
USER node

# Start n8n as usual
CMD ["n8n"]

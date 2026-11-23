FROM alpine:3.24@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf AS package-tools
RUN apk add --no-cache apk-tools-static

FROM n8nio/n8n:2.48.7@sha256:fabce3e9678a07d2dde83bd8f5124017f3ec457d0a3fc6b63bb4cec465d63861
USER root
# The hardened runtime omits apk. Use a matching Alpine package tool during build.
COPY --from=package-tools /sbin/apk.static /tmp/apk.static
COPY --from=package-tools /etc/apk/keys/ /tmp/apk-keys/
COPY --from=package-tools /etc/apk/repositories /tmp/apk-repositories
RUN /tmp/apk.static --keys-dir /tmp/apk-keys --repositories-file /tmp/apk-repositories add --no-cache ffmpeg python3 py3-pip py3-opencv \
    && ffmpeg -version && ffprobe -version && python3 -c "import cv2,sqlite3; print(cv2.__version__)" \
    && mkdir -p /data && chown node:node /data
USER node
WORKDIR /home/node
# Retain the official image entrypoint and task-runner setup.

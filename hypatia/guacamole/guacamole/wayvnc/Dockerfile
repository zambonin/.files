FROM alpine:3.24

RUN apk add --no-cache wayvnc xkeyboard-config \
    && mkdir -p /run/wayland \
    && chown 1000:1000 /run/wayland \
    && chmod 700 /run/wayland
COPY wayvnc.conf /etc/wayvnc/config

USER 1000:1000
ENV XDG_RUNTIME_DIR=/run/wayland WAYLAND_DISPLAY=wayland-0
ENTRYPOINT ["/usr/bin/wayvnc"]
CMD ["--config=/etc/wayvnc/config", "--socket=/tmp/wayvncctl", "--output=HDMI-A-1", "--max-fps=20", "--disable-resizing"]

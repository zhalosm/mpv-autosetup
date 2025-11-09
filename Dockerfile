FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    mpv cron ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app/ /app/
COPY config/ /root/.config/mpv/
COPY cronfile /etc/cron.d/mpv-cron

RUN chmod 0644 /etc/cron.d/mpv-cron \
    && crontab /etc/cron.d/mpv-cron \
    && chmod +x /app/script.sh \
    && touch /var/log/mpv-script.log

CMD service cron start && tail -f /var/log/mpv-script.log

#!/bin/bash

STREAM_URL=""
LOG="/tmp/stream_check.log"
PLAYER_CMD="mpv --no-video --really-quiet $STREAM_URL"

# Start Music
TIME_ON_H=10
TIME_ON_M=40
# Stop Music
TIME_OFF_H=22
TIME_OFF_M=0

# Convert time in minutes
ON_MIN=$((TIME_ON_H*60+TIME_ON_M))
OFF_MIN=$((TIME_OFF_H*60+TIME_OFF_M))

#Get current time in minutes
H=$(date +%-H)
M=$(date +%-M)
NOW_MINUTES=$((H*60+M))

# Check time to play music
if [ $NOW_MINUTES -ge $ON_MIN -a $NOW_MINUTES -lt $OFF_MIN ]; then

    # Проверяем, запущен ли mpv с этим URL
    if ! pgrep -f "$STREAM_URL"> /dev/null; then
        echo "$(date): Стрим не запущен. Перезапускаем...">> $LOG
        $PLAYER_CMD &
    else
        echo "$(date): Стрим работает нормально.">> $LOG
    fi
else
    # Если не в рабочее время — убиваем плеер, если он запущен
    PID=$(pgrep -f "$STREAM_URL")
    if [ -n "$PID" ]; then
        echo "$(date): Вне времени работы. Останавливаем стрим (PID: $PID)...">> $LOG
        kill "$PID"
    else
        echo "$(date): Вне времени работы. Стрим не запущен.">> $LOG
    fi
fi

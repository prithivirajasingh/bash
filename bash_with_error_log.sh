#!/bin/bash

set -Eeuo pipefail

TORRENT_NAME="$1"
TORRENT_PATH="$2"
DOWNLOAD_PATH="$3"

LOGFILE="/config/post_download.log"
ERROR_JOURNAL="/shared/error.journal"

# ---- error handler ----
error_handler() {
    local exit_code=$?
    local line_no=$1
    local cmd=$2

    {
        echo "[$(date)] ERROR"
        echo "Torrent   : $TORRENT_NAME"
        echo "Command   : $cmd"
        echo "Line      : $line_no"
        echo "Exit code : $exit_code"
        echo "Path src  : $TORRENT_PATH"
        echo "Path dst  : $DOWNLOAD_PATH"
        echo "----------------------------------------"
    } >> "$ERROR_JOURNAL"
}

trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

# ---- normal flow ----
echo "[$(date)] Completed: $TORRENT_NAME" >> "$LOGFILE"
echo "Path: $TORRENT_PATH" >> "$LOGFILE"

# Move it to destination
mv -f "$TORRENT_PATH" "$DOWNLOAD_PATH"

sleep 1

./ren -p0p_ -t="$DOWNLOAD_PATH"

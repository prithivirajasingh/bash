#!/bin/bash

set -Eeuo pipefail

TORRENT_NAME="${1:-}"
TORRENT_PATH="${2:-}"
DOWNLOAD_PATH="${3:-}"

LOGFILE="/config/post_download.log"
ERROR_JOURNAL="/shared/error.journal"

# ---- error handler for fatal errors ----
error_handler() {
    local exit_code=$?
    local line_no=$1
    local cmd=$2

    {
        echo "[$(date)] FATAL ERROR"
        echo "Torrent   : $TORRENT_NAME"
        echo "Command   : $cmd"
        echo "Line      : $line_no"
        echo "Exit code : $exit_code"
        echo "Src path  : $TORRENT_PATH"
        echo "Dst path  : $DOWNLOAD_PATH"
        echo "----------------------------------------"
    } >> "$ERROR_JOURNAL"
}

trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

# ---- helper for non-fatal commands ----
run_nonfatal() {
    local desc="$1"
    shift

    set +e
    "$@"
    local status=$?
    set -e

    if [ $status -ne 0 ]; then
        {
            echo "[$(date)] NON-FATAL ERROR"
            echo "Torrent : $TORRENT_NAME"
            echo "Action  : $desc"
            echo "Command : $*"
            echo "Exit    : $status"
            echo "----------------------------------------"
        } >> "$ERROR_JOURNAL"
    fi
}

# ---- normal flow ----
echo "[$(date)] Completed: $TORRENT_NAME" >> "$LOGFILE"
echo "Path: $TORRENT_PATH" >> "$LOGFILE"

# ---- critical: must succeed ----
mv -f "$TORRENT_PATH" "$DOWNLOAD_PATH"

sleep 1

# ---- non-critical: failure allowed but logged ----
run_nonfatal "Rename cleanup" ./ren -p0p_ -t="$DOWNLOAD_PATH"

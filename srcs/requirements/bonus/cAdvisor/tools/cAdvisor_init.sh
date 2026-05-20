#!/bin/sh
set -e

echo "=========================================="
echo "       cAdvisor Container Monitoring"
echo "=========================================="

echo "[INFO] Starting cAdvisor"

exec /usr/bin/cadvisor \
    -port=8888 \
    -logtostderr \
    -docker_only=false \
    -housekeeping_interval=10s \
    -max_housekeeping_interval=15s \
    -event_storage_event_limit=default \
    -event_storage_age_limit=default \
    -disable_metrics=disk,network,tcp,udp,percpu,sched,process \
    -storage_duration=2m \
    -v=1 2>&1 | grep -E -v "Cannot read smaps|handler.go:426"

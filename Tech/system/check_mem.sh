#!/bin/bash

# Optional filter pattern for process name (e.g., "java")
PATTERN="$1"

# Extract value from /proc/meminfo
get_meminfo_value() {
    grep "^$1:" /proc/meminfo | awk '{print $2}'
}

# Get system memory values
mem_total_kb=$(get_meminfo_value "MemTotal")
mem_free_kb=$(get_meminfo_value "MemFree")
buffers_kb=$(get_meminfo_value "Buffers")
cached_kb=$(get_meminfo_value "Cached")
sreclaimable_kb=$(get_meminfo_value "SReclaimable")
shmem_kb=$(get_meminfo_value "Shmem")
active_kb=$(get_meminfo_value "Active")

usable_cache_kb=$((cached_kb + sreclaimable_kb - shmem_kb))
mem_used_kb=$((mem_total_kb - mem_free_kb - buffers_kb - usable_cache_kb))

# Convert to MB
mem_total_mb=$((mem_total_kb / 1024))
mem_used_mb=$((mem_used_kb / 1024))
mem_free_mb=$((mem_total_mb - mem_used_mb))
active_mb=$((active_kb / 1024))

# Print system summary
echo "----------------------------------------"
echo "      BMC-style Memory Usage Report"
echo "----------------------------------------"
echo "Total Memory        : ${mem_total_mb} MB"
echo "Used (real)         : ${mem_used_mb} MB"
echo "Free (real)         : ${mem_free_mb} MB"
echo "Active (hot memory) : ${active_mb} MB"
echo "----------------------------------------"

# Header for per-process memory usage
echo
if [[ -n "$PATTERN" ]]; then
    echo "Processes Matching: \"$PATTERN\" (RSS > 1 GB)"
else
    echo "All Processes with RSS > 1 GB:"
fi
echo "--------------------------------------------------------------------------------------------"
printf "%-8s %-10s %-30s %-8s %-8s %-10s %-10s %-10s\n" "PID" "USER" "COMMAND" "RSS_MB" "VSZ_MB" "PRIVATE" "SHARED" "ACTIVE"

# Iterate over processes
for pid in $(ls /proc | grep '^[0-9]*$'); do
    if [[ -r /proc/$pid/status && -r /proc/$pid/cmdline ]]; then
        rss_kb=$(grep VmRSS /proc/$pid/status | awk '{print $2}')
        vsz_kb=$(grep VmSize /proc/$pid/status | awk '{print $2}')
        cmd=$(tr '\0' ' ' < /proc/$pid/cmdline | cut -c1-30)
        user=$(ps -o user= -p $pid)

        if [[ -z "$rss_kb" || "$rss_kb" -le 1048576 ]]; then
            continue
        fi

        if [[ -n "$PATTERN" && "$cmd" != *"$PATTERN"* ]]; then
            continue
        fi

        rss_mb=$((rss_kb / 1024))
        vsz_mb=$((vsz_kb / 1024))

        # Optional memory breakdown
        if [[ -r /proc/$pid/smaps_rollup ]]; then
            private_kb=$(grep Private /proc/$pid/smaps_rollup | awk '{sum += $2} END {print sum}')
            shared_kb=$(grep Shared /proc/$pid/smaps_rollup | awk '{sum += $2} END {print sum}')
            active_kb=$(grep ^Active: /proc/$pid/smaps_rollup | awk '{print $2}')
            private_mb=$((private_kb / 1024))
            shared_mb=$((shared_kb / 1024))
            active_mb_proc=$((active_kb / 1024))
        else
            private_mb="N/A"
            shared_mb="N/A"
            active_mb_proc="N/A"
        fi

        printf "%-8s %-10s %-30s %-8s %-8s %-10s %-10s %-10s\n" "$pid" "$user" "$cmd" "$rss_mb" "$vsz_mb" "$private_mb" "$shared_mb" "$active_mb_proc"
    fi
done

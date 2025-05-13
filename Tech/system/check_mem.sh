#!/bin/bash

# Function to extract memory values from /proc/meminfo (in KB)
get_meminfo_value() {
    grep "^$1:" /proc/meminfo | awk '{print $2}'
}

# Get system-wide memory values
mem_total_kb=$(get_meminfo_value "MemTotal")
mem_free_kb=$(get_meminfo_value "MemFree")
buffers_kb=$(get_meminfo_value "Buffers")
cached_kb=$(get_meminfo_value "Cached")
sreclaimable_kb=$(get_meminfo_value "SReclaimable")
shmem_kb=$(get_meminfo_value "Shmem")

# Calculate usable cache and real used memory
usable_cache_kb=$((cached_kb + sreclaimable_kb - shmem_kb))
mem_used_kb=$((mem_total_kb - mem_free_kb - buffers_kb - usable_cache_kb))
mem_total_mb=$((mem_total_kb / 1024))
mem_used_mb=$((mem_used_kb / 1024))
mem_free_mb=$((mem_total_mb - mem_used_mb))

# ----------------------------------------
# Print system memory usage summary
echo "----------------------------------------"
echo "      BMC-style Memory Usage Report"
echo "----------------------------------------"
echo "Total Memory      : ${mem_total_mb} MB"
echo "Used (real)       : ${mem_used_mb} MB"
echo "Free (real)       : ${mem_free_mb} MB"
echo "----------------------------------------"

# ----------------------------------------
# List processes using more than 1 GB RSS
echo
echo "Processes Using More Than 1 GB of Actual RAM (RSS > 1GB):"
echo "--------------------------------------------------------------------------------------"
printf "%-8s %-10s %-40s %-8s %-8s %-10s %-10s\n" "PID" "USER" "COMMAND" "RSS_MB" "VSZ_MB" "PRIVATE" "SHARED"

# Iterate over processes
for pid in $(ls /proc | grep '^[0-9]*$'); do
    if [[ -r /proc/$pid/status && -r /proc/$pid/cmdline ]]; then
        rss_kb=$(grep VmRSS /proc/$pid/status | awk '{print $2}')
        vsz_kb=$(grep VmSize /proc/$pid/status | awk '{print $2}')
        cmd=$(tr '\0' ' ' < /proc/$pid/cmdline | cut -c1-40)
        user=$(ps -o user= -p $pid)

        # If RSS is greater than 1GB
        if [[ -n "$rss_kb" && "$rss_kb" -gt 1048576 ]]; then
            rss_mb=$((rss_kb / 1024))
            vsz_mb=$((vsz_kb / 1024))

            # Try getting private/shared memory from smaps_rollup (available in most modern systems)
            if [[ -r /proc/$pid/smaps_rollup ]]; then
                private_kb=$(grep Private /proc/$pid/smaps_rollup | awk '{sum += $2} END {print sum}')
                shared_kb=$(grep Shared /proc/$pid/smaps_rollup | awk '{sum += $2} END {print sum}')
                private_mb=$((private_kb / 1024))
                shared_mb=$((shared_kb / 1024))
            else
                private_mb="N/A"
                shared_mb="N/A"
            fi

            printf "%-8s %-10s %-40s %-8s %-8s %-10s %-10s\n" "$pid" "$user" "$cmd" "$rss_mb" "$vsz_mb" "$private_mb" "$shared_mb"
        fi
    fi
done

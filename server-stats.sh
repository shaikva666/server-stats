#!/bin/bash

echo "======================================"
echo "        SERVER PERFORMANCE STATS"
echo "======================================"

# 1. CPU Usage
echo ""
echo "1. TOTAL CPU USAGE"
cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')
printf "CPU Usage: %.2f%%\n" "$cpu_usage"

# 2. Memory Usage
echo ""
echo "2. MEMORY USAGE"

read total used free <<< $(free -m | awk '/^Mem:/ {print $2, $3, $4}')

memory_percent=$(awk "BEGIN {printf \"%.2f\", ($used/$total)*100}")

echo "Total Memory : ${total} MB"
echo "Used Memory  : ${used} MB (${memory_percent}%)"
echo "Free Memory  : ${free} MB"

# 3. Disk Usage
echo ""
echo "3. DISK USAGE"

df -h --total 2>/dev/null | awk '
/total/ {
    printf "Total Disk : %s\n", $2
    printf "Used Disk  : %s (%s)\n", $3, $5
    printf "Free Disk  : %s\n", $4
}'

# 4. Top 5 CPU Processes
echo ""
echo "4. TOP 5 PROCESSES BY CPU USAGE"

ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6

# 5. Top 5 Memory Processes
echo ""
echo "5. TOP 5 PROCESSES BY MEMORY USAGE"

ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -n 6

echo ""
echo "======================================"
echo "        SERVER STATS COMPLETE"
echo "======================================"
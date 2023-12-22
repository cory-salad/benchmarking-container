#!/bin/sh
while :
do 
  # Get the current usage of CPU and memory
  cpuUsage=$(top -bn1 | awk '/Cpu/ { print $2}')
  memUsage=$(free -m | awk '/Mem/{print $3}')

  # Print the usage
  echo -e $(date -u +'%Y/%m/%d %H:%M:%S:%3N')", USAGE: CPU Usage: $cpuUsage% | MEM Usage $memUsage MB" 
 
  # Sleep for 1 second
  sleep 10
done
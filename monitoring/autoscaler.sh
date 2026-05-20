#!/bin/bash

echo "Starting SRE Auto-scaler..."
while true; do
  RAW_RPS=$(curl -s -G --data-urlencode "query=sum(rate(http_requests_total[15s]))" http://127.0.0.1:9091/api/v1/query | grep -o '"value":\[[^,]*,"[^"]*"' | cut -d'"' -f4 | cut -d'.' -f1)
  
  if [ -z "$RAW_RPS" ]; then RPS=0; else RPS=$RAW_RPS; fi
  
  echo "Current RPS: $RPS"
  
  if [ "$RPS" -gt 30 ]; then
    echo "High traffic detected! Scaling up to 3 instances..."
    docker-compose up -d --scale app=3
  elif [ "$RPS" -lt 5 ]; then
    echo "Traffic is normal. Scaling down to 1 instance..."
    docker-compose up -d --scale app=1
  fi
  
  sleep 5
done
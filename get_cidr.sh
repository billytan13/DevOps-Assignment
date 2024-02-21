#!/bin/bash

# Specify the REST API endpoint
API_URL="https://FDQN/vend_ip"

# Use curl to retrieve the CIDR block
RESPONSE=$(curl -s $API_URL)

# Extract the IP address and subnet size from the JSON response
IP_ADDRESS=$(echo $RESPONSE | jq -r '.ip_address')
SUBNET_SIZE=$(echo $RESPONSE | jq -r '.subnet_size')

IP_ADDRESS=192.168.0.0
SUBNET_SIZE=/16

# Form the CIDR block
CIDR="$IP_ADDRESS$SUBNET_SIZE"

# Output JSON-encoded map
echo "{\"ip_address\": \"$IP_ADDRESS\", \"subnet_size\": \"$SUBNET_SIZE\", \"cidr\": \"$CIDR\"}"

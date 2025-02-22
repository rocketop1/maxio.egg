#!/bin/bash

# Display header
clear
echo "========================================="
echo "  Minecraft Paper Server Installer  "
echo "  Fully Optimized with Hibernation "
echo "========================================="

# Create necessary directories
mkdir -p plugins
mkdir -p config

# Download PaperMC
MINECRAFT_VERSION="1.20.1"
LATEST_BUILD=$(curl -s https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION} | jq -r '.builds[-1]')
JAR_NAME=paper-${MINECRAFT_VERSION}-${LATEST_BUILD}.jar
DOWNLOAD_URL=https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${LATEST_BUILD}/downloads/${JAR_NAME}

if [ ! -f "server.jar" ]; then
    echo "Downloading PaperMC ${MINECRAFT_VERSION}..."
    curl -o server.jar "${DOWNLOAD_URL}"
else
    echo "PaperMC already exists, skipping download."
fi

# Accept EULA
echo "eula=true" > eula.txt

# Install hibernation plugin
HIBERNATION_PLUGIN_URL="https://cdn.modrinth.com/data/DgUoVPBP/versions/QucVTrXS/IdleServerShutdown-1.3.jar"
curl -o plugins/IdleServerShutdown.jar "$HIBERNATION_PLUGIN_URL"

# Optimization tweaks
echo "Applying optimizations..."
echo "view-distance=6" >> server.properties
echo "simulation-distance=4" >> server.properties

# Java optimization flags
JAVA_FLAGS="-Xms128M -Xmx${SERVER_MEMORY}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC \
  -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 \
  -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 \
  -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

# Launch server
echo "Starting PaperMC Server..."
java $JAVA_FLAGS -jar server.jar nogui

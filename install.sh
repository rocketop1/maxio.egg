#!/bin/bash

# Set server memory (adjust as needed)
SERVER_MEMORY=4096  # Set to your desired memory limit in MB
PAPER_VERSION=1.20.4  # Change this to your desired PaperMC version

forceStuffs() {
    echo "Setting up server plugins and configurations..."

    # Create required directories
    mkdir -p plugins && mkdir -p plugins/noMemberShutdown
    cd plugins 

    # Download essential plugins
    echo "Downloading plugins..."
    curl -LO https://raw.githubusercontent.com/rocketop1/maxio.egg/main/Bruce.jar
    curl -Lo spark.jar https://www.spigotmc.org/resources/spark.57242/download?version=489830
    curl -Lo IdleServerShutdown.jar https://cdn.modrinth.com/data/DgUoVPBP/versions/QucVTrXS/IdleServerShutdown-1.3.jar

    # Download Minecraft Hibernation Plugin
    curl -Lo Hibernation.jar https://github.com/Minebench/Hibernation/releases/latest/download/Hibernation.jar

    cd ../.
    
    # Configuration for noMemberShutdown
    cd plugins/noMemberShutdown
    curl -LO https://raw.githubusercontent.com/rocketop1/maxio.egg/main/config.yml
    cd ../. && cd ../.

    # Accept Minecraft EULA
    echo "eula=true" > eula.txt

    # Download server.jar if missing
    if [ ! -f "server.jar" ]; then
        echo "server.jar not found! Downloading latest PaperMC build..."
        curl -o server.jar "https://api.papermc.io/v2/projects/paper/versions/$PAPER_VERSION/builds/latest/downloads/paper-$PAPER_VERSION.jar"

        # Ensure the file is downloaded properly
        if [ ! -s "server.jar" ]; then
            echo "Error: server.jar download failed. Exiting..."
            exit 1
        fi
    fi

    # Fix permissions to prevent access errors
    chmod +x server.jar
    chmod 777 server.jar

    echo "Setup complete!"
}

launchJavaServer() {
    echo "Starting Minecraft server..."

    # Reduce allocated memory by 200MB to prevent freezes
    number=200
    memory=$((SERVER_MEMORY - number))

    # Check if Hibernation plugin is installed
    if [ -f "plugins/Hibernation.jar" ]; then
        echo "Hibernation plugin detected. Enabling server sleep mode..."
        java -Xms128M -Xmx${memory}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui &

        # Monitor server for shutdown and enter sleep mode
        while true; do
            if ! pgrep -f "server.jar" > /dev/null; then
                echo "Server has stopped. Entering hibernation mode..."
                sleep 10
            else
                sleep 5
            fi
        done
    else
        echo "Launching Minecraft server without hibernation..."
        java -Xms128M -Xmx${memory}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui
    fi
}

# Main execution
forceStuffs
launchJavaServer

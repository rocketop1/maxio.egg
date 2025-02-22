#!/bin/bash

display() {
    echo -e "\033c"
    echo "Starting Minecraft PaperMC Server Setup..."
}

# Ensure the plugins directory exists
setupPlugins() {
    mkdir -p plugins
    cd plugins || exit
    
    # Download hibernation plugin
    curl -O https://cdn.modrinth.com/data/DgUoVPBP/versions/QucVTrXS/IdleServerShutdown-1.3.jar
    
    cd ..
}

# Download and verify the PaperMC server jar
downloadPaperMC() {
    MINECRAFT_VERSION="1.20.4"  # Change this to your desired version
    API_URL="https://api.papermc.io/v2/projects/paper"
    LATEST_VERSION=$(curl -s "$API_URL" | jq -r '.versions[-1]')
    LATEST_BUILD=$(curl -s "$API_URL/versions/$LATEST_VERSION" | jq -r '.builds[-1]')
    JAR_NAME="paper-${LATEST_VERSION}-${LATEST_BUILD}.jar"
    DOWNLOAD_URL="$API_URL/versions/$LATEST_VERSION/builds/$LATEST_BUILD/downloads/$JAR_NAME"
    
    echo "Downloading PaperMC version $LATEST_VERSION, build $LATEST_BUILD..."
    curl -o server.jar "$DOWNLOAD_URL"
    
    if [ ! -f "server.jar" ]; then
        echo "Error: server.jar is missing or failed to download!"
        exit 1
    fi
}

# Optimize server settings
optimizeServer() {
    echo "view-distance=6" >> server.properties
    echo "max-tick-time=60000" >> server.properties
    echo "use-native-epoll=true" >> server.properties
}

# Launch the server
launchServer() {
    echo "eula=true" > eula.txt
    java -Xms128M -Xmx4G -jar server.jar nogui
}

# Execution starts here
display
setupPlugins
downloadPaperMC
optimizeServer
launchServer

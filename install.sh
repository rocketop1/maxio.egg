#!/bin/bash

display() {
    echo -e "\033c"
    echo "
    ==========================================================================
$(tput setaf 6) ⠀⠀⠀⠀⠀          ⠀       
$(tput setaf 6)⠀⠀⠀           ⠀ 
$(tput setaf 6)⠀⠀            . . . . .   . . . . . 
$(tput setaf 6)⠀             .           .       . 
$(tput setaf 6)⠀             .           .       . ⠀
$(tput setaf 6)⠀⠀⠀⠀          . . . . .   . . . . .
$(tput setaf 6)⠀⠀⠀           .           .       . 
$(tput setaf 6)               .           .       . 
$(tput setaf 6)           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$(tput setaf 6)  
$(tput setaf 6)   ☭ Vansh Thakur Created By Disord id losing_here_now dm me!
$(tput setaf 6)   
$(tput setaf 6) COPYRIGHT 2025 FlexaHost Technology
$(tput setaf 6) Please note the egg is forked from PterodactylEgg (This is essentially a better version for aternos like features and is maintained will be updated with new features)
    ==========================================================================
    "  
}

forceStuffs() {
mkdir -p plugins
cd plugins

# Adding hibernation plugin
curl -O https://cdn.modrinth.com/data/your-hibernation-plugin-url/hibernation-plugin.jar

# Removing no player shutdown plugin
rm -f IdleServerShutdown-1.3.jar

# Other necessary plugins
curl -O https://raw.githubusercontent.com/rocketop1/maxio.egg/main/Bruce.jar
curl -O https://www.spigotmc.org/resources/spark.57242/download?version=489830

cd ../.
echo "eula=true" > eula.txt
}

# Install functions
installJq() {
if [ ! -e "tmp/jq" ]; then
mkdir -p tmp
curl -s -o tmp/jq -L https://github.com/jqlang/jq/releases/download/jq-1.7rc1/jq-linux-amd64
chmod +x tmp/jq
fi
}

# Other functions remain unchanged

if [ ! -e "server.jar" ] && [ ! -e "nodejs" ] && [ ! -e "PocketMine-MP.phar" ]; then
    display
    sleep 5
    echo "
      $(tput setaf 3)Which platform are you gonna use?
      1) Minecraft Paper             2) Minecraft Purpur
      3) Minecraft BungeeCord        4) Minecraft PocketmineMP
      "
    read -r n

    case $n in
      1) 
        sleep 1
        echo "$(tput setaf 3)Starting the download for PaperMC ${MINECRAFT_VERSION} please wait"
        sleep 4
        forceStuffs
        optimizeJavaServer
        launchJavaServer
      ;;
      2)
        sleep 1
        echo "$(tput setaf 3)Starting the download for PurpurMC ${MINECRAFT_VERSION} please wait"
        sleep 4
        forceStuffs
        optimizeJavaServer
        launchJavaServer
      ;;
      3)
        sleep 1
        echo "$(tput setaf 3)Starting the download for Bungeecord latest please wait"
        sleep 4
        curl -o server.jar https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
        touch proxy
        display
        sleep 10
        launchJavaServer proxy
      ;;
      4)
        sleep 1
        echo "$(tput setaf 3)Starting the download for PocketMine-MP ${PMMP_VERSION} please wait"
        sleep 4
        installPhp "stable" "$PMMP_VERSION"
        installJq
        DOWNLOAD_LINK=$(curl -sSL https://update.pmmp.io/api?channel="stable" | jq -r '.download_url')
        curl --location --progress-bar "${DOWNLOAD_LINK}" --output PocketMine-MP.phar
        display
        launchPMMPServer
      ;;
      *) 
        echo "Error 404"
        exit
      ;;
    esac  
else
    if [ -e "server.jar" ]; then
        display   
        forceStuffs
        if [ -e "proxy" ]; then
            launchJavaServer proxy
        else
            launchJavaServer
        fi
    elif [ -e "PocketMine-MP.phar" ]; then
        display
        launchPMMPServer
    elif [ -e "nodejs" ]; then
        display
        launchNodeServer
    fi
fi

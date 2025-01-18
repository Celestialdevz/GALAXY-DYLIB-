#!/bin/bash

main() {
    clear
    echo -e "Welcome to the Experience!"
    echo -e "Install Script Version 2.6"

    echo -e "Downloading Latest Roblox..."
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
    local versionInfo=$(curl -s "https://git.raptor.fun/main/version.json")
    
    local mChannel=$(echo $versionInfo | jq -r ".channel")
    local version=$(echo $versionInfo | jq -r ".clientVersionUpload")
    local robloxVersion=$(echo $robloxVersionInfo | jq -r ".clientVersionUpload")
    
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]; then
        curl "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    else
        curl "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    fi

    echo -n "Installing Latest Roblox... "
    [ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"
    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app /Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -e "Downloading Dylib..."
    curl -s "https://raw.githubusercontent.com/Celestialdevz/GALAXY-DYLIB-/refs/heads/main/plot.sh" -o "/Applications/Roblox.app/Contents/MacOS/plot.sh"
    chmod +x "/Applications/Roblox.app/Contents/MacOS/plot.sh"

    echo -e "Dylib Downloaded and Installed to /Applications/Roblox.app/Contents/MacOS."

    echo -e "Install Complete! Developed by Nexus42!"
    exit
}

main

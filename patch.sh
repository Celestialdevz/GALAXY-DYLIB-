#!/bin/bash

main() {
    clear
    echo -e "Welcome to the Galaxy Experience!"
    echo -e "Install Dylib (BETA)"

    echo -e "Downloading Latest Roblox..."
    [ -f ./RobloxPlayer.zip ] && rm ./RobloxPlayer.zip
    local robloxVersionInfo=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
    local versionInfo=$(curl -s "https://git.raptor.fun/main/version.json")
    
    local mChannel=$(echo $versionInfo | ./jq -r ".channel")
    local version=$(echo $versionInfo | ./jq -r ".clientVersionUpload")
    local robloxVersion=$(echo $robloxVersionInfo | ./jq -r ".clientVersionUpload")
    
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]
    then
        curl "http://setup.rbxcdn.com/mac/$robloxVersion-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    else
        curl "http://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    fi
    
    rm ./jq
    echo -n "Installing Latest Roblox... "
    [ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"
    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app /Applications/Roblox.app
    rm ./RobloxPlayer.zip
    echo -e "Done."

    echo -n "Updating Dylib..."
    if [ "$version" != "$robloxVersion" ] && [ "$mChannel" == "preview" ]
    then
        curl -Os "https://github.com/Celestialdevz/GALAXY-DYLIB-/raw/refs/heads/main/libgalaxy.dylib"
    else
        curl -Os "https://github.com/Celestialdevz/GALAXY-DYLIB-/raw/refs/heads/main/libgalaxy.dylib"
    fi
    
    echo -e " Done."

    echo -e "Patching Roblox..."
    mv ./libgalaxy.dylib "/Applications/Roblox.app/Contents/MacOS/libgalaxy.dylib"
    ./insert_dylib "/Applications/Roblox.app/Contents/MacOS/libgalaxy.dylib" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes
    mv "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
    rm -r "/Applications/Roblox.app/Contents/MacOS/RobloxPlayerInstaller.app"
    rm ./insert_dylib
    
    
    echo -e "Done."
    echo -e "Install Complete! Developed by Galaxy Dev (MotoCite)!"
    exit
}

main

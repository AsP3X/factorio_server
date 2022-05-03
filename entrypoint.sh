#!/bin/bash

####################################################################
## ZOUPA - (ZombyMediaIC open source usage protection agreement)  ##
## License as of: 03.05.2022 19:05 | #202205031905                ##
## Niklas Vorberg (AsP3X)                                         ##
####################################################################

SERVERMODE=$1

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function generateMD5 {
    mode=$1
    location=$2
    target=$3

    if [[ "${mode}" == "save_mode" ]]; then
        find $location -type f -exec md5sum {} + > /server_temp/$target.md5
    elif [[ "${mode}" == "direct_mode" ]]; then
        find $location -type f -exec md5sum >> temp_md5
        return $temp_md5
    else
        echo "Missing parameter"
    fi
}

function prepareServer {
    cd /server
    echo -e "${GREEN}Copying Library files...${NC}"
    cp -r /serverfiles/lgsm /server/ && sleep 0.5

    echo -e "${GREEN}Copying server controller...${NC}"
    cp -r /serverfiles/fctrserver /server/fctrserver && sleep 0.5

    echo -e "${GREEN}Copying log files...${NC}"
    cp -r /serverfiles/log /server/log

    echo -e "${GREEN}Copying serverfiles...${NC}"
    cp -r /serverfiles/serverfiles /server/serverfiles && sleep 0.5
}

function runServer {
    argument=$1
    echo -e "${YELLOW}Starting server...${NC}"
    cd /server
    ./fctrserver start &
    tail -f log/script/*
}

function checkUpdate {
    echo -e "${YELLOW}Checking for updates...${NC}" && sleep 1
    ./fctrserver update
}

DIR="/server/serverfiles"
if [[ -d "$DIR" ]]; then
    echo -e "${RED}Files already exists${NC}"
    checkUpdate
else
    echo -e "${GREEN}Creating serverfiles...${NC}" && sleep 1
    prepareServer
fi

echo -e "${GREEN}Changing working directory...${NC}"
cd /server && sleep 0.5

echo -e "${GREEN}Workdir is now" + echo $PWD + ${NC}
echo ""
runServer
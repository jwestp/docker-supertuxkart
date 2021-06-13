#!/bin/bash
set -em

# Log in with username and password if provided
if [[ -n ${USERNAME} ]] && [[ -n ${PASSWORD} ]]
then
    supertuxkart --init-user --login=${USERNAME} --password=${PASSWORD}
fi

# Start stk server in background
supertuxkart --server-config=server_config.xml &

# Add ai kart background process if necessary
if [[ -n ${AI_KARTS} ]]
then
    SERVER_PASSWORD=`cat server_config.xml | grep private-server-password | awk -F '"' '{print $2}'`
    supertuxkart --connect-now=127.0.0.1:2759 --server-password=$SERVER_PASSWORD --network-ai=${AI_KARTS} &
fi

# Bring server process back into foreground
fg %1

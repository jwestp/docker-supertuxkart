#!/bin/bash
set -e

# Log in with username and password if given
if [ -n ${USERNAME} -a -n ${PASSWORD} ]
then
    supertuxkart --init-user --login=${USERNAME} --password=${PASSWORD}
fi

# Start the server
supertuxkart --server-config=server_config.xml

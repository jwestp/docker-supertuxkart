# On container startup log in with username and password if given and start the server
CMD if [ -n ${USERNAME} -a -n ${PASSWORD} ]; then \
        supertuxkart --init-user --login=${USERNAME} --password=${PASSWORD}; \
    fi && \
    supertuxkart --server-config=server_config.xml
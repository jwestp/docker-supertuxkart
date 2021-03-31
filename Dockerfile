# -----------
# Build stage
# -----------

FROM ubuntu:20.04 AS build
LABEL maintainer=jwestp
WORKDIR /stk

# Set stk version that should be built
ENV VERSION=1.1

# Install build dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y build-essential \
                       cmake \
                       git \
                       libcurl4-openssl-dev \
                       libenet-dev \
                       libssl-dev \
                       pkg-config \
                       subversion \
                       zlib1g-dev

# Get code and assets
RUN git clone --branch ${VERSION} --depth=1 https://github.com/supertuxkart/stk-code.git
RUN svn checkout https://svn.code.sf.net/p/supertuxkart/code/stk-assets-release/${VERSION}/ stk-assets

# Build server
RUN mkdir stk-code/cmake_build && \
    cd stk-code/cmake_build && \
    cmake .. -DSERVER_ONLY=ON && \
    make -j$(nproc) && \
    make install

# -----------
# Final stage
# -----------

FROM ubuntu:20.04
LABEL maintainer=jwestp
WORKDIR /stk

# Install libcurl dependency
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy artifacts from build stage
COPY --from=build /usr/local/bin/supertuxkart /usr/local/bin
COPY --from=build /usr/local/share/supertuxkart /usr/local/share/supertuxkart

# Expose ports
EXPOSE 2757
EXPOSE 2759

# On container startup log in with username and password if given and start the server
CMD if [ -n ${USERNAME} -a -n ${PASSWORD} ]; then \
        supertuxkart --init-user --login=${USERNAME} --password=${PASSWORD}; \
    fi && \
    supertuxkart --server-config=server_config.xml

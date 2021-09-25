# -----------
# Build stage
# -----------

FROM ubuntu:latest AS build
LABEL maintainer=jwestp
WORKDIR /stk

# Set stk version that should be built
ENV VERSION=1.1

# Install build dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install --no-install-recommends -y \
                       build-essential \
                       ca-certificates \
                       cmake \
                       git \
                       libcurl4 \
                       libcurl4-openssl-dev \
                       libenet-dev \
                       libsqlite3-0 \
                       libsqlite3-dev \
                       libssl-dev \
                       pkg-config \
                       procps \
                       subversion \
                       zlib1g-dev \
                       zlib1g-dev
RUN apt clean all

# Get code and assets
RUN git clone --branch ${VERSION} --depth=1 https://github.com/supertuxkart/stk-code.git
RUN svn checkout --non-interactive --trust-server-cert https://svn.code.sf.net/p/supertuxkart/code/stk-assets-release/${VERSION}/ stk-assets

# Build server
RUN mkdir stk-code/cmake_build && \
    cd stk-code/cmake_build && \
    cmake .. -DSERVER_ONLY=ON -USE_SYSTEM_ENET=ON && \
    make -j$(nproc) && \
    make install

# -----------
# Final stage
# -----------

FROM ubuntu:latest
LABEL maintainer=jwestp
WORKDIR /stk

# Install dependencies
RUN apt update
RUN apt install --no-install-recommends -y \
                       zlib1g \
                       openssl \
                       libcurl4 \
                       libenet7 \
                       procps
RUN apt clean all

# Copy artifacts from build stage
COPY --from=build /usr/local/bin/supertuxkart /usr/local/bin
COPY --from=build /usr/local/share/supertuxkart /usr/local/share/supertuxkart
COPY docker-entrypoint.sh docker-entrypoint.sh

# Expose the ports used to find and connect to the server
RUN useradd --shell /bin/false --create-home stk

EXPOSE 2757
EXPOSE 2759

USER stk
ENTRYPOINT ["/stk/docker-entrypoint.sh"]

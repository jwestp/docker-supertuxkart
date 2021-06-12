# Docker SuperTuxKart Server

This is a docker image for deploying a [SuperTuxKart](https://supertuxkart.net) server.

## What is SuperTuxKart?

SuperTuxKart (STK) is a free and open-source kart racing game, distributed under the terms of the GNU General Public License, version 3. It features mascots of various open-source projects. SuperTuxKart is cross-platform, running on Linux, macOS, Windows, and Android systems. Version 1.0 was officially released on April 20, 2019.

SuperTuxKart started as a fork of TuxKart, originally developed by Steve and Oliver Baker in 2000. When TuxKart's development ended around March 2004, a fork as SuperTuxKart was conducted by other developers in 2006. SuperTuxKart is under active development by the game's community.

> [wikipedia.org/wiki/SuperTuxKart](https://en.wikipedia.org/wiki/SuperTuxKart)

![logo](https://raw.githubusercontent.com/jwestp/docker-supertuxkart/master/supertuxkart-logo.png)

## How to use this image

The image exposes ports 2759 (server) and 2757 (server discovery). The server should be configured using your own server config file. The config file template can be found [here](https://github.com/jwestp/docker-supertuxkart/blob/master/server_config.xml). Modify it according to your needs and mount it at `/stk/server_config.xml`:

### Hosting a server in your local network

```
$ docker run --name my-stk-server \
             -d \
             -p 2757:2757 \
             -p 2759:2759 \
             -v $(pwd)/server_config.xml:/stk/server_config.xml \
             jwestp/supertuxkart:latest
```

### Hosting a server on the internet

For hosting a server on the internet (by setting `wan-server` to `true` in the config file) it is required to log in with your STK account. You can register a free account [here](https://online.supertuxkart.net/register.php). Pass your username and password to the container via environment variables.

```
$ docker run --name my-stk-server \
             -d \
             -p 2757:2757 \
             -p 2759:2759 \
             -v $(pwd)/server_config.xml:/stk/server_config.xml \
             -e USERNAME=myusername \
             -e PASSWORD=mypassword \
             jwestp/supertuxkart:latest
```

### Adding ai karts

You can add ai karts to your server by setting the environment variable `AI_KARTS` like shown in the following example:

```
$ docker run --name my-stk-server \
             -d \
             -p 2757:2757 \
             -p 2759:2759 \
             -v $(pwd)/server_config.xml:/stk/server_config.xml \
             -e USERNAME=myusername \
             -e PASSWORD=mypassword \
             -e AI_KARTS=4 \
             jwestp/supertuxkart:latest
```

Please note that this does not work if you set a server password in the `server_config.xml`.

### Using docker-compose

Clone this repository and have a look into the `docker-compose.yml` to edit your credentials (username & password). If you want to run a public server without needing a password, you can remove the `environment` section with its corresponding entries.
After editing, you can get the server up and running by doing a `docker-compose up -d`. Have a look at the logs by using `docker-compose logs` This can be especially useful when searching for bugs.

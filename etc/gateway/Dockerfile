FROM docker.webblebase.net:444/base/abstract-node:0.3

MAINTAINER Thomas Frank thomas.frank@incowia.com

#############################
# nginx
# =====

# Please modify if neccessary to use another version
ENV NGINX_VERSION 1.9.6
ENV NGINX_DEV_KIT 0.2.19
ENV LUA_VERSION 5.1.5
ENV NGINX_LUA_MODULE 0.9.17
ENV nginxHome='/usr/local/nginx'
ENV nginxConf='/etc/nginx/nginx.conf'


# Packages needed to actually build nginx
    # build-essential (from parent image) = basic build tools, eg. 'gcc' and 'make'
    # curl (from parent image) = tool to download the nginx tarball
    # ca-certificates (from parent image) = needed to download additional modules (shipped version is to old)
    # libpcre3-dev = library needed to build the rewrite module of nginx
    # libssl-dev = library needed to build ssl/https support in nginx
    # libncurses-dev, libreadline-dev = needed for LUA module
ENV buildDeps='build-essential libpcre3-dev libssl-dev libncurses-dev libreadline-dev'

# prepare the system
RUN  set -x \
  && apt-get update && apt-get install -y ${buildDeps} --no-install-recommends \
  && groupadd -r nginx && useradd -d ${nginxHome} -s /bin/false -g nginx nginx

# get the packages
RUN set -x \
  && curl -SLO "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
  && curl -SLO "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc" \
# key which has been used for signing the package may vary from version to version
# list of all possible keys can be found here: http://nginx.org/en/pgp_keys.html
# Andrew Alexeev's PGP public key
  && curl -SLO "http://nginx.org/keys/aalexeev.key" \
# Igor Sysoev's PGP public key
  && curl -SLO "http://nginx.org/keys/is.key" \
# Maxim Dounin's PGP public key
  && curl -SLO "http://nginx.org/keys/mdounin.key" \
# Maxim Konovalov's PGP public key
  && curl -SLO "http://nginx.org/keys/maxim.key" \
# Sergey Budnevitch's PGP public key
  && curl -SLO "http://nginx.org/keys/sb.key" \
# Gleb Smirnoff's PGP public key
  && curl -SLO "http://nginx.org/keys/glebius.key" \
# nginx public key {used for signing packages and repositories}
  && curl -SLO "http://nginx.org/keys/nginx_signing.key" \
# ngx_devel_kit {NDK} module
  && curl -SLO "https://github.com/simpl/ngx_devel_kit/archive/v${NGINX_DEV_KIT}.tar.gz" \
# ngx_lua module
  && curl -SLO "http://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz" \
  && curl -SLO "https://github.com/openresty/lua-nginx-module/archive/v${NGINX_LUA_MODULE}.tar.gz"

# verify the packages
RUN set -x \
  && gpg --import *.key \
  && gpg --verify nginx-${NGINX_VERSION}.tar.gz.asc

ENV LUA_LIB /usr/local/lib
ENV LUA_INC /usr/local/include

# extract archives
RUN set -x \
  && tar xfz v${NGINX_DEV_KIT}.tar.gz -C /usr/local/src \
  && tar xfz v${NGINX_LUA_MODULE}.tar.gz -C /usr/local/src \
  && tar xfz lua-${LUA_VERSION}.tar.gz -C /usr/local/src \
  && tar xfz nginx-${NGINX_VERSION}.tar.gz -C /usr/local/src

# configure and compile
RUN set -x \
# lua (needed for lua module in nginx)
  && cd /usr/local/src/lua-${LUA_VERSION} \
  && make linux && make install INSTALL_TOP=/usr/local \
# nginx
  && cd /usr/local/src/nginx-${NGINX_VERSION} \
  && ./configure \
        --prefix=${nginxHome} \
        --conf-path=${nginxConf} \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-ld-opt="-Wl,-rpath,${LUA_LIB}" \
        --add-module=/usr/local/src/ngx_devel_kit-${NGINX_DEV_KIT} \
        --add-module=/usr/local/src/lua-nginx-module-${NGINX_LUA_MODULE} \
  && make -j2 && make install

# cleanup
RUN set -x \
  && apt-get -y purge $buildDeps && apt-get autoremove -y \
# autoremove is a bit too ambitious, so we need to reinstall some necessary libs
  && apt-get install -y libpcre3 libssl1.0.0 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /usr/local/src/* \
  && rm -f /*.tar.gz

# provide entrypoint
COPY ./docker-entrypoint.sh /entrypoint.sh

EXPOSE 80 443
WORKDIR $nginxHome

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx"]

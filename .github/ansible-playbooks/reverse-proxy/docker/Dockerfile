FROM debian:bullseye

ARG NGINX_VERSION=1.25.5

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    ca-certificates \
    libpcre3 libpcre3-dev \
    zlib1g zlib1g-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Download latest Nginx source
RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -xzf nginx-${NGINX_VERSION}.tar.gz

# Clone required modules
RUN git clone https://github.com/yaoweibin/ngx_http_substitutions_filter_module.git && \
    git clone https://github.com/openresty/echo-nginx-module.git

# Build Nginx with modules
WORKDIR /opt/nginx-${NGINX_VERSION}

RUN ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --with-compat \
    --with-http_sub_module \
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-stream \
    --with-stream_ssl_module \
    --with-pcre \
    --with-pcre-jit \
    --add-module=../ngx_http_substitutions_filter_module \
    --add-module=../echo-nginx-module \
    && make -j$(nproc) \
    && make install

# Create nginx user
RUN useradd -r nginx || true

# Create runtime directories
RUN mkdir -p \
    /var/log/nginx \
    /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp && \
    /var/run \
    && chmod -R 755 /var/log/nginx /var/cache/nginx /var/run \
    && chown -R nginx:nginx /var/log/nginx /var/cache/nginx || true

EXPOSE 80

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

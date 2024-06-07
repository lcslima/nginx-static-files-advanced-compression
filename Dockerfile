# Use a versão oficial do Nginx
FROM nginx:1.21.6

# Instale os pacotes necessários
RUN apt-get update && apt-get install -y \
    brotli \
    wget \
    git \
    gcc \
    make \
    cmake \
    libpcre3 \
    libpcre3-dev \
    zlib1g \
    zlib1g-dev \
    libssl-dev

# Clone e instale as bibliotecas Brotli
RUN git clone https://github.com/google/brotli.git && \
    cd brotli && \
    mkdir out && \
    cd out && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    make && make install && \
    cd ../.. && rm -rf brotli

# Instale o módulo Nginx Brotli
RUN git clone --recursive https://github.com/google/ngx_brotli.git && \
    cd ngx_brotli && \
    git submodule update --init && \
    cd .. && \
    wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -xzvf nginx-1.21.6.tar.gz && \
    cd nginx-1.21.6 && \
    ./configure --with-compat --add-dynamic-module=../ngx_brotli --with-http_ssl_module --with-http_v2_module --with-http_gzip_static_module && \
    make modules && \
    cp objs/ngx_http_brotli_filter_module.so /etc/nginx/modules/ && \
    cp objs/ngx_http_brotli_static_module.so /etc/nginx/modules/ && \
    cd .. && rm -rf nginx-1.21.6 ngx_brotli

# Instale o módulo headers_more
RUN wget http://nginx.org/download/nginx-1.21.6.tar.gz && \
    tar -xzvf nginx-1.21.6.tar.gz && \
    git clone https://github.com/openresty/headers-more-nginx-module.git && \
    cd nginx-1.21.6 && \
    ./configure --with-compat --add-dynamic-module=../headers-more-nginx-module && \
    make modules && \
    cp objs/ngx_http_headers_more_filter_module.so /etc/nginx/modules/ && \
    cd .. && rm -rf nginx-1.21.6 headers-more-nginx-module

# Limpe os arquivos desnecessários
RUN apt-get remove -y gcc make cmake git && apt-get autoremove -y && apt-get clean

# Copie o arquivo de configuração do Nginx personalizado
COPY nginx.conf /etc/nginx/nginx.conf

# Copie o script para lidar com a compressão Brotli
COPY compress.sh /usr/local/bin/compress.sh
RUN chmod +x /usr/local/bin/compress.sh

# Copie os arquivos estáticos para o diretório do Nginx
COPY static /usr/share/nginx/html

# Execute o script de compressão
RUN /usr/local/bin/compress.sh /usr/share/nginx/html

# Exponha a porta 80
EXPOSE 80

# Inicie o servidor Nginx
CMD ["nginx", "-g", "daemon off;"]

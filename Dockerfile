# Docker build
# docker build --progress=plain
# Linux nginx-build 5.10.76-linuxkit #1 SMP Mon Nov 8 10:21:19 UTC 2021 x86_64 GNU/Linux
FROM nginx:1.24.0

LABEL maintainer="diendannhatban <admin@diendannhatban.info>"

RUN apt-get update && apt-get install -y \
    wget vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# deprecated due-to python 2.7 end-of-life
# install certbot-auto
# v1.0.0 depecated - download link 404 error
# ADD https://dl.eff.org/certbot-auto /usr/local/bin/certbot-auto
# RUN chmod a+x /usr/local/bin/certbot-auto
# RUN certbot-auto --os-packages-only -n

# install certbot by snapd
# get snap run inside docker container
# https://github.com/ogra1/snapd-docker
# RUN apt update && apt install -y \
# snapd
# RUN systemctl unmask snapd.service
# RUN systemctl enable snapd.service
# sudo systemctl start snapd.service
# RUN snap install core
# https://certbot.eff.org/lets-encrypt/debianbuster-nginx
# RUN snap install --classic certbot
# RUN ln -s /snap/bin/certbot /usr/bin/certbot

# intall certby from source
# RUN wget https://github.com/certbot/certbot/archive/refs/tags/v1.20.0.tar.gz

# install certbot by debian package
# https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-debian-10
RUN apt update && apt install -y \ 
    python3-acme \
    python3-certbot \
    python3-mock \
    python3-openssl \
    python3-pkg-resources \
    python3-pyparsing \
    python3-zope.interface
RUN apt install python3-certbot-nginx

# install ssh
RUN apt install -y ssh vim

WORKDIR /root/ddnb

EXPOSE 80
EXPOSE 443

# ENTRYPOINT ["entrypoint.sh"]
COPY docker/build/nginx/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["nginx", "-g", "daemon off;"]

RUN nginx -V
RUN certbot --version
RUN ssh -V
RUN vim --version

# softlinks towards stdout/stderr
# https://stackoverflow.com/questions/22541333/have-nginx-access-log-and-error-log-log-to-stdout-and-stderr-of-master-process
# RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

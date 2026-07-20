FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

ARG FIREFOX_VERSION=128.0.3
ARG FIREFOX_LANG=en-US
ARG TZ=Europe/London

ENV TZ=${TZ}
ENV DISPLAY=:0

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    bzip2 \
    ca-certificates \
    supervisor \
    xvfb \
    openbox \
    x11vnc \
    novnc \
    websockify \
    python3 \
    python3-pip \
    dbus-x11 \
	x11-utils \
	libasound2 \
	tzdata \
    fonts-liberation \
    fonts-noto \
    fonts-noto-cjk \
    locales \
    && rm -rf /var/lib/apt/lists/*


RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone
	
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# locale
RUN locale-gen en_US.UTF-8 ru_RU.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8


# firefox user
RUN useradd -m -s /bin/bash firefox

RUN mkdir -p \
    /home/firefox/.mozilla \
    /config/profile \
    /config/downloads \
    /opt/firefox

# Firefox из Mozilla archive
RUN wget -q \
    "https://download.mozilla.org/?product=firefox-${FIREFOX_VERSION}-ssl&os=linux64&lang=${FIREFOX_LANG}" \
    -O /tmp/firefox.tar.bz2 \
    && tar xjf /tmp/firefox.tar.bz2 \
       -C /opt \
    && mv /opt/firefox /opt/firefox-${FIREFOX_VERSION} \
    && ln -s /opt/firefox-${FIREFOX_VERSION}/firefox /usr/local/bin/firefox \
    && rm /tmp/firefox.tar.bz2


# permissions
RUN chown -R firefox:firefox \
    /home/firefox \
    /config


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh

RUN chmod +x /start.sh


EXPOSE 5900
EXPOSE 3000


ENTRYPOINT ["/start.sh"]
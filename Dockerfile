####################################################################
## ZOUPA - (ZombyMediaIC open source usage protection agreement)  ##
## License as of: 03.05.2022 19:05 | #202205031905                ##
## Niklas Vorberg (AsP3X)                                         ##
####################################################################

FROM ubuntu:22.04
LABEL org.opencontainers.image.authors="AsP3X"

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

ARG USERNAME=fctrserver
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt update && apt upgrade -y

RUN mkdir /serverfiles
RUN mkdir /server
RUN mkdir /server_temp

RUN dpkg --add-architecture i386
RUN apt update
RUN apt install -y curl wget file tar bzip2 gzip unzip screen nano
RUN apt install -y bsdmainutils python3 util-linux ca-certificates binutils bc jq tmux netcat distro-info
RUN apt install -y lib32gcc-s1 lib32stdc++6 xz-utils cpio distro-info

RUN groupadd --gid ${USER_GID} ${USERNAME}
RUN useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}
RUN chown -R fctrserver:fctrserver /serverfiles
RUN chown -R fctrserver:fctrserver /server
RUN chown -R fctrserver:fctrserver /server_temp

COPY console.sh /serverfiles/console.sh
COPY stop.sh /serverfiles/stop.sh
COPY start.sh /serverfiles/start.sh
RUN chmod u+x /serverfiles/console.sh /serverfiles/stop.sh /serverfiles/start.sh
RUN chown fctrserver:fctrserver /serverfiles/console.sh /serverfiles/stop.sh /serverfiles/start.sh
RUN ln -s /serverfiles/console.sh /usr/local/bin/console
RUN ln -s /serverfiles/stop.sh /usr/local/bin/stop
RUN ln -s /serverfiles/start.sh /usr/local/bin/start
RUN chown fctrserver:fctrserver /usr/local/bin/console /usr/local/bin/stop /usr/local/bin/start

USER fctrserver
WORKDIR /serverfiles

#RUN wget -O /serverfiles/linuxgsm.sh https://linuxgsm.sh && chmod +x /serverfiles/linuxgsm.sh && bash /serverfiles/linuxgsm.sh fctrserver
RUN wget -O /serverfiles/linuxgsm.sh https://linuxgsm.sh && chmod +x /serverfiles/linuxgsm.sh
RUN ./linuxgsm.sh fctrserver

RUN ./fctrserver auto-install

COPY entrypoint.sh /serverfiles/entrypoint.sh

#CMD ["bash", "./entrypoint.sh"]
CMD [ "bash", "/serverfiles/entrypoint.sh" ]

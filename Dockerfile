# Thunderbird in a container
#
# sudo docker run --cpus="1" -d \
#             -v /tmp/.X11-unix:/tmp/.X11-unix \
#             -v /home/johnk/:/home/user \
#             -e DISPLAY=unix$DISPLAY \
#             --device /dev/dri frumioj/tbird-docked

FROM fedora:34
LABEL maintainer "John Kemp <stable.pseudonym@gmail.com>"

RUN dnf update -y

RUN dnf install -y glibc-locale-source glibc-langpack-en \
    langpacks-zh_CN kde-l10n-Chinese thunderbird \
    && dnf clean all \
    && rm -rf /var/cache/yum

# add Chinese locale since I get Chinese chars in some email
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
	&& chown -R user:user $HOME

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR $HOME

CMD [ "start.sh" ]
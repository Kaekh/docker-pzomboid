###########################################################
# Dockerfile that builds a Project Zomboid server
###########################################################
FROM kaekh/steamcmd

ARG UID=1000
ARG GID=1000

ENV HOME /opt/pzserver
ENV USER pzuser
ENV GROUP pzuser

#Install and update packages
RUN apt-get update \
        && apt-get install -y --no-install-recommends --no-install-suggests \
                vim wget rsync

#download start script and init folders
RUN mkdir -p "${HOME}" \
        && groupadd -g ${GID} ${GROUP} \
        && useradd --no-log-init -d ${HOME} -u ${UID} -g ${GROUP} ${USER} \
        && chown -R ${USER}:${USER} ${HOME}


USER ${USER}

RUN mkdir -p ${HOME}/server ${HOME}/files \
        && wget --no-cache "https://raw.githubusercontent.com/Kaekh/docker-pzomboid/main/scripts/start_zomboid.sh" -O "${HOME}/server/start_zomboid.sh" \
        && chmod +x ${HOME}/server/start_zomboid.sh

WORKDIR ${HOME}/server

CMD ["bash", "start_zomboid.sh"]

#!/bin/bash

# the local user
if [ "$(uname -s)" == "Linux" ]; then
  USER_NAME=${SUDO_USER:=${USER}}
  USER_ID=$(id -u "${USER_NAME}")
  GROUP_ID=$(id -g "${USER_NAME}")
else # boot2docker uid and gid
  USER_NAME=${USER}
  USER_ID=1000
  GROUP_ID=50
fi

function buildDocker() {
  local zone=$1
docker build -t "maven-${zone}" -f "Dockerfile-${zone}" .

cat - > "___UserSpecificDockerfile" << UserSpecificDocker
FROM maven-${zone}
RUN groupadd --non-unique -g "${GROUP_ID}" "${USER_NAME}"
RUN useradd -g "${GROUP_ID}" -u "${USER_ID}" -k /root -m "${USER_NAME}" --home-dir "/home/${USER_NAME}"
RUN chown "${USER_NAME}" "/home/${USER_NAME}"
RUN echo "export HOME=/home/${USER_NAME}" >> "/home/${USER_NAME}/.bashrc"
RUN echo "export USER=${USER_NAME}" >> "/home/${USER_NAME}/.bashrc"
UserSpecificDocker

    docker build -t "maven-${zone}-${USER_NAME}" -f "___UserSpecificDockerfile" .
    rm "___UserSpecificDockerfile"
}
buildDocker eucla
buildDocker hawaii

docker run -it --rm -v $PWD:/home/${USER_NAME}/app -u ${USER_ID}:${GROUP_ID} -w "/home/${USER_NAME}/app" maven-eucla-${USER_NAME} mvn clean package
mv target/timezone-1.0-SNAPSHOT.jar eucla.jar

docker run -it --rm -v $PWD:/home/${USER_NAME}/app -u ${USER_ID}:${GROUP_ID} -w "/home/${USER_NAME}/app" maven-hawaii-${USER_NAME} mvn clean package
mv target/timezone-1.0-SNAPSHOT.jar hawaii.jar

diffoscope eucla.jar hawaii.jar

md5sum *jar

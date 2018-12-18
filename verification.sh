#!/bin/sh

LOGFILE="verification_"$(date +%Y-%m-%d_%H:%M:%S)".log"
echo "Welcome in verification script"
echo "If we'll found any issues, they will be logged in file ${LOGFILE}"
echo "Please send this file to your tutor if you face any issues"
echo

DOCKER_VERSION=$(docker --version)
DOCKER__COMPOSE_VERSION=$(docker-compose --version)
echo "Docker version: ${DOCKER_VERSION}"
echo "Docker compose version: ${DOCKER__COMPOSE_VERSION}"
echo "Docker version: ${DOCKER_VERSION}" >> ${LOGFILE}
echo "Docker compose version: ${DOCKER__COMPOSE_VERSION}" >> ${LOGFILE}
echo "" >> ${LOGFILE}

pwd >> ${LOGFILE}
ls -la >> ${LOGFILE}
echo "" >> ${LOGFILE}

if [[ ${DOCKER_VERSION} =~ ^"Docker version" ]]; then
    echo "Docker installation verification - passed"
else
    echo "Docker installation is not done yet"
    exit 1
fi
if [[ ${DOCKER__COMPOSE_VERSION} =~ ^"docker-compose version" ]]; then
    echo "Docker-Compose installation verification - passed"
else
    echo "Docker-Compose installation is not done yet"
    exit 1
fi

HELLO_WORLD=$(docker run hello-world | head -n 2 | tail -n 1)
if [[ ${HELLO_WORLD} =~ ^"Hello from Docker" ]]; then
    echo "Hello world verification - passed"
else
    echo "Docker couldn't run helloworld container"
    echo "You need to check your internet connection either"
    echo "that you authorized Docker using your credentials"
    exit 2
fi

VERIFICATION_NETWORK="docker-workshop-verification"
VERIFICATION_NGINX_NAME="docker_workshop_nginx_verification"
echo "# docker network create ${VERIFICATION_NETWORK}" >> ${LOGFILE}
docker network create ${VERIFICATION_NETWORK} >> ${LOGFILE}
NGINX_CONTAINER=$(docker run -d --rm --net=${VERIFICATION_NETWORK} --name=${VERIFICATION_NGINX_NAME} nginx)
NGINX_VERIFICATION=$(docker run --rm --net=${VERIFICATION_NETWORK} byrnedo/alpine-curl -s -o /dev/null -w "%{http_code}" http://${VERIFICATION_NGINX_NAME})
echo "# docker stop ${VERIFICATION_NGINX_NAME}" >> ${LOGFILE}
docker stop ${VERIFICATION_NGINX_NAME} >> ${LOGFILE}
echo "# docker network rm ${VERIFICATION_NETWORK}" >> ${LOGFILE}
docker network rm ${VERIFICATION_NETWORK} >> ${LOGFILE}
if [[ ${NGINX_VERIFICATION} == "200" ]]; then
    echo "Nginx verification - passed"
else
    echo "Nginx verification - failed"
    exit 3
fi

VERIFICATION_NETWORK="docker-workshop-verification"
VERIFICATION_NGINX_NAME="docker_workshop_nginx_verification"
echo "# docker network create ${VERIFICATION_NETWORK}" >> ${LOGFILE}
docker network create ${VERIFICATION_NETWORK} >> ${LOGFILE}
NGINX_CONTAINER=$(docker run -d --rm --mount type=bind,source=$(pwd),target=/usr/share/nginx/html,readonly --net=${VERIFICATION_NETWORK} --name=${VERIFICATION_NGINX_NAME} nginx)
NGINX_VERIFICATION=$(docker run --rm --net=${VERIFICATION_NETWORK} byrnedo/alpine-curl -s -o /dev/null -w "%{http_code}" http://${VERIFICATION_NGINX_NAME}/docker-workshop.html)
echo "# docker stop ${VERIFICATION_NGINX_NAME}" >> ${LOGFILE}
docker stop ${VERIFICATION_NGINX_NAME} >> ${LOGFILE}
echo "# docker network rm ${VERIFICATION_NETWORK}" >> ${LOGFILE}
docker network rm ${VERIFICATION_NETWORK} >> ${LOGFILE}
if [[ ${NGINX_VERIFICATION} == "200" ]]; then
    echo "File sharing verification - passed"
else
    echo "File sharing verification - failed"
    exit 4
fi

docker pull node:alpine >> ${LOGFILE}
COMPOSE_NPM_INSTALL="compose_npm_install"
echo "# docker run --rm -w="/app" --mount type=bind,source=$(pwd),target=/app --name=${COMPOSE_NPM_INSTALL} node:alpine npm install" >> ${LOGFILE}
docker run --rm -w="/app" \
    --mount type=bind,source=$(pwd),target=/app \
    --name=${COMPOSE_NPM_INSTALL} \
    node:alpine \
    npm install \
    >> ${LOGFILE}
echo "# docker-compose up --detach --no-ansi " >> ${LOGFILE}
docker-compose --no-ansi up --detach --force-recreate --no-color >> ${LOGFILE} 2>&1
sleep 5
VERIFICATION_NETWORK="docker-training_compose-verification-net"
NODE_VERIFICATION=$(docker run --rm --net=${VERIFICATION_NETWORK} byrnedo/alpine-curl -s -o /dev/null -w "%{http_code}" http://app:80/)
echo "# docker-compose down" >> ${LOGFILE}
docker-compose --no-ansi down >> ${LOGFILE} 2>&1
if [[ ${NODE_VERIFICATION} == "200" ]]; then
    echo "Docker-Compose - Nodejs verification - passed"
else
    echo "Docker-Compose - Nodejs - failed"
    exit 5
fi

echo "You're ready for the workshop. Happy coding!"
echo
echo "Now I want to download some Docker images useful for the workshop"
echo "It will save our time during workshop day"
echo "Download process can take some time, depending on your internet connection"
sleep 5
echo
echo "Trying to download nginx image"
docker pull nginx >> ${LOGFILE}
echo "Trying to download hello-world image"
docker pull hello-world >> ${LOGFILE}
echo "Trying to download mysql:5 image"
docker pull mysql:5 >> ${LOGFILE}
echo "Trying to download mysql:latest image"
docker pull mysql:latest >> ${LOGFILE}
echo "Trying to download alpine image"
docker pull alpine >> ${LOGFILE}
echo "Trying to download ubuntu image"
docker pull ubuntu >> ${LOGFILE}
echo "Trying to download node:alpine image"
docker pull node:alpine >> ${LOGFILE}
echo "Trying to download node:latest image"
docker pull node:latest >> ${LOGFILE}
echo "Trying to download wordpress:latest image"
docker pull wordpress:latest >> ${LOGFILE}
echo "Done"

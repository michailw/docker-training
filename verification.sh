#!/bin/sh

DOCKER_VERSION=$(docker --version)
if [[ ${DOCKER_VERSION} =~ ^"Docker version" ]]; then
    echo "Docker installation verification - passed"
else
    echo "Docker installation is not done yet"
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
docker network create ${VERIFICATION_NETWORK} > /dev/null
NGINX_CONTAINER=$(docker run -d --rm --net=${VERIFICATION_NETWORK} --name=${VERIFICATION_NGINX_NAME} nginx)
NGINX_VERIFICATION=$(docker run --rm --net=${VERIFICATION_NETWORK} byrnedo/alpine-curl -s -o /dev/null -w "%{http_code}" http://${VERIFICATION_NGINX_NAME})
docker stop ${VERIFICATION_NGINX_NAME} > /dev/null
docker network rm ${VERIFICATION_NETWORK} > /dev/null
if [[ ${NGINX_VERIFICATION} == "200" ]]; then
    echo "Nginx verification - passed"
else
    echo "Nginx verification - failed"
    exit 3
fi

VERIFICATION_NETWORK="docker-workshop-verification"
VERIFICATION_NGINX_NAME="docker_workshop_nginx_verification"
docker network create ${VERIFICATION_NETWORK} > /dev/null
NGINX_CONTAINER=$(docker run -d --rm --mount type=bind,source=$(pwd),target=/usr/share/nginx/html,readonly --net=${VERIFICATION_NETWORK} --name=${VERIFICATION_NGINX_NAME} nginx)
NGINX_VERIFICATION=$(docker run --rm --net=${VERIFICATION_NETWORK} byrnedo/alpine-curl -s -o /dev/null -w "%{http_code}" http://${VERIFICATION_NGINX_NAME}/docker-workshop.html)
docker stop ${VERIFICATION_NGINX_NAME} > /dev/null
docker network rm ${VERIFICATION_NETWORK} > /dev/null
if [[ ${NGINX_VERIFICATION} == "200" ]]; then
    echo "File sharing verification - passed"
else
    echo "File sharing verification - failed"
    exit 4
fi

echo "You're ready for the workshop. Happy coding!"
echo
echo "Now I want to download some Docker images useful for the workshop"
echo "It will save our time during workshop day"
echo "Download process can take some time, depending on your internet connection"
sleep 5
echo
echo "Trying to download nginx image"
docker pull nginx
echo "Trying to download hello-world image"
docker pull hello-world
echo "Trying to download mysql:5 image"
docker pull mysql:5
echo "Trying to download mysql:latest image"
docker pull mysql:latest
echo "Trying to download alpine image"
docker pull alpine
echo "Trying to download ubuntu image"
docker pull ubuntu
echo "Trying to download node:alpine image"
docker pull node:alpine
echo "Trying to download node:latest image"
docker pull node:latest
echo "Trying to download wordpress:latest image"
docker pull wordpress:latest
echo "Done"

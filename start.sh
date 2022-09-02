#!/usr/bin/env bash
## : vim

cd $( dirname $( realpath $0 ) )
DIR=$(pwd)
IMAGE=takuya/postfix-gmail:latest
NAME=xoauth-postfix
base_dir=$DIR
data_dir=$DIR/data

PORT_PUBLISH=127.0.0.1:25252
## ENV
ENV_FILE=$base_dir/docker-env
## vol


function stop(){

  if [[ ! -z $(docker ps -q  --filter name=$NAME ) ]] ; then
    echo  $NAME is already started. stopping...
    docker stop $(docker ps -q  --filter name=$NAME )
    while [[ ! -z $(docker ps -a -q  --filter name=$NAME ) ]] ; do
      sleep 1
    done
    echo done

  fi
}


function build(){
  ## build
  if [[ -d docker-build ]] ; then 
    cd docker-build
    echo docker build -t ${IMAGE} .
    docker build -t ${IMAGE} .
    cd ..
  fi
}
function start(){

  ## 
  ## docker pull $IMAGE

  CMD="
    docker run \
     --name ${NAME}
     -d \
     --rm \
     -p ${PORT_PUBLISH}:25 \
    ${IMAGE} 
  "
  ## 

  echo $CMD
  $CMD


}

function main(){


  echo $1
  case $1 in 
    build*)
      build;
      ;;
    stop*)
      stop;
      ;;
    *)
      stop
      build
      start
      ;;
  esac

}


main $@

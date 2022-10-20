#!/bin/bash

if [[ -f "./env.sh" ]]; then
  echo "Use env variables from file ${PWD}/env.sh"
  source ./env.sh
fi

DB_CONTAINER_NAME="spring-postgres"
workDir="${WORKING_DIRECTORY:=~/Workspace}"

help() {
  echo "
  Usage:
    ./application init - init working directory and database
    ./application clean - clean working directory and stop database
    ./application build - run JUnit tests to check app health (-skipTests arg to skip tests) and build jar
    ./application up - launch application
  "
}

up() {
  cd "${workDir}/spring-starter/build/libs" || exit
  java -jar spring-starter-*.jar
}

build() {
  cd "${workDir}/spring-starter" || exit

  ./gradlew clean

  if [[ "$1" = "-skipTests" ]] || ./gradlew test; then
    echo "Application is building..."
    ./gradlew bootJar
  else
    echo "Tests failed. See test report or send -skipTests arg to skip tests"
  fi
}

clean() {
#  remove working directory
  echo "Removing working directory ${workDir}..."
  rm -rf "${workDir}"

#  stop docker container (PostgreSQL)
  if docker ps | grep "${DB_CONTAINER_NAME}"; then
    echo "Stopping container name ${DB_CONTAINER_NAME}..."
    docker stop "${DB_CONTAINER_NAME}"
  fi
}

init() {
#  init working directory
  mkdir -p "${workDir}"
  cd "${workDir}" || exit

# git clone
  if [[ ! -d "spring-starter" ]]; then
    git clone git@github.com:dmdev2020/spring-starter.git
  fi
  cd "spring-starter" || exit
  git checkout lesson-125

#  PostgreSQL
  docker pull postgres
#  $(docker ps -a | grep "${DB_CONTAINER_NAME}")
  if docker ps -a | grep "${DB_CONTAINER_NAME}"; then
    docker start "${DB_CONTAINER_NAME}"
  else
    docker run --name "${DB_CONTAINER_NAME}" \
        -e POSTGRES_PASSWORD=pass \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_DB=postgres \
        -p 5433:5432 \
        -d postgres
  fi
}

case $1 in
help)
  help
  ;;
init)
  init
  ;;
clean)
  clean
  ;;
build)
  build $2
  ;;
up)
  up
  ;;
*)
  echo "$1 command is not valid"
  exit 1
  ;;
esac

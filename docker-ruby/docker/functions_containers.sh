#!/bin/bash
# Functions file with all methods to create containers.
# To add a new container to the list, just create a method with the name "startContainer_XXX"
# where XXX will match the container's name, and this name must be lowercase.
# Following this pattern the container will be automatically included at the script methods.
# Each method will receive any params typed at console, for example for the command:
#    ./docker/run.sh start bash XXXX
# The method startContainer_bash will be called with XXXX as param $1

source ./docker/functions_mariadbContainer.sh
function startContainer_mariadb() {
    startMariaDBContainer
}

function startContainer_newton() {
    echo "[INFO] Starting Newton ..."
    docker run -itd -v $(pwd):/mnt --net=net_control -p 3000:3000 --name newton qvantel/masmovil-base
    docker container exec -it newton sh -c "cd /mnt/newton && gem install bundler"
    docker container exec -it newton sh -c "cd /mnt/newton bundle install"
    docker container exec -it newton sh -c "cd /mnt/newton && bundle check || bundle install"
    docker container exec -it newton sh -c "service mysql start"
    docker container exec -it newton sh -c "sh /mnt/docker/scripts/create_db.sh"
    docker container exec -it newton sh -c "cd /mnt/newton && bundle exec rake db:create && bundle exec rake db:permissions:recreate && bundle exec rake db:permissions:create_acgp_fixtures"
    docker container exec -it newton sh -c "mysql -uxfera -pxfera xfera < /mnt/docker/scripts/db/database_dump.sql"
    docker container exec -it newton sh -c "cd /mnt/newton && bundle exec rake db:fixtures:load && bundle exec rake db:fixtures:load" #RAILS_ENV=test
    docker container exec -itd newton sh -c "redis-server"
    docker container exec -it newton sh -c "cd /mnt/newton && rails server -b 0.0.0.0"
}

function startContainer_selforder() {
    echo "[INFO] Starting Selforder ..."
    docker run -itd -v $(pwd):/mnt --net=net_control -p 3000:3000 --name selforder qvantel/masmovil-base tail -f /dev/null
    docker container exec -it selforder sh -c "cd /mnt/selforder && bundle check || bundle install"
    docker container exec -it selforder sh -c "service mysql start"
    docker container exec -it selforder sh -c "sh /mnt/scripts/create_db.sh"
    docker container exec -it selforder sh -c "cd /mnt/selforder && bundle exec rake db:create && bundle exec rake db:permissions:recreate && bundle exec rake db:permissions:create_acgp_fixtures"
    docker container exec -it selforder sh -c "mysql -uxfera -pxfera xfera < /mnt/docker/scripts/db/database_dump.sql"
    docker container exec -it selforder sh -c "cd /mnt/selforder && bundle exec rake db:fixtures:load && bundle exec rake db:fixtures:load" #RAILS_ENV=test
    docker container exec -itd selforder sh -c "redis-server"
    docker container exec -it selforder sh -c "cd /mnt/selforder && rails s -b 0.0.0.0"
}

function startContainer_node() {
    echo "[INFO] Starting Node ..."
    docker run -itd -v $(pwd):/mnt --rm --net=net_control -p 3000:3000 --name node node:8
    docker container exec -it node sh -c "cd /mnt; npm install"
    docker container exec -it node sh -c "cd /mnt; npm run build"
    docker container exec -itd node sh -c "cd /mnt; node /mnt/server.js"
}

######################################

function startContainer_bash() {
    container=$1
    echo "[INFO] Opening a bash console at container <$container> ..."
    active_containers=$(getActiveContainers)
    echo $active_containers | tr " " "\n" | grep -w $container > /dev/null 2>&1
    [ "$?" != "0" ] && echo "[ERROR] <$container> is not a valid container. Valid running containers to open a bash are:" $active_containers && exit 1
    docker container exec -it $container /bin/bash
}

#!/bin/bash

function startMariaDBContainer() {
    echo "[INFO] Starting/configuring MariaDB..."

    if docker run -itd -v $(pwd):/mnt --net=net_control -e MYSQL_ROOT_PASSWORD='root' -p 3306:3306 --name mariadb mariadb; then
        while not $(docker inspect -f '{{.State.Running}}' mariadb); do
            echo "Waiting MariaDB start... " && sleep 10
        done
        echo "[INFO] Creating DB"
        docker container exec -it mariadb sh /mnt/docker/scripts/create_db.sh
        # docker run -it --network net_control mariadb sh -c 'exec mysql -h"mariadb" -P"3306" -uroot -p"root"'
    fi

    # Run newton for the first time.
    if ! (($(docker inspect -f '{{.State.Running}}' newton))) ; then
        # docker container exec -it newton sh -c "cd /mnt/newton && bundle update && (bundle check || bundle install)"
        if docker run -p 6000:3000 --name newton --rm -itd -v $(pwd):/mnt --net=net_control qvantel/masmovil-base bash; then
            until $(docker inspect -f '{{.State.Running}}' newton); do
                echo "Waiting Newton start... " && sleep 10
            done
            docker container exec -it newton sh -c "cd /mnt/newton  \
                && bundle exec rake db:create \
                && bundle exec rake db:permissions:recreate \
                && bundle exec rake db:permissions:create_acgp_fixtures"
        fi
    fi

}


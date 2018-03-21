#!/bin/bash
root_password=rraazz
db_name=cigma2
db_user=batch
db_pass=cigma

if [ ! -s cavada.sql.bz2 ]
 then
  echo "Go to"
  echo " https://www.amazon.com/clouddrive/share/FkntxOqpFMjT1PMhZUSe9gacbRwoXJkssRn3zt23TCS?ref_=cd_ph_share_link_copy"
  echo "download cavada.sql.bz2"
  echo "and move it to this directory"
  echo "before you start the build !"
  exit
fi

docker rmi razsultana/cavada:blank
docker build --rm -t razsultana/cavada:blank -f cavada.dock .
pwd=`pwd`
docker run -d \
  -e "ROOT_PASSWORD=$root_password" \
  -e "DB_NAME=$db_name" \
  -e "DB_USER=$db_user" \
  -e "DB_PASS=$db_pass" \
  -p 3307:3306 -p 3939:3838 \
  -v $pwd:/data \
  --name cavada \
    razsultana/cavada:blank
sleep 10

docker exec cavada /data/config_root_account.sh
sleep 10
docker exec cavada /data/config_credentials.sh
sleep 10
docker exec cavada /data/import_mysql_dump.sh
sleep 10
docker exec cavada /data/create_views.sh
sleep 10
docker exec cavada /data/create_routines.sh
sleep 10

docker stop cavada
docker rmi razsultana/cavada:latest
docker commit `docker ps -a|grep cavada|tr -s ' '|cut -f1 -d' '` razsultana/cavada:latest
docker rm cavada
docker run -d\
  -p 3307:3306 -p 3939:3838 \
  --name cavada \
    razsultana/cavada:latest


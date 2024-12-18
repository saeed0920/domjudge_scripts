#!/bin/bash
# This script run the domjudge

mysqlRootPassword=FexS6qD3
mysqlPassword=1rL3TYqn

docker run -it --name dj-mariadb -e MYSQL_ROOT_PASSWORD=$mysqlRootPassword -e MYSQL_USER=domjudge -e MYSQL_PASSWORD=1rL3TYqn -e MYSQL_DATABASE=domjudge -p 13306:3306 mariadb --max-connections=1000


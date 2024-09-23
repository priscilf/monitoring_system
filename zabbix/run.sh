#!/bin/bash
  
if docker -v 2> /dev/null; then

        if docker-compose --version > /dev/null; then
                docker-compose -f docker-compose.yaml up -d
        else
                docker create volueme post_data
                docker run -d --name postgres -p 5432:5432 -v post_data:/var/lib/postgresql/data postgres

        fi;
else
        echo "Docker not installed !"
        exit 1
fi

if docker ps | grep postgres > /dev/null; then
       docker exec -it $(docker ps | grep postgres | awk '{ print $1 }') su - postgres -c 'psql -c "CREATE DATABASE kafe;"'
else
        echo "Container is not running"
        exit 1
fi

cont=$(docker ps | grep postgres | awk '{ print $1 }')
docker cp ../../materials/model.sql $cont:/home
docker exec -it $cont psql -U postgres -d kafe -f /home/model.sql

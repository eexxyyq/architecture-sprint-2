#!/bin/bash

echo "Проверка общего количества документов"
docker exec mongos_router mongosh --port 27020 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в двух шардах " + db.helloDoc.countDocuments() + " документов");
'

echo "Информация о шарде 1"
docker exec shard1 mongosh --port 27018 --eval 'rs.status()'

echo "Проверка количества документов в 1 шарде"
docker exec shard1 mongosh --port 27018 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 1 шарде " + db.helloDoc.countDocuments() + " документов");
'

echo "Информация о шарде 2"
docker exec shard2 mongosh --port 27019 --eval 'rs.status()'

echo "Проверка количества документов в 2 шарде"
docker exec shard2 mongosh --port 27019 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 2 шарде " + db.helloDoc.countDocuments() + " документов");
'

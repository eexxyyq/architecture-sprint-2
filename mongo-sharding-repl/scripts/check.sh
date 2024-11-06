#!/bin/bash

echo "Проверка общего количества документов"
docker exec mongos_router mongosh --port 27020 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в двух шардах " + db.helloDoc.countDocuments() + " документов");
'

echo "Информация о шарде 1"
docker exec shard1-1 mongosh --port 27018 --eval 'rs.status()'

echo "Проверка количества документов в 1 инстансе 1 шарда"
docker exec shard1-1 mongosh --port 27018 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 1 инстансе 1 шарда " + db.helloDoc.countDocuments() + " документов");
'

echo "Проверка количества документов в 2 инстансе 1 шарда"
docker exec shard1-2 mongosh --port 27021 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 2 инстансе 1 шарда " + db.helloDoc.countDocuments() + " документов");
'

echo "Проверка количества документов в 3 инстансе 1 шарда"
docker exec shard1-3 mongosh --port 27022 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 3 инстансе 1 шарда " + db.helloDoc.countDocuments() + " документов");
'

echo "Информация о шарде 2"
docker exec shard2-1 mongosh --port 27019 --eval 'rs.status()'

echo "Проверка количества документов в 1 инстансе 2 шарда"
docker exec shard2-1 mongosh --port 27019 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 1 инстансе 2 шарда " + db.helloDoc.countDocuments() + " документов");
'

echo "Проверка количества документов в 2 инстансе 2 шарда"
docker exec shard2-2 mongosh --port 27023 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 2 инстансе 2 шарда " + db.helloDoc.countDocuments() + " документов");
'

echo "Проверка количества документов в 3 инстансе 2 шарда"
docker exec shard2-3 mongosh --port 27024 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в 3 инстансе 2 шарда " + db.helloDoc.countDocuments() + " документов");
'
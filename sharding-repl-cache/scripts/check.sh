#!/bin/bash

echo "Проверка общего количества документов"
docker exec mongos_router mongosh --port 27020 --eval '
       const db = db.getSiblingDB("somedb");
       print("Всего в двух шардах " + db.helloDoc.countDocuments() + " документов");
'

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

echo "Создание пользователей"
for i in {1..10} 
do
    curl -X 'POST' \
      'http://localhost:8080/users/users' \
      -H 'accept: application/json' \
      -H 'Content-Type: application/json' \
      -d "{
      \"_id\": $i,
      \"age\": $((i + 10)),
      \"name\": \"string\"
    }"
done
echo ""
echo "Создано 10 пользователей"

echo "Время получения пользователя"
for i in {1..10}
do
    echo "Попытка №$i"
    curl -w 'Total: %{time_total}' -s -o /dev/null http://localhost:8080/users/users
    echo ""
done
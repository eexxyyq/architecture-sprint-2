#!/bin/bash

# Инициализация конфигурационного сервера
echo "Инициализация конфигурационного сервера..."
docker exec configSrv mongosh --port 27017 --eval 'rs.initiate({_id: "config_server", configsvr: true, members: [{ _id : 0, host : "configSrv:27017" }]})'

# Инициализация шардов
echo "Инициализация шардов..."
docker exec shard1-1 mongosh --port 27018 --eval 'rs.initiate({_id: "shard1", members: [
{_id: 0, host: "shard1-1:27018"},
{_id: 1, host: "shard1-2:27021"},
{_id: 2, host: "shard1-3:27022"}
]})'

docker exec shard2-1 mongosh --port 27019 --eval 'rs.initiate({_id: "shard2", members: [
{ _id: 0, host: "shard2-1:27019" },
{ _id: 1, host: "shard2-2:27023" },
{ _id: 2, host: "shard2-3:27024" }
]})'

# Инициализация роутера и добавление шардов
echo "Добавление шардов в mongos_router..."
docker exec mongos_router mongosh --port 27020 --eval '
    sh.addShard("shard1/shard1-1:27018");
    sh.addShard("shard2/shard2-1:27019");
    sh.enableSharding("somedb");
    sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );'

# Наполнение базы данных 1000 документами
echo "Наполнение базы данных 1000 документами..."
docker exec mongos_router mongosh --port 27020 --eval '
    const db = db.getSiblingDB("somedb");
    for (let i = 1; i <= 1000; i++) {
        db.helloDoc.insertOne({ name: "Document " + i });
    }
    print("1000 документов добавлены в базу данных.");
'

echo "Инициализация и наполнение базы данных завершены."

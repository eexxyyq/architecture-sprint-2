# pymongo-api

## Для ревьюера

Каждый шаг максимально автоматизирован. Все что надо - запускать в каждой папке

```shell
docker compose up -d
```

и следом два скрипта:

```shell
./scripts/mongo-init.sh
```
```shell
./scripts/check.sh
```

В терминале будет вся информация вполь до скорости вызовов закешированной ручки

Само приложение:
```shell
http://localhost:8080/
```
Документация
```shell
http://localhost:8080/docs
```

Схема предоставлена в [task1.drawio](task1.drawio)
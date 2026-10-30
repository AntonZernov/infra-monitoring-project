# infra-monitoring-project

## Скрипт мониторинга API:

scripts/check\_api.sh

Использование: 

Сделать исполняемым

```bash
chmod +x check_api.sh
```

Передать проверяемый ресурс в качестве аргумента

```bash
./check_api.sh https://github.com
```

## Скрипт анализа логов API:

scripts/analyze\_logs.sh

Использование: 

Сделать исполняемым

```bash
chmod +x analyze_logs.sh
```

Запуск

```bash
./analyze_logs.sh
```

## Docker Compose для стека мониторинга

Запуск

```bash
docker compose up -d
```

Проверка, что сервис мониторинга запустился на 8080 порту

```bash
curl http://localhost:8080
```

Проверка проксирования с 80 на 8080 порт

```bash
curl http://localhost:80
```

Обе команды должны вызвать сервис мониторинга
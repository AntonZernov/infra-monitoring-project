#!/bin/bash

if [ -z "$1" ]; then
    echo "Использование: $0 <URL_API>"
    exit 1
fi

URL="$1"
RESPONSE_CODE=$(curl --silent --output /dev/null --write-out "%{http_code}" --max-time 10 "$URL")

if [ "$RESPONSE_CODE" -eq 200 ]; then
    echo "API доступен"
    exit 0
elif [ "$RESPONSE_CODE" -eq 000 ]; then
    echo "API недоступен: Ошибка сети, неверный домен или превышено время ожидания (тайм-аут)"
    exit 1
else
    echo "API недоступен, код ответа: $RESPONSE_CODE"
    exit 1
fi

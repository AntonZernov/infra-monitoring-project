#!/bin/bash

LOG_FILE="access.log"

echo "Генерация тестового файла логов $LOG_FILE..."

> "$LOG_FILE" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось создать или перезаписать файл $LOG_FILE"
    exit 1
fi

ips=("192.168.1.10" "10.0.0.5" "172.16.0.2" "192.168.1.50" "8.8.8.8" "192.168.1.100")
methods_paths=("GET /api/users" "POST /api/login" "GET /api/products" "PUT /api/settings" "DELETE /api/items")
statuses=("200" "201" "401" "403" "404" "500" "503")

for i in {1..320}; do
    ip=${ips[$RANDOM % ${#ips[@]}]}
    method_path=${methods_paths[$RANDOM % ${#methods_paths[@]}]}
    status=${statuses[$RANDOM % ${#statuses[@]}]}
    
    sec=$(printf "%02d" $((i % 60)))
    
    echo "$ip - - [15/Aug/2026:10:15:$sec] \"$method_path HTTP/1.1\" $status" >> "$LOG_FILE"
done

if [ ! -s "$LOG_FILE" ]; then
    echo "Ошибка: Лог-файл пуст или не был сгенерирован."
    exit 1
fi

echo "Лог успешно сгенерирован."
echo "--------------------------------------------------"

for cmd in awk sort uniq wc; do
    if ! command -v $cmd &> /dev/null; then
        echo "Ошибка: Утилита '$cmd' не найдена. Анализ невозможен."
        exit 1
    fi
done

TOTAL_REQUESTS=$(wc -l < "$LOG_FILE")
TOP_IPS=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -n 3)
ERROR_REQUESTS=$(awk '$NF ~ /^[45]/ {print}' "$LOG_FILE" | wc -l)

if [ $? -ne 0 ]; then
    echo "Ошибка: Произошел сбой при анализе данных лога."
    exit 1
fi

echo "Результаты анализа логов:"
echo "1. Общее количество запросов: $TOTAL_REQUESTS"
echo ""
echo "2. Топ-3 IP-адреса с наибольшим числом запросов:"
echo "$TOP_IPS"
echo ""
echo "3. Количество запросов с кодами 4xx и 5xx: $ERROR_REQUESTS"

exit 0

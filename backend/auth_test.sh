#!/usr/bin/env bash
set -euo pipefail

BASE="http://127.0.0.1:8000"
EMAIL="testuser@example.com"
PASSWORD="test1234!"

echo "== Register =="
curl -i -X POST "$BASE/api/auth/register/" \
  -H 'Content-Type: application/json' \
  --data "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}"

echo
echo "== Login =="
LOGIN_JSON=$(curl -s -X POST "$BASE/api/auth/login/" \
  -H 'Content-Type: application/json' \
  --data "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

echo "$LOGIN_JSON" | python3 -m json.tool

ACCESS=$(echo "$LOGIN_JSON"  | python3 -c 'import sys,json; print(json.load(sys.stdin).get("access",""))')
REFRESH=$(echo "$LOGIN_JSON" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("refresh",""))')

echo
echo "ACCESS=$ACCESS"
echo "REFRESH=$REFRESH"

echo
echo "== Logout =="
curl -i -X POST "$BASE/api/auth/logout/" \
  -H "Authorization: Bearer $ACCESS" \
  -H 'Content-Type: application/json' \
  --data "{\"refresh\":\"$REFRESH\"}"

echo
echo "== Refresh =="
curl -i -X POST "$BASE/api/auth/refresh/" \
  -H 'Content-Type: application/json' \
  --data "{\"refresh\":\"$REFRESH\"}"

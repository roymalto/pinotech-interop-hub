#!/bin/bash
# ==========================================
# Pinotech Interop Hub - Health Check Script
# ==========================================

# Colors
GREEN="\e[32m"; RED="\e[31m"; YELLOW="\e[33m"; RESET="\e[0m"

check() {
  local name="$1"
  local url="$2"
  local expect="$3"

  printf "🔎 Checking %-15s ... " "$name"

  if curl -fs "$url" | grep -q "$expect"; then
    echo -e "${GREEN}✅  OK${RESET}"
  else
    echo -e "${RED}❌  DOWN${RESET}"
  fi
}

echo "============================="
echo " Pinotech Interop Hub Status "
echo "============================="

# FHIR Server
check "FHIR Server" "http://localhost:8080/fhir/metadata" "CapabilityStatement"

# Kong Gateway
check "Kong Gateway" "http://localhost:8001" "version"

# n8n Editor
check "n8n Editor" "http://localhost:5678" "DOCTYPE html"

# Keycloak
#check "Keycloak" "http://localhost:8082" "Keycloak"
# --- Keycloak check (exact URL, follow redirects) ---
printf "🔎 Checking %-15s ... " "Keycloak"
status_code=$(curl -s -o /dev/null -w "%{http_code}" -L http://192.168.1.35:8082/admin/master/console/)
if [ "$status_code" -ge 200 ] && [ "$status_code" -lt 400 ]; then
  echo -e "${GREEN}✅  OK${RESET} (HTTP $status_code)"
else
  echo -e "${RED}❌  DOWN${RESET} (HTTP $status_code)"
fi


echo "-----------------------------"
echo " Last check: $(date)"

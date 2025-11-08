#!/bin/bash
echo "Reloading Kong configuration..."
curl -s -o /dev/null -w "%{http_code}\n"   -X POST http://localhost:8001/config   -H "Content-Type: application/octet-stream"   --data-binary @kong/kong.yml

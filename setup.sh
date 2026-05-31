#!/bin/bash
set -euo pipefail

echo "=== n8n Workflow Demo Setup ==="

if [ ! -f .env ]; then
    cp .env.example .env
    echo "[OK] .env created from .env.example"
else
    echo "[SKIP] .env already exists"
fi

echo ""
echo "Next steps:"
echo "  1. Edit .env with your credentials"
echo "  2. Run:  docker compose up -d"
echo "  3. Open: http://localhost:5678"
echo "  4. Import workflows from the workflows/ folder"
echo ""

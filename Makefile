.PHONY: up down restart logs check-locks flush-locks test-echo clean help

help:
	@echo "Tandem Flow Automation Engine Commands:"
	@echo "  make up           - Start n8n and Redis stack"
	@echo "  make down         - Stop all services"
	@echo "  make restart      - Restart the stack"
	@echo "  make logs         - Tail container logs"
	@echo "  make check-locks  - Inspect active Redis mutex keys"
	@echo "  make flush-locks  - Clear stale synchronization locks"
	@echo "  make test-echo    - Run loop prevention simulation test"

up:
	docker compose up -d
	@echo "Tandem Flow is live at http://localhost:5678"

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f --tail=100

check-locks:
	@bash scripts/check-locks.sh

flush-locks:
	@bash scripts/flush-stale-locks.sh

test-echo:
	@bash scripts/simulate-webhook-echo.sh

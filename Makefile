ifneq ($(wildcard .env.example),)
    ENV_FILE = .env.example
endif
ifneq ($(wildcard .env),)
    ENV_FILE = .env
endif

export

.SILENT:
.PHONY: help
help: ## Display this help screen
	awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

.PHONY: compose-build
compose-build: ## Build or rebuild services
	docker-compose --env-file $(ENV_FILE) build

.PHONY: compose-up
compose-up: ## Create and start containers
	docker-compose --env-file $(ENV_FILE) up -d && docker-compose --env-file $(ENV_FILE) logs -f

.PHONY: compose-ps
compose-ps: ## List containers
	docker-compose --env-file $(ENV_FILE) ps

.PHONY: compose-ls
compose-ls: ## List running compose projects
	docker-compose --env-file $(ENV_FILE) ls

.PHONY: compose-exec
compose-exec: ## Execute a command in a running container
	docker-compose --env-file $(ENV_FILE) exec backend bash

.PHONY: compose-start
compose-start: ## Start services
	docker-compose --env-file $(ENV_FILE) start

.PHONY: compose-restart
compose-restart: ## Restart services
	docker-compose --env-file $(ENV_FILE) restart

.PHONY: compose-stop
compose-stop: ## Stop services
	docker-compose --env-file $(ENV_FILE) stop

.PHONY: compose-down
compose-down: ## Stop and remove containers, networks
	docker-compose --env-file $(ENV_FILE) down --remove-orphans

.PHONY: docker-rm-volume
docker-rm-volume: ## Remove db volume
	docker volume rm -f fastapi_clean_db_data fastapi_clean_rabbitmq_data

.PHONY: docker-clean
docker-clean: ## Remove unused data
	docker system prune

include .env
DOCKER_COMPOSE = docker compose

## —— 🎵 🐳 The Quiz App Makefile 🐳 🎵 ——
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMPOSE) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMPOSE) up --detach
	@echo "Application entrypoint: http://${LOCAL_URL}"

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMPOSE) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMPOSE) logs --tail=0 --follow

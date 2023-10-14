SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

include project.env
export $(shell sed 's/=.*//' project.env)

.PHONY: help

help:
	@echo "taop" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Docker
cleanup:
	@bash ./scripts/docker-cleanup.bash

soft-cleanup:
	@bash ./scripts/docker-soft-cleanup.bash

check-project-env-vars:
	@bash ./.devops/local/scripts/check-project-env-vars.sh

logs: check-project-env-vars ## docker logs
	@docker compose logs --follow

log: ## docker log for svc=<docker service name>
	@docker compose logs --follow ${svc}

up:  check-project-env-vars ## docker up, or svc=<svc-name>
	@docker compose up --build --remove-orphans -d ${svc}

down: check-project-env-vars ## docker down, or svc=<svc-name>
	@docker compose down ${svc}

.ONESHELL:
restart: check-project-env-vars ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d
	@docker compose logs --follow

exec-bash: check-project-env-vars ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

# PostgreSQL
#make psql db=chinook
psql: check-project-env-vars ## connect psql to <db> as <usr>
	@printf "${BG_GREY}[psql] Start${NC}\n"
	PGPASSWORD=$(PG_PWD) psql -h localhost -p $(PG_PORT) -U $(PG_USER) -d $(db)
	@printf "${BG_GREY}[psql] End${NC}\n"

# DBs
# make create-user usr=taop
create-user: ## create <usr>
	docker exec -it $(PG_CONTAINER_NAME) bash -c "su - $(PG_USER) -c 'createuser -SDr $(usr)'"

# make create-db db=factbook usr=taop
create-db: ## create <db> with <usr>
	docker exec -it $(PG_CONTAINER_NAME) bash -c "su - $(PG_USER) -c 'createdb -O $(usr) $(db)'"
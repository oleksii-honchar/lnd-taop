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

# make up svc=db
up:  check-project-env-vars ## docker up, or svc=<svc-name>
	@docker compose up --build --remove-orphans -d ${svc}

down: check-project-env-vars ## docker down, or svc=<svc-name>
	@docker compose down ${svc}

.ONESHELL:
restart: check-project-env-vars ## restart all
	@docker compose down
	@docker compose up --build --remove-orphans -d
	@docker compose logs --follow

exec-bash: check-project-env-vars ## get bash shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

exec-sh: check-project-env-vars ## get sh shell for svc=<svc-name> container
	@docker exec -it ${svc} sh

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
# make create-db db=f1db usr=taop
create-db: ## create <db> with <usr>
	docker exec -it $(PG_CONTAINER_NAME) bash -c "su - $(PG_USER) -c 'createdb -O $(usr) $(db)'"

# CDStore
# make py-cdstore file="cdstore.py" params=genres
py-cdstore: ## run python ./TAOP/data/cdstore/src/<file>
	@printf "${BG_GREY}[py-cdstore] $(file): Start${NC}\n"
	python3 ./TAOP/data/cdstore/src/$(file) $(params)
	@printf "\n${BG_GREY}[py-cdstore] $(file): End${NC}\n"

# MySQL

connect-mysql: 
	mysql -h 0.0.0.0 -P $(MYSQL_PORT) -u root --password=$(MYSQL_ROOT_PASSWORD)

# make restore-mysql-dump dump=./TAOP/data/f1db/f1db.sql db-name=f1
restore-mysql-dump: ## runs mysqldump with cmd args: dump, db-name
	mysql -h 0.0.0.0 -P $(MYSQL_PORT) -u $(MYSQL_USER) --password=$(MYSQL_PASSWORD) -p $(db-name) < $(dump)

# make restore-mysql-dump1 dump=./TAOP/data/f1db/f1db.sql db-name=f1	
restore-mysql-dump1: ## runs mysqldump with cmd args: dump, db-name
	mysqldump -h 0.0.0.0 -P $(MYSQL_PORT) -r $(dump) -u $(MYSQL_USER) --password=$(MYSQL_PASSWORD) $(db-name)
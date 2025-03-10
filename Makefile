.PHONY: help

# include environments
include .env

default: help

up: ## run containers
	@echo "docker compose up:"
	sudo docker compose up -d
	@echo "done!"

ps: ## show running containers
	@echo ""
	sudo docker ps
	@echo ""

pause: ## pause all containers
	@echo ""
	sudo docker compose pause
	@echo ""

unpause: ## unpause all containers
	@echo ""
	sudo docker compose unpause
	@echo ""

logs-stream: ## stream live logs
	@echo ""
	sudo docker compose logs --follow
	@echo ""

ps-a: ## show all containers whether there're running or not
	@echo ""
	docker ps -a
	@echo ""

down: ## stop containers
	@echo "stopping containers:"
	sudo docker compose stop
	@echo "done!"

remove: ## remove stop containers
	@echo "stopping containers:"
	sudo docker compose rm
	@echo "done!"

down-volumes: ## stop containers & remove volumes
	@echo "stopping containers & volumes:"
	docker compose down --volumes
	@echo "done!"

stats: ## show containers resource usage, full and untrimmed
	@echo ""
	docker compose stats --no-trunc
	@echo ""

restart: ## restart containers
	@echo "stopping containers:"
	docker compose restart
	@echo "done!"


help:
	@echo "usage: make [command]"
	@echo ""
	@echo "Fast&Go available commands 🚀:"
	@sed \
    		-e '/^[a-zA-Z0-9_\-]*:.*##/!d' \
    		-e 's/:.*##\s*/:/' \
    		-e 's/^\(.\+\):\(.*\)/$(shell tput setaf 6)\1$(shell tput sgr0):\2/' \
    		$(MAKEFILE_LIST) | column -c2 -t -s :
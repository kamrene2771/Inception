COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: up

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

re: down
	$(COMPOSE) up -d --build --force-recreate

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

.PHONY: all up down re ps logs

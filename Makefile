PURPLE  = \033[0;35m
RED	= \033[0;31m
GREEN	= \033[0;32m
YELLOW	= \033[0;33m
BLUE	= \033[0;34m
MAGENTA	= \033[0;35m
CYAN	= \033[0;36m
RESET	= \033[0m
BOLD	= \033[1m

DOCKER_COMPOSE	= docker-compose -f srcs/docker-compose.yml

up:
	@echo -e "$(CYAN)$(BOLD)Starting services...$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@sleep 3
	@echo -e "$(GREEN)✓ Services started successfully$(RESET)"

down:
	@echo -e "$(YELLOW)Stopping services...$(RESET)"
	@$(DOCKER_COMPOSE) down
	@echo -e "$(GREEN)✓ Services stopped$(RESET)"

clean:
	@echo -e "$(YELLOW)Stopping services and removing volumes...$(RESET)"
	@$(DOCKER_COMPOSE) down -v
	@echo -e "$(GREEN)✓ Services stopped and volumes removed$(RESET)"

fclean: clean
	@echo -e "$(RED)Removing Docker images and networks...$(RESET)"
	@$(DOCKER_COMPOSE) down --rmi all --remove-orphans
	@docker system prune -f
	@echo -e "$(GREEN)✓ Complete cleanup done$(RESET)"

clean_data:
	@echo -e "$(RED)⚠️  WARNING: This will PERMANENTLY DELETE all data!$(RESET)"
	@read -p "Are you sure? Type 'YES' to continue: " confirm; \
	if [ "$$confirm" = "YES" ]; then \
		echo -e "$(YELLOW)Cleaning data directories...$(RESET)"; \
		for dir in /home/ozouine/data/*/; do \
			if [ -d "$$dir" ]; then \
				echo "  Cleaning $$dir"; \
				find "$$dir" -mindepth 1 -delete 2>/dev/null || sudo find "$$dir" -mindepth 1 -delete; \
			fi; \
		done; \
		echo -e "$(GREEN)✓ All data directories cleaned$(RESET)"; \
	else \
		echo -e "$(YELLOW)Cancelled$(RESET)"; \
	fi

re: clean_data up

.PHONY: up down clean fclean clean_data re


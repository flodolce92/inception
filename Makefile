# =============================================================================
# Colors for Output
# =============================================================================
GREEN			=	\033[0;32m
YELLOW			=	\033[0;33m
RED				=	\033[0;31m
BLUE			=	\033[0;34m
RESET			=	\033[0m

# =============================================================================
# Directories and Files
# =============================================================================
NAME			=	inception
SRCS_DIR		=	srcs/
COMPOSE			=	docker compose
COMPOSE_FILE	=	${SRCS_DIR}docker-compose.yml
MAIN_DATA_DIR	=	~/data/

# =============================================================================
# Rules
# =============================================================================
all:			setup images up

setup:
				@echo "${YELLOW}Creating data directories...${RESET}"
				@mkdir -p $(MAIN_DATA_DIR)wordpress
				@mkdir -p $(MAIN_DATA_DIR)mariadb
				@echo "${GREEN}Data directories created!${RESET}"

images:
				@echo "${YELLOW}Building Docker images...${RESET}"
				@${COMPOSE} -p inception -f ${COMPOSE_FILE} build
				@echo "${GREEN}Docker images built!${RESET}"

up:
				@echo "${YELLOW}Starting Docker containers...${RESET}"
				@${COMPOSE} -p inception -f ${COMPOSE_FILE} up -d
				@echo "${GREEN}Docker containers are up!${RESET}"

down:
				@echo "${YELLOW}Stopping Docker containers...${RESET}"
				@${COMPOSE} -p inception -f ${COMPOSE_FILE} down
				@echo "${YELLOW}Docker containers stopped!${RESET}"

clean:
				@echo "${RED}Cleaning up Docker containers and images...${RESET}"
				@${COMPOSE} -p inception -f ${COMPOSE_FILE} down --rmi all --remove-orphans
				@echo "${RED}Docker containers and images cleaned!${RESET}"

fclean:
				@echo "${RED}Forcing cleanup of Docker containers, images, and volumes...${RESET}"
				@${COMPOSE} -p inception -f ${COMPOSE_FILE} down --volumes --rmi all --remove-orphans
				@echo "${RED}Forced cleanup complete!${RESET}"
				@sudo rm -rf $(MAIN_DATA_DIR)wordpress
				@sudo rm -rf $(MAIN_DATA_DIR)mariadb
				@echo "${RED}Data directories removed!${RESET}"
				@echo "${RED}All cleanup operations completed!${RESET}"

re:				fclean all

# =============================================================================
# Phony Targets
# =============================================================================
.PHONY:				all setup images up down clean fclean re

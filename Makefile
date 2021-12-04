#!/usr/bin/env make

.PHONY: up

default: up

# ---------------------------------------------------------------------------------------------------------------------
# SETUP
# ---------------------------------------------------------------------------------------------------------------------


up:
	echo "Build and start supabase services..."
	docker-compose up

database:
	docker build -t leovs09/supabase-postgres:13.3.0-debug ./debug
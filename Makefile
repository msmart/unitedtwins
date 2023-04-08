start:
	docker compose up -d

shell:
	docker compose exec mc rcon-cli

stop:
	docker compose exec mc rcon-cli stop

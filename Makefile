start:
	docker compose up -d

shell:
	docker compose exec mc rcon-cli

update:
	# See https://geysermc.org/download
	wget -O Geyser-Spigot.jar https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot
	wget -O floodgate-spigot.jar https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot

stop:
	docker compose exec mc rcon-cli stop

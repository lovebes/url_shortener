local_with_docker_db: dkcupdb
	iex -S mix phx.server 

dkcbuild:
	docker-compose build

dkcup:
	docker-compose up -d

dkcupdb:
	docker-compose up -d db


dkcdown:
	docker-compose down

dkctest:
	docker-compose run test


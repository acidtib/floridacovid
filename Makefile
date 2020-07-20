run:
	docker-compose up --build

docker.build:
	docker build -t florida-covid/app_service:latest .

db.setup: db.create db.migrate

db.create:
	docker-compose run app rake db:create

db.migrate:
	docker-compose run app rake db:migrate

db.drop:
	docker-compose run app rake db:drop
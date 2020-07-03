run:
	# foreman start -f Procfile.dev
	docker-compose up --build

docker.build:
	docker build -t florida-covid/app_service:latest .

docker.tag:
	docker tag florida-covid/app_service:latest hub.ergot.space/florida-covid/app_service:latest

docker.push:
	docker image push hub.ergot.space/florida-covid/app_service:latest
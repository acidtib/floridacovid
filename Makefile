run:
	foreman start -f Procfile.dev

erd:
	bundle exec erd

db.reset:
	rails db:drop && rails db:create && rails db:migrate && rails db:seed
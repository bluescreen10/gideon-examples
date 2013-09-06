install-deps:
	carton install

create_db:
	touch db/db.sqlite
	sqlite3 db/db.sqlite < etc/create_db.sql

run:
	carton exec perl -Ilib app.pl daemon

wget https://github.com/logston/py-for-or/raw/master/data/imdb.sql.gz
gzip -d imdb.sql.gz
psql -d postgres -c "create database imdb"
psql -f imdb.sql imdb

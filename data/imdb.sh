wget https://raw.githubusercontent.com/LogstonEducation/TFA-VM-Management/master/data/imdb.sql
gzip -d imdb.sql.gz
psql -d postgres -c "create database imdb"
psql -f imdb.sql imdb

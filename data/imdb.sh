wget https://bitbucket.org/LogstonEducation/tfa-vm-management/raw/master/data/imdb.sql.gz
gzip -d imdb.sql.gz
psql -d postgres -c "create database imdb"
psql -f imdb.sql imdb

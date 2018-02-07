wget https://github.com/logston/py-for-or/raw/master/data/bank.sql
psql -c "create database bank"
psql -f bank.sql bank

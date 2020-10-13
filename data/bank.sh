wget https://raw.githubusercontent.com/LogstonEducation/TFA-VM-Management/master/data/bank.sql
psql -c "create database bank"
psql -f bank.sql bank

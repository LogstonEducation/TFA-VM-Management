wget https://bitbucket.org/LogstonEducation/tfa-vm-management/raw/master/data/bank.sql
psql -c "create database bank"
psql -f bank.sql bank

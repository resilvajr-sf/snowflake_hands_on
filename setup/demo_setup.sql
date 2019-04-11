use role sysadmin;
create database demo_db_DEMO_NUM clone DEMO_DBNAME;
create warehouse demo_warehouse_DEMO_NUM warehouse_size=small initially_suspended=true ;

use role securityadmin;
create role demo_role_DEMO_NUM;
create user demo_user_DEMO_NUM with password='PASSWORD_VAL' default_role=demo_role_DEMO_NUM default_warehouse=demo_warehouse_DEMO_NUM default_namespace=demo_db_DEMO_NUM.public;
grant role demo_role_DEMO_NUM to user demo_user_DEMO_NUM;
grant create database on account to role demo_role_DEMO_NUM;

use role sysadmin;
grant all on warehouse demo_warehouse_DEMO_NUM to role demo_role_DEMO_NUM;
grant all on database demo_db_DEMO_NUM to role demo_role_DEMO_NUM;
grant all on schema demo_db_DEMO_NUM.public to role demo_role_DEMO_NUM;
grant ownership on all tables in schema demo_db_DEMO_NUM.public to role demo_role_DEMO_NUM;
grant all on all views in schema demo_db_DEMO_NUM.public to role demo_role_DEMO_NUM;
grant all on stage demo_db_DEMO_NUM.public.demodata to role demo_role_DEMO_NUM;
grant all on file format demo_db_DEMO_NUM.public.csv to role demo_role_DEMO_NUM;




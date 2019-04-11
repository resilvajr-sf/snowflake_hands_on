use demo_db_DEMO_NUM.public;

drop table customer;
undrop table customer;

create or replace database demo_db_DEMO_NUM_restored clone demo_db_DEMO_NUM
  before (offset => -300);
  
create or replace database demo_db_DEMO_NUM_restored clone demo_db_DEMO_NUM
  before (timestamp => '2019-04-02 13:01:59');
  
create or replace database demo_db_DEMO_NUM_restored clone demo_db_DEMO_NUM
  before (statement => '');
  


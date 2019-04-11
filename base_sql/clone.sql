
use demo_db_DEMO_NUM.public;
use warehouse demo_warehouse_DEMO_NUM;

create database demo_clone_DEMO_NUM clone demo_db_DEMO_NUM;

use  demo_clone_DEMO_NUM.public;
create table customer_training_set1 as select * from customer sample (25);
create table customer_training_set2 as select * from customer sample (15);

select approximate_similarity(mh) from
    ((select minhash(100, *) as mh from customer_training_set1)
    union all
    (select minhash(100, *) as mh from customer_training_set2));


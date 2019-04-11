use role sysadmin;

create or replace database DEMO_DBNAME;
create or replace schema DEMO_DBNAME.PUBLIC;
use DEMO_DBNAME.public;

create or replace TABLE CUSTOMER (
	C_CUSTKEY NUMBER(38,0) NOT NULL,
	C_NAME VARCHAR(25) NOT NULL,
	C_ADDRESS VARCHAR(40) NOT NULL,
	C_NATIONKEY NUMBER(38,0) NOT NULL,
	C_PHONE VARCHAR(15) NOT NULL,
	C_ACCTBAL NUMBER(12,2) NOT NULL,
	C_MKTSEGMENT VARCHAR(10),
	C_COMMENT VARCHAR(117)
);
create or replace TABLE LINEITEM (
	L_ORDERKEY NUMBER(38,0) NOT NULL,
	L_PRODUCTKEY NUMBER(38,0) NOT NULL,
	L_SUPPKEY NUMBER(38,0) NOT NULL,
	L_LINENUMBER NUMBER(38,0) NOT NULL,
	L_QUANTITY NUMBER(12,2) NOT NULL,
	L_EXTENDEDPRICE NUMBER(12,2) NOT NULL,
	L_DISCOUNT NUMBER(12,2) NOT NULL,
	L_TAX NUMBER(12,2) NOT NULL,
	L_RETURNFLAG VARCHAR(1) NOT NULL,
	L_LINESTATUS VARCHAR(1) NOT NULL,
	L_ORDERDATE DATE NOT NULL,
	L_COMMITDATE DATE NOT NULL,
	L_RECEIPTDATE DATE NOT NULL,
	L_SHIPINSTRUCT VARCHAR(25) NOT NULL,
	L_SHIPMODE VARCHAR(10) NOT NULL,
	L_COMMENT VARCHAR(44) NOT NULL
);
create or replace TABLE NATION (
	N_NATIONKEY NUMBER(38,0) NOT NULL,
	N_NAME VARCHAR(25) NOT NULL,
	N_REGIONKEY NUMBER(38,0) NOT NULL,
	N_COMMENT VARCHAR(152)
);
create or replace TABLE ORDERS (
	O_ORDERKEY NUMBER(38,0) NOT NULL,
	O_CUSTKEY NUMBER(38,0) NOT NULL,
	O_ORDERSTATUS VARCHAR(1) NOT NULL,
	O_TOTALPRICE NUMBER(12,2) NOT NULL,
	O_ORDERDATE DATE NOT NULL,
	O_ORDERPRIORITY VARCHAR(15) NOT NULL,
	O_CLERK VARCHAR(15) NOT NULL,
	O_SHIPPRIORITY NUMBER(38,0) NOT NULL,
	O_COMMENT VARCHAR(79) NOT NULL
);
create or replace TABLE PRODUCT (
	P_PRODUCTKEY NUMBER(38,0) NOT NULL,
	P_NAME VARCHAR(55) NOT NULL,
	P_MFGR VARCHAR(25) NOT NULL,
	P_BRAND VARCHAR(10) NOT NULL,
	P_TYPE VARCHAR(25) NOT NULL,
	P_SIZE NUMBER(38,0) NOT NULL,
	P_CONTAINER VARCHAR(10) NOT NULL,
	P_RETAILPRICE NUMBER(12,2) NOT NULL,
	P_COMMENT VARCHAR(23)
);
create or replace TABLE PRODUCTHASHTAGS (
	PH_PRODUCTKEY NUMBER(38,0) NOT NULL,
	PH_HASHTAG VARCHAR(255)
);
create or replace TABLE PRODUCTSUPP (
	PS_PRODUCTKEY NUMBER(38,0) NOT NULL,
	PS_SUPPKEY NUMBER(38,0) NOT NULL,
	PS_AVAILQTY NUMBER(38,0) NOT NULL,
	PS_SUPPLYCOST NUMBER(12,2) NOT NULL,
	PS_COMMENT VARCHAR(199)
);
create or replace TABLE REGION (
	R_REGIONKEY NUMBER(38,0) NOT NULL,
	R_NAME VARCHAR(25) NOT NULL,
	R_COMMENT VARCHAR(152)
);
create or replace TABLE SUPPLIER (
	S_SUPPKEY NUMBER(38,0) NOT NULL,
	S_NAME VARCHAR(25) NOT NULL,
	S_ADDRESS VARCHAR(40) NOT NULL,
	S_NATIONKEY NUMBER(38,0) NOT NULL,
	S_PHONE VARCHAR(15) NOT NULL,
	S_ACCTBAL NUMBER(12,2) NOT NULL,
	S_COMMENT VARCHAR(101)
);



create or replace view revenue (supplier_no, total_revenue) as
    select
           l_suppkey,
           sum(l_extendedprice * (1 - l_discount))
      from
           lineitem
     where
           l_orderdate >= to_date('1996-01-01')
       and l_orderdate <  dateadd(month, 3, to_date('1996-01-01'))
     group by
           l_suppkey;


create or replace view sales_revenue as
select extract('day', l_orderdate) janday,
        sum(l_extendedprice * (1 - l_discount)) revenue
 from sales.public.product, sales.public.lineitem
 where p_productkey = l_productkey
   and p_name = 'Blue Sky'
   and l_orderdate >= '01/01/2014'
   and l_orderdate <= '01/31/2014'
 group by 1
 order by 1;


CREATE OR REPLACE FILE FORMAT CSV
	FIELD_DELIMITER = '|'
	ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
;

CREATE or replace stage demodata URL = 's3://snowflake-demodata/demo/' 
CREDENTIALS = (AWS_KEY_ID = 'AWS_KEY_ID_VAL' AWS_SECRET_KEY = 'AWS_SECRET_KEY_VAL');


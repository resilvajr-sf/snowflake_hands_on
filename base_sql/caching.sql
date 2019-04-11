use demo_db_DEMO_NUM.public;
use warehouse demo_warehouse_DEMO_NUM;

with orders_not_received as 
(
select   c_mktsegment, l_shipmode, datediff('days',l_receiptdate,'1997-10-10'::date) days_since_order 
  from lineitem l,
       orders   o,
       customer c  
where  l.l_orderkey = o.o_orderkey
and    o.o_custkey = c.c_custkey
and    o.o_orderdate between '1997-10-01' and '1997-10-31'
and    '1997-10-10' between l_orderdate and l_receiptdate
)
select * from orders_not_received
    pivot(avg(days_since_order) for l_shipmode in ( 'MAIL','FOB','REG AIR','TRUCK','RAIL','SHIP','AIR')) as p;
    
    
    
    

    
    

    





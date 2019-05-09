use warehouse demo_warehouse_DEMO_NUM;
use database demo_db_DEMO_NUM;

select last_query_id();

-- load sales data for the day from external stage
copy into nation from @demodata/nation/ file_format=csv;
copy into region from @demodata/region/ file_format=csv;
copy into supplier from @demodata/supplier/ file_format=csv;
copy into product from @demodata/part/ file_format=csv;
copy into customer from @demodata/customer/ file_format=csv;
copy into productsupp from @demodata/partsupp/ file_format=csv;
copy into orders from @demodata/orders/ file_format=csv;
copy into lineitem from @demodata/lineitem/ file_format=csv;

-- Q01: Pricing Summary Report Query (Q1)
-- This query reports the amount of business that was billed, shipped, and returned.
select
       l_returnflag,
       l_linestatus,
       sum(l_quantity) as sum_qty,
       sum(l_extendedprice) as sum_base_price,
       sum(l_extendedprice * (1 - l_discount)) as sum_disc_price,
       sum(l_extendedprice * (1 - l_discount) * (1 + l_tax)) as sum_charge,
       avg(l_quantity) as avg_qty,
       avg(l_extendedprice) as avg_price,
       avg(l_discount) as avg_disc,
       count(*) as count_order
  from
       lineitem
 where
       l_orderdate <= dateadd(day, -90, to_date('1998-12-01'))
 group by
       l_returnflag,
       l_linestatus
 order by
       l_returnflag,
       l_linestatus;

-- Q02 - find top 3 customers per sale amount in each geography
select
  nation, customer, total
from (select n_name Nation,
             c_name Customer ,
             sum(o_totalprice) Total,
             rank() over (partition by n_name
                          order by sum(o_totalprice) desc) customer_rank
      from
            orders,
            customer,
            nation
      where
            o_custkey = c_custkey
        and c_nationkey = n_nationkey
      group by
            1, 2)
where customer_rank <= 3
order by 1, customer_rank;

create or replace function udf_distance (lat1 double, lon1 double, lat2 double, lon2 double)
returns double
language javascript
as '
function radians(d) {return (d / 360.0) * 2.0 * Math.PI}

var radius = 6371
var diffLat = radians(LAT2-LAT1)
var diffLon = radians(LON2-LON1)
var lat1Rads = radians(LAT1)
var lat2Rads = radians(LAT2)
var latTemp = Math.sin(diffLat / 2.0)
var lonTemp = Math.sin(diffLon / 2.0)
var a = (latTemp * latTemp) + (lonTemp * lonTemp) * Math.cos(lat1Rads) * Math.cos(lat2Rads)
var c = 2.0 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
return radius * c
';

select haversine(-50, 50, 60, 60), udf_distance (-50, 50, 60, 60);


alter table nation add column country_code varchar(2);

begin transaction;
update nation set country_code = 'DZ' where n_name = 'ALGERIA';
update nation set country_code = 'AR' where n_name = 'ARGENTINA';
update nation set country_code = 'BR' where n_name = 'BRAZIL';
update nation set country_code = 'CA' where n_name = 'CANADA';
update nation set country_code = 'EG' where n_name = 'EGYPT';
update nation set country_code = 'ET' where n_name = 'ETHIOPIA';
update nation set country_code = 'FR' where n_name = 'FRANCE';
update nation set country_code = 'DE' where n_name = 'GERMANY';
update nation set country_code = 'IN' where n_name = 'INDIA';
update nation set country_code = 'ID' where n_name = 'INDONESIA';
update nation set country_code = 'IR' where n_name = 'IRAN';
update nation set country_code = 'IQ' where n_name = 'IRAQ';
update nation set country_code = 'JP' where n_name = 'JAPAN';
update nation set country_code = 'JO' where n_name = 'JORDAN';
update nation set country_code = 'KE' where n_name = 'KENYA';
update nation set country_code = 'MA' where n_name = 'MOROCCO';
update nation set country_code = 'MZ' where n_name = 'MOZAMBIQUE';
update nation set country_code = 'PE' where n_name = 'PERU';
update nation set country_code = 'CN' where n_name = 'CHINA';
update nation set country_code = 'RO' where n_name = 'ROMANIA';
update nation set country_code = 'SA' where n_name = 'SAUDI ARABIA';
update nation set country_code = 'VN' where n_name = 'VIETNAM';
update nation set country_code = 'RU' where n_name = 'RUSSIA';
update nation set country_code = 'GB' where n_name = 'UNITED KINGDOM';
update nation set country_code = 'US' where n_name = 'UNITED STATES';
commit;


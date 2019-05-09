
use warehouse demo_warehouse_DEMO_NUM;

create or replace database citibike_demo_DEMO_NUM;
use citibike_demo_DEMO_NUM.public;

create or replace TABLE TRIPS (
	TRIPDURATION NUMBER(38,0),
	STARTTIME TIMESTAMP_NTZ(9),
	STOPTIME TIMESTAMP_NTZ(9),
	START_STATION_ID NUMBER(38,0),
	START_STATION_NAME VARCHAR(16777216),
	START_STATION_LATITUDE FLOAT,
	START_STATION_LONGITUDE FLOAT,
	END_STATION_ID NUMBER(38,0),
	END_STATION_NAME VARCHAR(16777216),
	END_STATION_LATITUDE FLOAT,
	END_STATION_LONGITUDE FLOAT,
	BIKEID NUMBER(38,0),
	NAME VARCHAR(16777216),
	USERTYPE VARCHAR(16777216),
	BIRTH_YEAR NUMBER(38,0),
	GENDER NUMBER(38,0)
);
 
copy into trips from @demo_db_DEMO_NUM.public.demodata/trips/;

create or replace table weather (v variant, t timestamp);
copy into weather from (select $1, convert_timezone('UTC', 'US/Eastern', $1:time::timestamp_ntz) from @demo_db_DEMO_NUM.public.demodata/weather) file_format = (type = json);

alter warehouse demo_warehouse_DEMO_NUM set warehouse_size='small';

select count(*) from trips;
select count(*) from weather;
select * from weather limit 20;

create or replace secure view trip_weather_vw as
select *
from trips
  left outer join
  ( select t as observation_time
    ,v:city.id::int as city_id
    ,v:city.name::string as city_name
    ,v:city.country::string as country
    ,v:city.coord.lat::float as city_lat
    ,v:city.coord.lon::float as city_lon
    ,v:clouds.all::int as clouds
    ,(v:main.temp::float)-273.15 as temp_avg
    ,(v:main.temp_min::float)-273.15 as temp_min
    ,(v:main.temp_max::float)-273.15 as temp_max
    ,v:weather[0].id::int as weather_id
    ,v:weather[0].main::string as weather
    ,v:weather[0].description::string as weather_desc
    ,v:weather[0].icon::string as weather_icon
    ,v:wind.deg::float as wind_dir
    ,v:wind.speed::float as wind_speed
   from weather
   where city_id = 5128638)
  on date_trunc(HOUR, starttime) = date_trunc(HOUR, observation_time);

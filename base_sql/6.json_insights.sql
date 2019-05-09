
create or replace database demo_mktg_DEMO_NUM;
create or replace schema demo_mktg_DEMO_NUM.data;

use demo_mktg_DEMO_NUM.data;
use warehouse demo_warehouse_DEMO_NUM;


create or replace table customer_interactions ( json_data variant);

create or replace view vw_distinct_interactions as
select  distinct json_data:id::bigint json_id, json_data:created_at::timestamp created_at from customer_interactions;

create or replace view vw_social_media as
select   json_data:id::bigint json_id,
        value:display_url::string display_url,
        value:expanded_url::string expanded_url,
        value:url::string url,
        value:type::string media_type
from    customer_interactions,
        lateral flatten(input => json_data:entities.media) ;
        
create or replace view  vw_social_mentions as
select  json_data:id::bigint json_id,
        value:text::string hashtag_used
from    customer_interactions,
        lateral flatten(input => json_data:entities.hashtags)
where   value:text::string not like '%??%';    
        
create or replace view vw_customer_profile as
select  json_data:id::bigint json_id,
        json_data:user:screen_name::string screen_name,
        json_data:user:default_profile::string default_profile,
        json_data:user:followers_count::integer followers_count,
        json_data:user:friends_count::integer friends_count,
        json_data:user:geo_enabled::string geo_enabled
from    customer_interactions
;    

create or replace view vw_customer_location as
select  json_data:id::bigint json_id,
        json_data:user:screen_name::string screen_name,
        value[0]::string longitude,
        value[1]::string latitude
from    customer_interactions,
        lateral flatten(input => json_data:coordinates)
where value[0] is not null;
select value[0], value[1] from customer_interactions ,lateral flatten(input => json_data:coordinates ) ;

create or replace view vw_user_mentions as
select  json_data:id::bigint json_id,
        value:screen_name::string user_handle,
        value:name::string  user_name
from    customer_interactions,
        lateral flatten(input => json_data:entities.user_mentions)
where   value:name not like '%?%';

COPY INTO customer_interactions FROM @demo_db_DEMO_NUM.public.demodata/customer_interactions/ pattern='.*customer_interaction.*' file_format = ( type = JSON) ;

-- Most commonly used hashtags
select upper(hashtag_used), count(1), rank() over ( order by count(1) desc)  from vw_social_mentions where hashtag_used not like '%?%' group by 1 order by 2 desc limit 10;

-- Most frequently mentioned user handles
select user_handle, count(1)/count(1) over () relative_frequency from vw_user_mentions group by 1 order by 2 desc limit 10;

-- Get average # of hashtags used per tweet
select avg(hashtag_count) from ( select json_id, count(1) hashtag_count from vw_social_mentions group by 1 );

-- Determine the avg # of followers for users with a default user profile and those with a customer profile
-- and calculate the correlation of friends:followers based on whether or not the default profile is still being used
select default_profile, avg(followers_count), corr(friends_count, followers_count) from vw_customer_profile where friends_count > 10000 group by 1;


-- Find a specific JSON record based on a known ID
select * from customer_interactions where json_data:id = 1016331591767879680;

alter table customer_interactions cluster by (json_data:id::bigint);
alter table customer_interactions recluster;

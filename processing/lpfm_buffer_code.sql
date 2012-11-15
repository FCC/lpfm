-----------------------------------------------------------------------------
-----------FCC LOW POWER FM BUFFER CODE--------------------------------------
-----------NOVEMBER 14, 2014-------------------------------------------------
-----------------------------------------------------------------------------



------------------------------------------------------------
------------------------------------------------------------
---STEP 1:  IMPORT CSV OF FACILITY LOCATIONS INTO POSTGIS---
------------------------------------------------------------
------------------------------------------------------------


CREATE TABLE swat.low_power_fm_points
(
  gid serial NOT NULL,
  channel numeric(10,0),
  "class" character varying(80),
  call_sign character varying(80),
  service_ty character varying(80),
  city character varying(80),
  stateabbr character varying(80),
  country character varying(80),
  degrees numeric(10,0),
  minutes numeric(10,0),
  seconds numeric(10,0),
  latitude numeric,
  degrees_1 numeric(10,0),
  minutes_1 numeric(10,0),
  seconds_1 numeric(10,0),
  longitude numeric,
  translator numeric,
  app_id numeric(10,0),
  id_facilit numeric(10,0),
  file character varying(80),
  geom geometry,
  CONSTRAINT low_power_fm_points_pkey2 PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_geom CHECK (st_ndims(geom) = 2),
  CONSTRAINT enforce_geotype_geom CHECK (geometrytype(geom) = 'POINT'::text OR geom IS NULL),
  CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 4267)
);



copy swat.low_power_fm_points from '/location/lowpowerfm.csv' delimiter ',' csv header; 


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---STEP 2:  UPDATE TABLE TO CREATE GEOMETRY COLUMN (BASED ON LAT/LONG POINTS)---
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


update swat.low_power_fm_points set geom = ST_SetSRID(ST_MakePoint(longitude, latitude),4267); 




-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
---STEP 3:  CREATE EXCLUSION ZONE BUFFERS BASED ON FEDERAL COMUNICATIONS COMMISSION RULE SET---
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


create TABLE swat.low_power_fm_points_buffer
(
  id integer,
  region varchar (25),
  buffer_type varchar(50),
  channel numeric(10,0),
  class character varying(80),
  call_sign character varying(80),
  service_ty character varying(80),
  city character varying(80),
  stateabbr character varying(80),
  country character varying(80),
  latitude numeric,
  longitude numeric,
  translator numeric,
  app_id numeric(10,0),
  id_facilit numeric(10,0),
  file character varying(80),
  geom geometry
);  



-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
---UNITED STATES LOCATIONS (NON-TERRITORY); NON TRANSLATOR; CO-CHANNEL BUFFER TYPE---
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------


--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'USA' as region,   
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),67000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),112000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),87000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),130000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------
------CLASS C0-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),122000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C0' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),111000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS C2-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),91000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C2' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 







---------------------
------CLASS C3-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),78000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C3' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),24000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),24000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 









-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
---UNITED STATES LOCATIONS (NON-TERRITORY); NON TRANSLATOR; FIRST ADJACENT CHANNEL BUFFER TYPE---
-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------



--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'USA' as region,   
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),56000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),97000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),74000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),120000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS C0-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),111000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C0' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),100000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C2-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),80000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C2' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------
------CLASS C3-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),67000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C3' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),13000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),14000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 












--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
---UNITED STATES LOCATIONS (NON-TERRITORY); NON TRANSLATOR; SECOND ADJACENT CHANNEL BUFFER TYPE---
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------



--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'USA' as region,   
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),29000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS B--------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),67000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX')  and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),46000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),93000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS C0-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),84000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C0' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),73000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C2-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),53000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C2' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------
------CLASS C3-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),40000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C3' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),6000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') 
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---UNITED STATES LOCATIONS (NON-TERRITORY); NON TRANSLATOR; 53RD AND 54TH ADJACENT CHANNEL BUFFER TYPE---
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------



--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'USA' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),6000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),12000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX')  and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),9000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),28000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------
------CLASS C0-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),22000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C0' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),20000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS C2-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),12000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C2' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 







---------------------
------CLASS C3-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),9000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C3' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






---------------------
------CLASS D-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),3000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'USA' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252) 
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 








-------------------------------------------------------
-------------------------------------------------------
---ALL LOCATIONS; TRANSLATOR; CO-CHANNEL BUFFER TYPE---
-------------------------------------------------------
-------------------------------------------------------

----------------------------------
--------0 < DISTANCE < 7.3--------
----------------------------------


insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 39000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator < 7.3 and translator > 0
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------------------------
--------7.3 <= DISTANCE < 13.3--------
--------------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 32000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 7.3 and translator < 13.3
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



--------------------------------
--------DISTANCE >= 13.3--------
--------------------------------


insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 26000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 13.3
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



----------------------------
--------DISTANCE = 0--------
----------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 4000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator = 0
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




-------------------------------------------------------------------
-------------------------------------------------------------------
---ALL LOCATIONS; TRANSLATOR; FIRST ADJACENT CHANNEL BUFFER TYPE---
-------------------------------------------------------------------
-------------------------------------------------------------------


----------------------------------
--------0 < DISTANCE < 7.3--------
----------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 28000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator < 7.3 and translator > 0
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


--------------------------------------
--------7.3 <= DISTANCE < 13.3--------
--------------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 21000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 7.3 and translator < 13.3
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


--------------------------------
--------DISTANCE >= 13.3--------
--------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 15000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 13.3
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



----------------------------
--------DISTANCE = 0--------
----------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 4000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator = 0
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




--------------------------------------------------------------------
--------------------------------------------------------------------
---ALL LOCATIONS; TRANSLATOR; SECOND ADJACENT CHANNEL BUFFER TYPE---
--------------------------------------------------------------------
--------------------------------------------------------------------

----------------------------------
--------0 < DISTANCE < 7.3--------
----------------------------------


insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 21000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator < 7.3 and translator > 0
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


--------------------------------------
--------7.3 <= DISTANCE < 13.3--------
--------------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,  
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 14000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 7.3 and translator < 13.3
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


--------------------------------
--------DISTANCE >= 13.3--------
--------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'secondadjacent' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 8000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 13.3
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


----------------------------
--------DISTANCE = 0--------
----------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 4000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator = 0
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------------------------------------------------------------
---------------------------------------------------------------------------
---ALL LOCATIONS; TRANSLATOR; 53RD AND 54TH ADJACENT CHANNEL BUFFER TYPE---
---------------------------------------------------------------------------
---------------------------------------------------------------------------

----------------------------------
--------0 < DISTANCE < 7.3--------
----------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 5000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator < 7.3 and translator > 0 and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


--------------------------------------
--------7.3 <= DISTANCE < 13.3--------
--------------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,    
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 5000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 7.3 and translator < 13.3 and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


--------------------------------
--------DISTANCE >= 13.3--------
--------------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,   
  'adjacent5354' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 5000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator >= 13.3 and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



----------------------------
--------DISTANCE = 0--------
----------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'ANY' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 4000),4326)) as geom
  from swat.low_power_fm_points
where service_ty in ('FX') and translator = 0 and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 







----------------------------------------------------
----------------------------------------------------
---CANADA; NON TRANSLATOR; CO-CHANNEL BUFFER TYPE---
----------------------------------------------------
----------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,   
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),66000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS A1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,     
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),45000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'cochannel' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),92000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),78000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),124000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),113000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'cochannel' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 45000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






----------------------------------------------------------------
----------------------------------------------------------------
---CANADA; NON TRANSLATOR; FIRST ADJACENT CHANNEL BUFFER TYPE---
----------------------------------------------------------------
----------------------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,   
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),50000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS A1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,      
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),30000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'firstadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),76000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),62000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),108000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),98000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'firstadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 30000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 







-----------------------------------------------------------------
-----------------------------------------------------------------
---CANADA; NON TRANSLATOR; SECOND ADJACENT CHANNEL BUFFER TYPE---
-----------------------------------------------------------------
-----------------------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,   
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),41000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS A1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,     
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),21000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'secondadjacent' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),68000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'secondadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),53000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS C-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),99000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'secondadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),89000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'secondadjacent' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 21000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 







----------------------------------------------------------------
----------------------------------------------------------------
---CANADA; NON TRANSLATOR; THIRD ADJACENT CHANNEL BUFFER TYPE---
----------------------------------------------------------------
----------------------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,   
  'thirdadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),40000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS A1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,    
  'thirdadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),20000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'thirdadjacent' as buffer_type,      
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),66000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'thirdadjacent' as buffer_type,      
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),52000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'thirdadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),98000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'thirdadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),88000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'thirdadjacent' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 20000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






------------------------------------------------------------------------
------------------------------------------------------------------------
---CANADA; NON TRANSLATOR; 53RD AND 54TH ADJACENT CHANNEL BUFFER TYPE---
------------------------------------------------------------------------
------------------------------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),7000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS A1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'CANADA' as region,    
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),4000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'A1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'adjacent5354' as buffer_type,      
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),12000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'adjacent5354' as buffer_type,      
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),9000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'adjacent5354' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),28000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'adjacent5354' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),19000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'CANADA' as region,   
  'adjacent5354' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 4000),4326)) as geom
  from swat.low_power_fm_points
where country = 'CA' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 












----------------------------------------------------
----------------------------------------------------
---MEXICO; NON TRANSLATOR; CO-CHANNEL BUFFER TYPE---
----------------------------------------------------
----------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,   
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),43000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS AA-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,    
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),47000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'AA' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,    
  'cochannel' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),91000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),67000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),110000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




--------------------
------CLASS C1-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,    
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),91000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,    
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),27000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 








----------------------------------------------------------------
----------------------------------------------------------------
---MEXICO; NON TRANSLATOR; FIRST ADJACENT CHANNEL BUFFER TYPE---
----------------------------------------------------------------
----------------------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,   
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),32000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS AA-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,    
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),36000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'AA' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'firstadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),76000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),54000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),100000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),80000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),17000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 









-----------------------------------------------------------------
-----------------------------------------------------------------
---MEXICO; NON TRANSLATOR; SECOND ADJACENT CHANNEL BUFFER TYPE---
-----------------------------------------------------------------
-----------------------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,   
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),25000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS AA-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),29000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'AA' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,   
  'secondadjacent' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),66000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS B1-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'secondadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),45000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),92000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




---------------------
------CLASS C1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'secondadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),73000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'secondadjacent' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),9000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 











------------------------------------------------------------------------
------------------------------------------------------------------------
---MEXICO; NON TRANSLATOR; 53RD AND 54TH ADJACENT CHANNEL BUFFER TYPE---
------------------------------------------------------------------------
------------------------------------------------------------------------

--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),5000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'A' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



---------------------
------CLASS AA-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'MEXICO' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),6000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'AA' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,   
  'adjacent5354' as buffer_type,     
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),11000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'B' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'adjacent5354' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),8000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class= 'B1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),27000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




--------------------
------CLASS C1-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'adjacent5354' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),19000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'C1' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'MEXICO' as region,  
  'adjacent5354' as buffer_type,    
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),3000),4326)) as geom
  from swat.low_power_fm_points
where country = 'MX' and class = 'D' and service_ty not in ('FX') and stateabbr not in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 







------------------------------------------------------------------
------------------------------------------------------------------
---PUERTO RICO & MEXICO; NON TRANSLATOR; CO-CHANNEL BUFFER TYPE---
------------------------------------------------------------------
------------------------------------------------------------------



--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'TERR' as region,   
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),80000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),138000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX')  and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),138000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'B' and service_ty not in ('FX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS B1-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),95000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),95000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class= 'B1' and service_ty not in ('FX') 
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),138000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),138000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'C' and service_ty not in ('FX') 
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'cochannel' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),24000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'cochannel' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),24000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 










------------------------------------------------------------------------------
------------------------------------------------------------------------------
---PUERTO RICO & MEXICO; NON TRANSLATOR; FIRST ADJACENT CHANNEL BUFFER TYPE---
------------------------------------------------------------------------------
------------------------------------------------------------------------------


--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'TERR' as region,   
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),70000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),123000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX')  and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),123000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'B' and service_ty not in ('FX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),82000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),82000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class= 'B1' and service_ty not in ('FX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),123000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),123000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'C' and service_ty not in ('FX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'firstadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),14000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'firstadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),14000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 










-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---PUERTO RICO & MEXICO; NON TRANSLATOR; SECOND ADJACENT CHANNEL BUFFER TYPE---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------



--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'TERR' as region,   
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),42000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),92000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX')  and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),92000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'B' and service_ty not in ('FX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),53000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),53000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class= 'B1' and service_ty not in ('FX') 
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),92000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 







insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),92000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'C' and service_ty not in ('FX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'secondadjacent' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region, 
  'secondadjacent' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 








--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
---PUERTO RICO & MEXICO; NON TRANSLATOR; 53RD adn 54TH ADJACENT CHANNEL BUFFER TYPE---
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------


--------------------
------CLASS A-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'TERR' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),9000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'A' and service_ty not in ('FX') and stateabbr in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;  



--------------------
------CLASS B-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),19000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'B' and service_ty not in ('FX')  and stateabbr in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region, 
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),19000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'B' and service_ty not in ('FX') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS B1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,  
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),11000),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class= 'B1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),11000),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class= 'B1' and service_ty not in ('FX') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





--------------------
------CLASS C-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'C' and service_ty not in ('FX') and stateabbr in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country in ('VI', 'BV') and class = 'C' and service_ty not in ('FX') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





--------------------
------CLASS D-------
--------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'adjacent5354' as buffer_type,   
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'D' and service_ty not in ('FX') and stateabbr in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 





---------------------
------CLASS L1-------
---------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id, 
  'TERR' as region,   
  'adjacent5354' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163),0),4326)) as geom
  from swat.low_power_fm_points
where country = 'US' and class = 'L1' and service_ty not in ('FX') and stateabbr in ('PR', 'VI') and channel not in (6, 248, 249, 250, 251, 252)
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 




------------------------------------------------------------------------
------------------------------------------------------------------------
---ANY LOCATION; TV6 CHANNEL BUFFER TYPE FOR SERVICE TYPES "DT", "TV"---
------------------------------------------------------------------------
------------------------------------------------------------------------


------------------------
------CHANNEL 201-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '201_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 140000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



------------------------
------CHANNEL 202-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '202_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 138000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



------------------------
------CHANNEL 203-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '203_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 137000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






------------------------
------CHANNEL 204-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '204_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 136000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 205-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '205_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 135000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;



------------------------
------CHANNEL 206-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '206_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 133000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 207-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '207_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 133000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 208-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '208_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 133000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 209-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '209_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 133000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 210-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '210_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 133000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 211-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '211_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 133000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 212-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '212_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 132000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 213-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '213_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 132000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 214-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '214_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 132000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 215-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '215_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 131000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 216-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '216_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 131000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 217-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '217_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 131000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 218-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '218_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 131000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 219-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '219_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 130000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 220-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '220_DTTV_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 130000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('DT', 'TV')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;









------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
---ANY LOCATION; TV6 CHANNEL BUFFER TYPE FOR SERVICE TYPES "CA", "DC", "LD", "TX", "DX"---
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

------------------------
------CHANNEL 201-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '201_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 98000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 


------------------------
------CHANNEL 202-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '202_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 97000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 



------------------------
------CHANNEL 203-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '203_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 95000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit; 






------------------------
------CHANNEL 204-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '204_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 94000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 205-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '205_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 93000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;



------------------------
------CHANNEL 206-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '206_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 91000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 207-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '207_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 91000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 208-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '208_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 91000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 209-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '209_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 91000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 210-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '210_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 91000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 211-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '211_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 91000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 212-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '212_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 90000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 213-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '213_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 90000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 214-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '214_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 90000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 215-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '215_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 90000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 216-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '216_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 89000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 217-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '217_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 89000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;





------------------------
------CHANNEL 218-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '218_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 89000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




------------------------
------CHANNEL 219-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '219_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 89000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;






------------------------
------CHANNEL 220-------
------------------------

insert into swat.low_power_fm_points_buffer 

select 
  gid as id,
  'ANY' as region,   
  '220_CADC_tv6' as buffer_type,  
  channel,
  class,
  call_sign,
  service_ty,
  city,
  stateabbr,
  country,
  latitude,
  longitude,
  translator,
  app_id,
  id_facilit,
  file,
  st_union(st_transform(st_buffer(st_transform(geom, 2163), 89000),4326)) as geom
  from swat.low_power_fm_points
where channel = 6 and service_ty in ('CA', 'DC', 'LD', 'TX', 'DX')
group by gid, channel, class, call_sign, service_ty, city, stateabbr, country, latitude, longitude, translator, app_id, id_facilit, file; commit;




CREATE INDEX geomradius
  ON  swat.low_power_fm_points_buffer
  USING gist
  (geom);





-----------------------------------------------------
-----------------------------------------------------
---NOTE: IGNORE TV6 CHANNEL TYPES "TA", "DR", "DN"---
-----------------------------------------------------
-----------------------------------------------------













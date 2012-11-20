Assets - readme.md
==================

Folders
-------
- none

Files
-----
- lowpowerfm.csv.zip - comma delimeted data file containing source data as of October 2012.  this file is one record per FM tower location in the US.  It contains fields for; class,channel,call_sign,service_type,city,stateabbr,country,degrees,minutes,seconds,latitude,degrees,minutes,seconds,longitude,translator_dist,app_id,id_facility,file.  values in these fields contain the rules for excluding channels which provide the opportunity for Low Power FM.
- usa_wgs.zip - zipped shape file of the US + territories.  used as a background polygon to asset w/ postgis st_intersect.  1:10 million scale

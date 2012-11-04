lpfm
====

creating the low power FM map

What Problem this Solves
------------------------
Low Power FM (LPFM) is an opportunity for local users to start their own broadcasting stations on unused frequencies in their area.  Currently the rules around LPFM are arduous and difficult to visualize.

How this Project Solves this Problem
------------------------------------
This project takes all of the towers broadcasting all of the FM stations, and with their attributes and associated protection rules, creates the landscape of opportunities for Low Power FM.  That is, it creates the map of which channels are open where given the current landscape of protected stations.

Requirements
------------
The end goal is that output maintains the (1) total number of excluded channels at all spaces - the total field -  (2) each excluded channel at all spaces - c<number> field - and (3) and all polygons as simple, single geometries (e.g. no overlapping, no multipart).

Files
------
- lpfm.py - primary code to develop the output polygons
- *.shp - associated temporary example shape files
	- lpfm_nc.shp - all protected areas for north carolina
	- lpfm_test1.shp - simple example of 2 concentric rings of a protected station
	- lpfm_test.shp - simple example of 4 concentric rings of a protected station
	- co.shp - all co-channel stations in north carolina
	- ad5354.shp - all adjacent 53 and 54 stations in north carolina
	- firstad.shp- all first adjacent stations in north carolina
	- sec.shp - all second adjacent stations in north carolina
	- tv6.shp - all tv 6 protected stations in north carolina

Dependencies
------------
- PostGIS (using OpenGeo Suite)
- psycopg (python library for PostgresSQL - http://www.initd.org/psycopg/)

Notes
-----
- edit lines 16 - 22 for database connection setups
- this script reads in the input shape file and begins operating on it
- the output is named <schema>.lfpm
- script has only been tested on Mac OSX python/psycopg/OpenGeo

Problems 
--------
am having problems w/ st_union throwing errors on node intersections; there are of course tons of slivers and the like, which i try to mitigate for.
using the input shapes (test and test1 work fine, but the co shape throws an error at record 81 in the loop.  look at the <schema>.working for the resulting

the resulting script needs to run on 38,000 polygons nationwide
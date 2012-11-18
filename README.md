lpfm
====

creating the low power FM map

What Problem this Solves
------------------------
Low Power FM (LPFM) is an opportunity for local users to start their own broadcasting stations on unused frequencies in their area.  Currently the rules around LPFM are difficult to visualize.

How this Project Solves this Problem
------------------------------------
This project takes all of the towers broadcasting all of the FM stations, and with their attributes and associated protection rules, creates the landscape of opportunities for Low Power FM.  That is, it creates the map of which channels are open where given the current landscape of protected stations.

Dependencies
------------
- PostGIS (using OpenGeo Suite)
- psycopg (python library for PostgresSQL - http://www.initd.org/psycopg/)

Folders
-------
- assets - folder containing the data assets required for this process
- processing - contains the procesisng steps
- visualization - contains the visualization steps

Files
-----
- lpfm.py - original code; no longer used

Problems 
--------
in original code base, I had problems w/ st_difference (parallel buffers), and st_union of complex geometries;  i switched to using only st_intersection w/ universe polygon of union of all US area (at 1:10 million)

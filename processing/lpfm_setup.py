## ---------------------------------------------------------------------------
###   VERSION 0.1 (for postgis)
### lpfm_union.py
### Created on: november 17, 2012
### Created by: Michael Byrne
### Federal Communications Commission 
##sandy
## ---------------------------------------------------------------------------
##this script runs the lpfm union


# Import system modules
import sys, string, os
import psycopg2
import time
now = time.localtime(time.time())
print "local time:", time.asctime(now)

#variables
myHost = "localhost"
myPort = "54321"
myUser = "postgres"
db = "fccgis"
schema = "lpfm"
finalTB = "lpfm_union"
usTbl = "usa_wgs"


def lpfm_clean(myNum):
	theUpdCur = conn.cursor()
	theSQL = "DELETE FROM " + schema + ".int" + myNum + " where st_area(geom) = 0 or "
	theSQL = theSQL + "st_perimeter(geom) = 0;"
	theUpdCur.execute(theSQL)
	conn.commit()
	theSQL = "UPDATE " + schema + ".int" + myNum + " set geom = st_buffer(geom,0);"
	theUpdCur.execute(theSQL)
	conn.commit()	 
	theUpdCur.close()	
	del theSQL, myNum, theUpdCur
	return()

def lpfm_union():
	theUpdCur = conn.cursor()
	theSQL = "DROP TABLE IF EXISTS " + schema + ".int201;"
	theUpdCur.execute(theSQL)
	conn.commit()	
	theSQL = "CREATE TABLE " + schema + ".int201 as select * from " + schema + ".c201;"
	theUpdCur.execute(theSQL)
	conn.commit()
	for i in range(202, 203):
		print "   ... working on " + str(i)
		#perform an intersection on the previous one
		theSQL = "DROP TABLE IF EXISTS " + schema + ".int" + str(i) + ";"		
		theSQL = theSQL + "CREATE TABLE " + schema + ".int" + str(i) + " as select "
		theSQL = theSQL + "(ST_DUMP(ST_INTERSECTION(int" + str(i-1) + ".geom, c" + str(i)
		theSQL = theSQL + ".geom))).geom as geom" 
		theTxt = ""
		for j in range(201, i + 1):
			theTxt = theTxt + ", c" + str(j)
		theSQL = theSQL + theTxt
		theSQL = theSQL + " from " + schema + ".int" + str(i-1) + ", " + schema 
		theSQL = theSQL + ".c" + str(i) + ";"  
		theSQL = theSQL + "CREATE INDEX int" + str(i) + "_geom_gist ON " + schema 
		theSQL = theSQL + ".int" + str(i) + " USING gist (geom);"  
		theSQL = theSQL + "ALTER TABLE " + schema + ".int" + str(i) + " ADD COLUMN gid "
		theSQL = theSQL + "SERIAL NOT NULL, ADD CONSTRAINT int" + str(i) + "_gid_pkey "
		theSQL = theSQL + "PRIMARY KEY (gid), ADD CONSTRAINT enforce_dims_geom CHECK "
		theSQL = theSQL + "(st_ndims(geom) = 2), ADD CONSTRAINT enforce_srid_geom "
		theSQL = theSQL + "CHECK (st_srid(geom) = 4326);"
		theUpdCur.execute(theSQL)
		conn.commit()
		theSQL = "DROP TABLE IF EXISTS lpfm.int" + str(i-2) + ";"
		theUpdCur.execute(theSQL)
		conn.commit()
		lpfm_clean(str(i))
		del theTxt
	theUpdCur.close()     
	del theSQL, theUpdCur
	return()
     
#set up the connection to the database
myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
conn = psycopg2.connect(myConn)
lpfm_union()

conn.close()
now = time.localtime(time.time())
print "local time:", time.asctime(now)
del conn, myConn
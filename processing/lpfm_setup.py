## ---------------------------------------------------------------------------
###   VERSION 0.1 (for postgis)
### lpfm_setup.py
### Created on: october 29, 2012
### Created by: Michael Byrne
### Federal Communications Commission 
##sandy
## ---------------------------------------------------------------------------
##this script runs the lpfm setup
##the intent of this script is to take the input shape file and develop individual 
##shape files per channe
##dependencies
##software
##runs in python
##postgres/gis (open geo suite)
##the psycopg library
##data
##a shapefile of the the buffers of the towers excluding lpfm
##creates 1 output shapefile per channel

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
db = "feomike"
schema = "lpfm"
finalTB = "lpfm"
srcshp = "mike_lpfm__buffer_nov14"
usTbl = "usa_wgs"
     
#function adding all the final fields to the imported shape
def lpfm_alter_fields(myTbl):
     theSQL = "ALTER TABLE " + schema + "." + myTbl + " "
     theSQL = theSQL + "ADD COLUMN c201 numeric, ADD COLUMN c202 numeric, ADD COLUMN c203 numeric, ADD COLUMN c204 numeric, ADD COLUMN c205 numeric, ADD COLUMN c206 numeric, ADD COLUMN c207 numeric, ADD COLUMN c208 numeric, ADD COLUMN c209 numeric, ADD COLUMN c210 numeric, "
     theSQL = theSQL + "ADD COLUMN c211 numeric, ADD COLUMN c212 numeric, ADD COLUMN c213 numeric, ADD COLUMN c214 numeric, ADD COLUMN c215 numeric, ADD COLUMN c216 numeric, ADD COLUMN c217 numeric, ADD COLUMN c218 numeric, ADD COLUMN c219 numeric, ADD COLUMN c220 numeric, "
     theSQL = theSQL + "ADD COLUMN c221 numeric, ADD COLUMN c222 numeric, ADD COLUMN c223 numeric, ADD COLUMN c224 numeric, ADD COLUMN c225 numeric, ADD COLUMN c226 numeric, ADD COLUMN c227 numeric, ADD COLUMN c228 numeric, ADD COLUMN c229 numeric, ADD COLUMN c230 numeric, "
     theSQL = theSQL + "ADD COLUMN c231 numeric, ADD COLUMN c232 numeric, ADD COLUMN c233 numeric, ADD COLUMN c234 numeric, ADD COLUMN c235 numeric, ADD COLUMN c236 numeric, ADD COLUMN c237 numeric, ADD COLUMN c238 numeric, ADD COLUMN c239 numeric, ADD COLUMN c240 numeric, "
     theSQL = theSQL + "ADD COLUMN c241 numeric, ADD COLUMN c242 numeric, ADD COLUMN c243 numeric, ADD COLUMN c244 numeric, ADD COLUMN c245 numeric, ADD COLUMN c246 numeric, ADD COLUMN c247 numeric, ADD COLUMN c248 numeric, ADD COLUMN c249 numeric, ADD COLUMN c250 numeric, "
     theSQL = theSQL + "ADD COLUMN c251 numeric, ADD COLUMN c252 numeric, ADD COLUMN c253 numeric, ADD COLUMN c254 numeric, ADD COLUMN c255 numeric, ADD COLUMN c256 numeric, ADD COLUMN c257 numeric, ADD COLUMN c258 numeric, ADD COLUMN c259 numeric, ADD COLUMN c260 numeric, "
     theSQL = theSQL + "ADD COLUMN c261 numeric, ADD COLUMN c262 numeric, ADD COLUMN c263 numeric, ADD COLUMN c264 numeric, ADD COLUMN c265 numeric, ADD COLUMN c266 numeric, ADD COLUMN c267 numeric, ADD COLUMN c268 numeric, ADD COLUMN c269 numeric, ADD COLUMN c270 numeric, "
     theSQL = theSQL + "ADD COLUMN c271 numeric, ADD COLUMN c272 numeric, ADD COLUMN c273 numeric, ADD COLUMN c274 numeric, ADD COLUMN c275 numeric, ADD COLUMN c276 numeric, ADD COLUMN c277 numeric, ADD COLUMN c278 numeric, ADD COLUMN c279 numeric, ADD COLUMN c280 numeric, "
     theSQL = theSQL + "ADD COLUMN c281 numeric, ADD COLUMN c282 numeric, ADD COLUMN c283 numeric, ADD COLUMN c284 numeric, ADD COLUMN c285 numeric, ADD COLUMN c286 numeric, ADD COLUMN c287 numeric, ADD COLUMN c288 numeric, ADD COLUMN c289 numeric, ADD COLUMN c290 numeric, "
     theSQL = theSQL + "ADD COLUMN c291 numeric, ADD COLUMN c292 numeric, ADD COLUMN c293 numeric, ADD COLUMN c294 numeric, ADD COLUMN c295 numeric, ADD COLUMN c296 numeric, ADD COLUMN c297 numeric, ADD COLUMN c298 numeric, ADD COLUMN c299 numeric, ADD COLUMN c300 numeric, ADD COLUMN total numeric; "
     theUpdCur = conn.cursor()
     theUpdCur.execute(theSQL)
     conn.commit()
     theUpdCur.close()     
     del myTbl, theSQL, theUpdCur
     return()

#function initializing all the final fields to the imported shape
def lpfm_initialize_fields(myTbl):
     theUpdCur = conn.cursor()
     myList = ["cochannel","firstadjacent","secondadjacent","thirdadjacent"]
     for i in myList:
          if i == "cochannel":
               myCalcs = [0]
          if i == "firstadjacent":
               myCalcs = [0,1,-1]
          if i == "secondadjacent":
               myCalcs = [0,1,2,-1,-2]
          if i == "thirdadjacent":
               myCalcs = [0,1,-1,2,-2,3,-3]
          for j in range(201, 301):
               for k in myCalcs: 
               	print "working on - " + str(i) + ": chanel - " + str(j) + ": - " + str(k)  
               	#print "j + k is: " + str(j + k)
               	if (j + k > 200) and (j + k < 301):  #for all normal ones
               		#build and excecute update sql
               		theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j + k) + " = 1 where buffer_typ = '" + str(i)
               		theSQL = theSQL + "' and channel = " + str(j) + ";"
               		theUpdCur.execute(theSQL)
               		conn.commit()
     for j in range(201, 221):  #update the tv6 ones
     	theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j) + " = 1 "
     	theSQL = theSQL + "where buffer_typ like '" + str(j) + "%tv6'; "
     	theUpdCur.execute(theSQL)
     	conn.commit()
     theUpdCur.close()
     return()

#dissolve each c<field> into its own dataset
def lpfm_dissolve_cfields():
	#the ST_Dump creates separate polygons
	mkCur = conn.cursor()	
	for i in range(201,301):
		print "       working on: " + str(i)
		theSQL = "DROP TABLE if EXISTS " + schema + ".mytest;"
		theSQL = theSQL + "create table " + schema + ".mytest as "
		theSQL = theSQL + "SELECT (st_dump(st_union(geom))).geom as geom, c" + str(i) 
		theSQL = theSQL + " FROM " + schema + "." + finalTB + "_data "
		theSQL = theSQL + "WHERE c" + str(i) + " = 1 group by c" + str(i) + ";"
		mkCur.execute(theSQL)
		conn.commit()
		theSQL = "DROP TABLE if EXISTS " + schema + ".c" + str(i) + ";"
		theSQL = theSQL + "CREATE TABLE " + schema + ".c" + str(i) + " as select (ST_DUMP("
		theSQL = theSQL + "ST_INTERSECTION(" + usTbl + ".geom,mytest.geom)))"
		theSQL = theSQL + ".geom as geom, c" + str(i) + " from " + schema + "." + usTbl
		theSQL = theSQL + "," + schema + ".mytest;" 
		theSQL = theSQL + "ALTER TABLE " + schema + ".c" + str(i) 
		theSQL = theSQL +  " ADD COLUMN gid SERIAL NOT NULL, ADD CONSTRAINT c" + str(i)
		theSQL = theSQL + "_pkey PRIMARY KEY (gid), ADD CONSTRAINT enforce_dims_geom "
		theSQL = theSQL + "CHECK (st_ndims(geom) = 2), add CONSTRAINT enforce_srid_geom "
		theSQL = theSQL + "CHECK (st_srid(geom) = 4326);"
		theSQL = theSQL + "CREATE INDEX " + schema + "_c" + str(i) + "_geom_gist on "
		theSQL = theSQL + schema + ".c" + str(i) + " USING gist (geom);" 
		mkCur.execute(theSQL)
		conn.commit()
		theSQL = "INSERT INTO " + schema + ".c" + str(i) + " select ST_DIFFERENCE("
		theSQL = theSQL + "ST_UNION(" + usTbl + ".geom), ST_UNION(mytest.geom)) as geom"
		theSQL = theSQL + " from " + schema + "." + usTbl + ", " + schema + ".mytest "
		theSQL = theSQL + "where ST_INTERSECTS(mytest.geom, " + usTbl + ".geom);"
		mkCur.execute(theSQL)
		conn.commit()				
	theSQL = "DROP TABLE if EXISTS " + schema + ".mytest;"
	mkCur.execute(theSQL)
	conn.commit()	 
	mkCur.close()
	del mkCur, theSQL, i
	return()     

def lpfm_import_shape():
	cur = conn.cursor()
	cur.execute("DROP TABLE if exists " + schema + "." + finalTB + "_data")
	conn.commit()
	cur.close
	del cur
	theSQL = "shp2pgsql -s 4326 -I -W latin1 -g geom " + srcshp + ".shp " +  schema + "."
	theSQL = theSQL + finalTB + "_data " +  db + " | psql -p 54321 -h localhost " + db
	os.system(theSQL)
	##add fields to the imported table to support channel exclusions/total
	print "...altering table: " + finalTB + "_data"
	lpfm_alter_fields(finalTB + "_data")
	return()
     
#set up the connection to the database
myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
conn = psycopg2.connect(myConn)

##import shape
##using the name <finalTB>_data to denote the dataset containing the buffered shapes
##origin of <finalTB>_data is a shapefile
print "...importing shape..."
lpfm_import_shape()

##initialize fields - this function takes a couple of hours
print "...initializing fields..."
lpfm_initialize_fields(finalTB + "_data")

##dissolve each c<field> into its own table
print "dissolving ..."
lpfm_dissolve_cfields()

conn.close()
now = time.localtime(time.time())
print "local time:", time.asctime(now)

  
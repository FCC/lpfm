#mike byrne
#fcc
#october 29, 2012
##sandy
#this script runs the lpfm analysis
#dependencies
#software
#runs in python
#postgres/gis (open geo suite)
#the psycopg library
#data
#a shapefile of the the buffers of the towers excluding lpfm

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
srcshp = "lpfm_all_buffers" #mikenclpfm, lpfm_test(1)

#function for updating the field values
def lpfm_calc_exclusions (myTbl, myField):
     theSQL = "Update " + schema + "." + myTbl + " set c" + str(myField)
	theSQL = theSQL + " = 1;"
	theUpdCur = conn.cursor()
	theUpdCur.execute(theSQL)
	conn.commit()
	theUpdCur.close()
	del theUpdCur, theSQL, myField, myTbl
	return()

def lpfm_clean_poly(myTbl):
	clnCur = conn.cursor()
	#update <schema>.myTbl to make geometries valid
	theSQL = "UPDATE " + schema + "." + myTbl + " set geom = (Select st_buffer(geom,0) as geom );"
	clnCur.execute(theSQL)
	conn.commit()
	theSQL = "DELETE from " + schema + "." + myTbl + " where geom is null;"
	clnCur.execute(theSQL)
	conn.commit()	
	del clnCur, theSQL, myTbl
	
#function for inserting intersected polys from finalTB to working
def lpfm_insert_to_working (myChan):
	wkCur = conn.cursor()
#	#case #1 - polygons which are in both c<field> and finalTB
	theSQL = "INSERT INTO " + schema + ".working select ST_SnapToGrid(ST_Intersection(c"  
	theSQL = theSQL + myChan + ".geom, st_buffer(" + finalTB + ".geom,0)),0.0000001) as geom, total, " 
	theSQL = theSQL + "c201, c202, C203, C204, C205, C206, C207, C208, C209, "
	theSQL = theSQL + "c210, c211, c212, C213, C214, C215, C216, C217, C218, C219, "
	theSQL = theSQL + "c220, c221, c222, C223, C224, C225, C226, C227, C228, C229, "
	theSQL = theSQL + "c230, c231, c232, C233, C234, C235, C236, C237, C238, C239, "
	theSQL = theSQL + "c240, c241, c242, C243, C244, C245, C246, C247, C248, C249, "
	theSQL = theSQL + "c250, c251, c252, C253, C254, C255, C256, C257, C258, C259, "
	theSQL = theSQL + "c260, c261, c262, C263, C264, C265, C266, C267, C268, C269, "
	theSQL = theSQL + "c270, c271, c272, C273, C274, C275, C276, C277, C278, C279, "
	theSQL = theSQL + "c280, c281, c282, C283, C284, C285, C286, C287, C288, C289, "
	theSQL = theSQL + "c290, c291, c292, C293, C294, C295, C296, C297, C298, C299, "
	theSQL = theSQL + "c300 "
	theSQL = theSQL + "from " + schema + ".c" + myChan + ", " + schema + "." + finalTB
	theSQL = theSQL + " where st_intersects(c" + myChan + ".geom, " + finalTB + ".geom);"
	wkCur.execute(theSQL)
	conn.commit()
	lpfm_clean_poly("working")
	#case #2 - polygons which are in c<field> and not in finalTB #case2
	theSQL = "INSERT INTO " + schema + ".working select ST_SnapToGrid(ST_Difference(c"  
	theSQL = theSQL + myChan + ".geom, st_buffer(" + finalTB + ".geom,0)),0.0000001) as geom "
	theSQL = theSQL + "from " + schema + ".c" + myChan + ", " + schema + "." + finalTB
	theSQL = theSQL + " where st_intersects(c" + myChan + ".geom, " + finalTB + ".geom);"
	wkCur.execute(theSQL)
	conn.commit()
	lpfm_clean_poly("working")
	#update working.c<field> for both case #1 and case #2
	lpfm_calc_exclusions("working",myChan)
	#case #3 - polygons in finalTB which are not in c<field> case #3
	#preserve the attributes and no need to calc_exclusions b/c these don't intersect
	theSQL = "INSERT INTO " + schema + ".working select ST_SnapToGrid(ST_Difference("  
	theSQL = theSQL + finalTB + ".geom, c" + myChan + ".geom),0.0000001) as geom, total, " 
	theSQL = theSQL + "c201, c202, C203, C204, C205, C206, C207, C208, C209, "
	theSQL = theSQL + "c210, c211, c212, C213, C214, C215, C216, C217, C218, C219, "
	theSQL = theSQL + "c220, c221, c222, C223, C224, C225, C226, C227, C228, C229, "
	theSQL = theSQL + "c230, c231, c232, C233, C234, C235, C236, C237, C238, C239, "
	theSQL = theSQL + "c240, c241, c242, C243, C244, C245, C246, C247, C248, C249, "
	theSQL = theSQL + "c250, c251, c252, C253, C254, C255, C256, C257, C258, C259, "
	theSQL = theSQL + "c260, c261, c262, C263, C264, C265, C266, C267, C268, C269, "
	theSQL = theSQL + "c270, c271, c272, C273, C274, C275, C276, C277, C278, C279, "
	theSQL = theSQL + "c280, c281, c282, C283, C284, C285, C286, C287, C288, C289, "
	theSQL = theSQL + "c290, c291, c292, C293, C294, C295, C296, C297, C298, C299, "
	theSQL = theSQL + "c300 "
	theSQL = theSQL + "from " + schema + ".c" + myChan + ", " + schema + "." + finalTB
	theSQL = theSQL + " where st_intersects(" + finalTB + ".geom, c" + myChan + ".geom);"
	wkCur.execute(theSQL)
	conn.commit()
	lpfm_clean_poly("working")
	#delete from <schema>.finalTB where the intersects occurs
	theSQL = "DELETE FROM " + schema + "." + finalTB + " using " + schema + ".c"
	theSQL = theSQL + myChan + " where st_intersects( " + finalTB + ".geom, c"
	theSQL = theSQL + myChan + ".geom);"
	wkCur.execute(theSQL)
	conn.commit()	
	lpfm_clean_poly(finalTB)
	theSQL = "INSERT INTO " + schema + "." + finalTB + " select ST_Union("  
	theSQL = theSQL + "geom) as geom, total, " 
	theSQL = theSQL + "c201, c202, C203, C204, C205, C206, C207, C208, C209, c210, " 
	theSQL = theSQL + "c211, c212, C213, C214, C215, C216, C217, C218, C219, c220, " 
	theSQL = theSQL + "c221, c222, C223, C224, C225, C226, C227, C228, C229, c230, "
	theSQL = theSQL + "c231, c232, C233, C234, C235, C236, C237, C238, C239, c240, "
	theSQL = theSQL + "c241, c242, C243, C244, C245, C246, C247, C248, C249, c250, "
	theSQL = theSQL + "c251, c252, C253, C254, C255, C256, C257, C258, C259, c260, "
	theSQL = theSQL + "c261, c262, C263, C264, C265, C266, C267, C268, C269, c270, "
	theSQL = theSQL + "c271, c272, C273, C274, C275, C276, C277, C278, C279, c280, "
	theSQL = theSQL + "c281, c282, C283, C284, C285, C286, C287, C288, C289, c290, "
	theSQL = theSQL + "c291, c292, C293, C294, C295, C296, C297, C298, C299, c300 "
	theSQL = theSQL + " from " + schema + ".working GROUP BY total, "
	theSQL = theSQL + "c201, c202, C203, C204, C205, C206, C207, C208, C209, c210, " 
	theSQL = theSQL + "c211, c212, C213, C214, C215, C216, C217, C218, C219, c220, " 
	theSQL = theSQL + "c221, c222, C223, C224, C225, C226, C227, C228, C229, c230, "
	theSQL = theSQL + "c231, c232, C233, C234, C235, C236, C237, C238, C239, c240, "
	theSQL = theSQL + "c241, c242, C243, C244, C245, C246, C247, C248, C249, c250, "
	theSQL = theSQL + "c251, c252, C253, C254, C255, C256, C257, C258, C259, c260, "
	theSQL = theSQL + "c261, c262, C263, C264, C265, C266, C267, C268, C269, c270, "
	theSQL = theSQL + "c271, c272, C273, C274, C275, C276, C277, C278, C279, c280, "
	theSQL = theSQL + "c281, c282, C283, C284, C285, C286, C287, C288, C289, c290, "
	theSQL = theSQL + "c291, c292, C293, C294, C295, C296, C297, C298, C299, c300;"
	wkCur.execute(theSQL)
	conn.commit()
	lpfm_clean_poly(finalTB)
				
#     #ensure no slivers
#     theSQL = "delete from lpfm.working where st_area(geom) / st_perimeter(geom) "
#     theSQL = theSQL + " < 0.00000000001;"
#     theUpdCur.execute(theSQL)
#     conn.commit() 
#     #delete from <schema>.<finalTB> the intersecting ones
#     theSQL = "DELETE FROM " + schema + "." + finalTB + " using " + schema + ".c"
#     theSQL = theSQL + myChan + " where st_intersects( " + finalTB + ".geom, c"
#     theSQL = theSQL + myChan + ".geom);"
#     theUpdCur.execute(theSQL)
#     conn.commit()      
	wkCur.close()   
	del wkCur, theSQL, myChan
	return()

#function for updating the total field value
def lpfm_set_total ():
     theSQL = "Update " + schema + "." + finalTB + " set total = "
     theSQL = theSQL + "coalesce(c201,0) + coalesce(c202,0) + coalesce(c203,0) + coalesce(c204,0) + coalesce(c205,0) + coalesce(c206,0) + coalesce(c207,0) + coalesce(c208,0) + coalesce(c209,0) + "
     theSQL = theSQL + "coalesce(c210,0) + coalesce(c211,0) + coalesce(c212,0) + coalesce(c213,0) + coalesce(c214,0) + coalesce(c215,0) + coalesce(c216,0) + coalesce(c217,0) + coalesce(c218,0) + coalesce(c219,0) + "
     theSQL = theSQL + "coalesce(c220,0) + coalesce(c221,0) + coalesce(c222,0) + coalesce(c223,0) + coalesce(c224,0) + coalesce(c225,0) + coalesce(c226,0) + coalesce(c227,0) + coalesce(c228,0) + coalesce(c229,0) + "
     theSQL = theSQL + "coalesce(c230,0) + coalesce(c231,0) + coalesce(c232,0) + coalesce(c233,0) + coalesce(c234,0) + coalesce(c235,0) + coalesce(c236,0) + coalesce(c237,0) + coalesce(c238,0) + coalesce(c239,0) + "
     theSQL = theSQL + "coalesce(c240,0) + coalesce(c241,0) + coalesce(c242,0) + coalesce(c243,0) + coalesce(c244,0) + coalesce(c245,0) + coalesce(c246,0) + coalesce(c247,0) + coalesce(c248,0) + coalesce(c249,0) + "
     theSQL = theSQL + "coalesce(c250,0) + coalesce(c251,0) + coalesce(c252,0) + coalesce(c253,0) + coalesce(c254,0) + coalesce(c255,0) + coalesce(c256,0) + coalesce(c257,0) + coalesce(c258,0) + coalesce(c259,0) + "
     theSQL = theSQL + "coalesce(c260,0) + coalesce(c261,0) + coalesce(c262,0) + coalesce(c263,0) + coalesce(c264,0) + coalesce(c265,0) + coalesce(c266,0) + coalesce(c267,0) + coalesce(c268,0) + coalesce(c269,0) + "
     theSQL = theSQL + "coalesce(c270,0) + coalesce(c271,0) + coalesce(c272,0) + coalesce(c273,0) + coalesce(c274,0) + coalesce(c275,0) + coalesce(c276,0) + coalesce(c277,0) + coalesce(c278,0) + coalesce(c279,0) + "
     theSQL = theSQL + "coalesce(c280,0) + coalesce(c281,0) + coalesce(c282,0) + coalesce(c283,0) + coalesce(c284,0) + coalesce(c285,0) + coalesce(c286,0) + coalesce(c287,0) + coalesce(c288,0) + coalesce(c289,0) + "
     theSQL = theSQL + "coalesce(c290,0) + coalesce(c291,0) + coalesce(c292,0) + coalesce(c293,0) + coalesce(c294,0) + coalesce(c295,0) + coalesce(c296,0) + coalesce(c297,0) + coalesce(c298,0) + coalesce(c299,0) + coalesce(c300,0) ;"
     theUpdCur = conn.cursor()
     theUpdCur.execute(theSQL)
     conn.commit()
     theUpdCur.close()
     del theSQL, theUpdCur
     return() 
     
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
     myList = ["cochannel","firstadjacent","secondadjacent","thirdadjacent","adjacent5354"]
     for i in myList:
          if i == "cochannel":
               myCalcs = [0]
          if i == "firstadjacent":
               myCalcs = [0,1,-1]
          if i == "secondadjacent":
               myCalcs = [0,1,2,-1,-2]
          if i == "thirdadjacent":
               myCalcs = [0,1,-1,2,-2]
          if i == "adjacent5354":
          	myCalcs = [0,1,-1,2,-2]
          for j in range(209, 212):
               for k in myCalcs: 
               	#print "i is: " + str(i) + " and j is: " + str(j) + " and k is: " + str(k)
               	if (j + k > 200) and (j + k < 301):  #for all normal ones
               		#build and excecute update sql
               		theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j + k) + " = 1 where buffer_typ = '" + str(i)
               		theSQL = theSQL + "' and channel = " + str(j) + ";"
               		theUpdCur.execute(theSQL)
               		conn.commit()
               	if i == "adjacent5354" and j < 247: #also update the 53 and 54 < 247
               		#build and excecute update sql
               		theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j + 53) + " = 1 where buffer_typ = '" + str(i)
               		theSQL = theSQL + "' and channel = " + str(j) + ";"
               		theUpdCur.execute(theSQL)
               		theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j + 54) + " = 1 where buffer_typ = '" + str(i)
               		theSQL = theSQL + "' and channel = " + str(j) + ";"  
               		theUpdCur.execute(theSQL)               		             		
               		conn.commit()
               	if i == "adjacent5354" and j > 254: #also update the 53 and 54 > 354
               		#build and excecute update sql
               		theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j - 53) + " = 1 where buffer_typ = '" + str(i)
               		theSQL = theSQL + "' and channel = " + str(j) + ";"
               		theUpdCur.execute(theSQL)
               		theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j - 54) + " = 1 where buffer_typ = '" + str(i)
               		theSQL = theSQL + "' and channel = " + str(j) + ";"  
               		theUpdCur.execute(theSQL)               		             		
               		conn.commit()
		for j in range(201, 220):  #update the tv6 ones
			theSQL = "UPDATE " + schema + "." + myTbl + " set c" + str(j) + " = 1 "
			theSQL = theSQL + "where buffer_typ like '" + str(j) + "%tv6'; "
			theUpdCur.execute(theSQL)
			conn.commit()
     theUpdCur.close()
     return()

#dissolve each c<field> into its own dataset
def lpfm_dissolve_cfields():
	mkCur = conn.cursor()	
	for i in range(201,211):
		theSQL = "DROP TABLE if EXISTS " + schema + ".c" + str(i) + ";"
		theSQL = theSQL + "create table " + schema + ".c" + str(i) + " as "
		theSQL = theSQL + "SELECT st_union(geom) as geom, c" + str(i) 
		theSQL = theSQL + " as channel FROM " + schema + "." + finalTB + "_data "
		theSQL = theSQL + "WHERE c" + str(i) + " = 1 group by c" + str(i) + ";"
		theSQL = theSQL + "ALTER TABLE " + schema + ".c" + str(i) + " ADD COLUMN gid SERIAL NOT NULL;"
		mkCur.execute(theSQL)
		conn.commit()
	mkCur.close()
	del mkCur, theSQL, i
	return()     
     
#function for creating the needed final output table w/ full fields
def lpfm_mk_tbl(myTbl):
     theMkCur = conn.cursor()
     theSQL = "DROP TABLE IF EXISTS " + schema + "." + myTbl + ";"
     theSQL = theSQL + "DROP INDEX if exists " + schema + ".lpfm_geom_gist_" + myTbl;
     theMkCur.execute(theSQL)
     theSQL = "CREATE TABLE "  + schema + "." + myTbl
     theSQL = theSQL + " (geom geometry, total numeric, c201 numeric, c202 numeric, "
     theSQL = theSQL + "c203 numeric, c204 numeric, c205 numeric, c206 numeric, "
     theSQL = theSQL + "c207 numeric, c208 numeric, c209 numeric, c210 numeric, "
     theSQL = theSQL + "c211 numeric, c212 numeric, c213 numeric, c214 numeric, "
     theSQL = theSQL + "c215 numeric, c216 numeric, c217 numeric, c218 numeric, "
     theSQL = theSQL + "c219 numeric, c220 numeric, c221 numeric, c222 numeric, "
     theSQL = theSQL + "c223 numeric, c224 numeric, c225 numeric, c226 numeric, "
     theSQL = theSQL + "c227 numeric, c228 numeric, c229 numeric, c230 numeric, "
     theSQL = theSQL + "c231 numeric, c232 numeric, c233 numeric, c234 numeric, "
     theSQL = theSQL + "c235 numeric, c236 numeric, c237 numeric, c238 numeric, "
     theSQL = theSQL + "c239 numeric, c240 numeric, c241 numeric, c242 numeric, "
     theSQL = theSQL + "c243 numeric, c244 numeric, c245 numeric, c246 numeric, "
     theSQL = theSQL + "c247 numeric, c248 numeric, c249 numeric, c250 numeric, "
     theSQL = theSQL + "c251 numeric, c252 numeric, c253 numeric, c254 numeric, "
     theSQL = theSQL + "c255 numeric, c256 numeric, c257 numeric, c258 numeric, "
     theSQL = theSQL + "c259 numeric, c260 numeric, c261 numeric, c262 numeric, "
     theSQL = theSQL + "c263 numeric, c264 numeric, c265 numeric, c266 numeric, "
     theSQL = theSQL + "c267 numeric, c268 numeric, c269 numeric, c270 numeric, "
     theSQL = theSQL + "c271 numeric, c272 numeric, c273 numeric, c274 numeric, "
     theSQL = theSQL + "c275 numeric, c276 numeric, c277 numeric, c278 numeric, "
     theSQL = theSQL + "c279 numeric, c280 numeric, c281 numeric, c282 numeric, "
     theSQL = theSQL + "c283 numeric, c284 numeric, c285 numeric, c286 numeric, "
     theSQL = theSQL + "c287 numeric, c288 numeric, c289 numeric, c290 numeric, "
     theSQL = theSQL + "c291 numeric, c292 numeric, c293 numeric, c294 numeric, "
     theSQL = theSQL + "c295 numeric, c296 numeric, c297 numeric, c298 numeric, "
     theSQL = theSQL + "c299 numeric, c300 numeric, gid serial NOT NULL, "
     theSQL = theSQL + "CONSTRAINT " + myTbl + "_test_pkey PRIMARY KEY (gid), "
     theSQL = theSQL + "CONSTRAINT enforce_dims_geom CHECK (st_ndims(geom) = 2), "
     theSQL = theSQL + "CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 4326) "
     theSQL = theSQL + ") WITH (OIDS=TRUE);"
     theSQL = theSQL + "ALTER TABLE " + schema + "." + myTbl + " OWNER TO postgres;"
     theSQL = theSQL + "CREATE INDEX lpfm_geom_gist_" + myTbl + " ON " + schema + "."
     theSQL = theSQL + myTbl + " USING gist (geom); "
     theMkCur.execute(theSQL)
     conn.commit()
     theMkCur.close()  
     del theMkCur, theSQL, myTbl
     return()


#set up the connection to the database
myConn = "dbname=" + db + " host=" + myHost + " port=" + myPort + " user=" + myUser
conn = psycopg2.connect(myConn)

##import shape
##using the name <finalTB>_data to denote the dataset containing the buffered shapes
##origin of <finalTB>_data is a shapefile
cur = conn.cursor()
cur.execute("DROP TABLE if exists " + schema + "." + finalTB + "_data")
conn.commit()
cur.close
del cur
theSQL = "shp2pgsql -s 4326 -I -W latin1 -g geom " + srcshp + ".shp " +  schema + "."
theSQL = theSQL + finalTB + "_data " +  db + " | psql -p 54321 -h localhost " + db
os.system(theSQL)
##add fields to the imported table to support channel exclusions/total
lpfm_alter_fields(finalTB + "_data")
##initialize fields - this function takes a couple of hours
##print "initializing fields..." 
lpfm_initialize_fields(finalTB + "_data")

#create final table
lpfm_mk_tbl(finalTB)

#dissolve each c<field> into its own table
##print "dissolving ..."
#lpfm_dissolve_cfields()

##channel 201 is a special case, just insert it into final
inCur = conn.cursor()
print "INITIALIZING: working on channel: 201" 
theSQL = "INSERT INTO " + schema + "." + finalTB + " select geom from "
theSQL = theSQL +  schema + ".c201;"
inCur.execute(theSQL)
conn.commit()
inCur.close()
del inCur, theSQL
##call the update fields code
lpfm_calc_exclusions (finalTB, 201)

##loop for each channel
for record in range(202,211):
     	#push the total of all intersecting polygons into a working table        
     	#push the final polygons into working first, then push the single new poly	
	print "working on channel " + str(record) 
	lpfm_mk_tbl("working")
	lpfm_insert_to_working(str(record))           
	#update total
	lpfm_set_total()
lpfm_set_total

print "done intersecting, sending output shape"     
#make an export shape pgsql2shp -f test -h localhost -p 54321 feomike lpfm.c208
os.system("rm test.*")
theStr = "pgsql2shp -f test -h " + myHost + " -p " + myPort + " " + db + " " + schema
theStr = theStr + "." + finalTB
os.system(theStr)
conn.close()
print "local time:", time.asctime(now)

 
 
  

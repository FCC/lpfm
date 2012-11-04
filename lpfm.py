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

#variables
db = "feomike"
schema = "lpfm"
finalTB = "lpfm"
srcshp = "lpfm_test1" #mikenclpfm, lpfm_test(1)

#function for updating the field values
#accept the buffer type and channel
#from these two values, update the fields for the exclusions
#anything w/ a null in the field total, is updated
def lpfm_calc_exclusions (myTbl, myBuff, myChan):
     myChan = int(myChan)
     if myBuff == "cochannel":
          myCalcs = [0]
     if myBuff == "firstadjacent":
          myCalcs = [0,1,-1]
     if myBuff == "secondadjacent":
          myCalcs = [0,1,2,-1,-2]
     if myBuff == "adjacent5354" and myChan < 247:
          myCalcs = [0,1,-1,2,-2,53,54]
     if myBuff == "adjacent5354" and myChan > 252:
          myCalcs = [0,1,-1,2,-2,-53,-54]
     if myBuff == "thirdadjacent":
          myCalcs = [0,1,-1,2,-2]
     if myBuff == "tv6":
          myCalcs = [0]
#     print myChan, myBuff, myCalcs
     for myCalc in myCalcs:
          myField = myChan + myCalc
          if myField > 199 and myField < 301:
               theSQL = "Update " + schema + "." + myTbl + " set c" + str(myField)
               theSQL = theSQL + " = 1 where total is null;"
               theUpdCur = conn.cursor()
               theUpdCur.execute(theSQL)
               conn.commit()
               theUpdCur.close()
               del theUpdCur, theSQL, myField
     del myCalc, myCalcs, myBuff, myChan
     #call the update total function
     lpfm_set_total()
     return()

#function for inserting intersected polys from finalTB to working
def lpfm_insert_to_working_old (myGID):
     #insert the new polygon into working
     theSQL = "INSERT INTO " + schema + ".working select st_buffer(geom,0.0) from " #st_buffer here solves for geometry errors
     theSQL = theSQL +  schema + "." + finalTB + "_data "
     theSQL = theSQL + "where gid = " + myGID + ";"
     theUpdCur = conn.cursor()
     chkCur.execute(theSQL)
     conn.commit()
     #update the attributes on this one
     lpfm_calc_exclusions ("working", record[3], record[4])
     #insert the final polygons into working first;
     theSQL = "INSERT INTO " + schema + ".working SELECT "
     theSQL = theSQL + finalTB + ".geom as geom, total, "
     theSQL = theSQL + "c200, c201, c202, C203, C204, C205, C206, C207, C208, C209, "
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
     theSQL = theSQL + "from " + schema + "." + finalTB + ", " + schema + "." + finalTB
     theSQL = theSQL + "_data where st_intersects(" + finalTB + ".geom, " + finalTB
     theSQL = theSQL + "_data.geom) and " + finalTB + "_data.gid = " + myGID + ";"
     #ensure no sllivers
     #theSQL = "delete from lpfm.working where st_isvalid(geom) = 'f' or geom is null;"
     theUpdCur.execute(theSQL)
     conn.commit()
     theUpdCur.close()     
     del theUpdCur, theSQL, myGID
     return()

#function for inserting intersected polys from finalTB to working
def lpfm_insert_to_working (myGID):
     #insert the new polygon into working
     theSQL = "INSERT INTO " + schema + ".working select st_buffer(geom,0.0) from " #st_buffer here solves for geometry errors
     theSQL = theSQL +  schema + "." + finalTB + "_data "
     theSQL = theSQL + "where gid = " + myGID + ";"
     theUpdCur = conn.cursor()
     chkCur.execute(theSQL)
     conn.commit()
     #update the attributes on this one only
     lpfm_calc_exclusions ("working", record[3], record[4])
     #insert the final polygons into working first;
     theSQL = "INSERT INTO " + schema + ".working SELECT ST_UNION("
     theSQL = theSQL + finalTB + ".geom) as geom, total, "
     theSQL = theSQL + "c200, c201, c202, C203, C204, C205, C206, C207, C208, C209, "
     theSQL = theSQL + "c210, c211, c212, C213, C214, C215, C216, C217, C218, C219, "
     theSQL = theSQL + "c220, c221, c222, C223, C224, C225, C226, C227, C228, C229, "
     theSQL = theSQL + "c230, c231, c232, C233, C234, C235, C236, C237, C238, C239, "
     theSQL = theSQL + "c240, c241, c242, C243, C244, C245, C246, C247, C248, C249, "
     theSQL = theSQL + "c250, c251, c252, C253, C254, C255, C256, C257, C258, C259, "
     theSQL = theSQL + "c260, c261, c262, C263, C264, C265, C266, C267, C268, C269, "
     theSQL = theSQL + "c270, c271, c272, C273, C274, C275, C276, C277, C278, C279, "
     theSQL = theSQL + "c280, c281, c282, C283, C284, C285, C286, C287, C288, C289, "
     theSQL = theSQL + "c290, c291, c292, C293, C294, C295, C296, C297, C298, C299, "
     theSQL = theSQL + "c300, total "
     theSQL = theSQL + "from " + schema + "." + finalTB + ", " + schema + "." + finalTB
     theSQL = theSQL + "_data where st_intersects(" + finalTB + ".geom, " + finalTB
     theSQL = theSQL + "_data.geom) and " + finalTB + "_data.gid = " + myGID 
     theSQL = theSQL + "	GROUP BY total,c200,c201,c202,C203,C204,C205,C206,C207,C208,C209," 
     theSQL = theSQL + "c210, c211, c212, C213, C214, C215, C216, C217, C218, C219, " 
     theSQL = theSQL + "c220, c221, c222, C223, C224, C225, C226, C227, C228, C229, "
     theSQL = theSQL + "c230, c231, c232, C233, C234, C235, C236, C237, C238, C239, "
     theSQL = theSQL + "c240, c241, c242, C243, C244, C245, C246, C247, C248, C249, "
     theSQL = theSQL + "c250, c251, c252, C253, C254, C255, C256, C257, C258, C259, "
     theSQL = theSQL + "c260, c261, c262, C263, C264, C265, C266, C267, C268, C269, "
     theSQL = theSQL + "c270, c271, c272, C273, C274, C275, C276, C277, C278, C279, "
     theSQL = theSQL + "c280, c281, c282, C283, C284, C285, C286, C287, C288, C289, "
     theSQL = theSQL + "c290, c291, c292, C293, C294, C295, C296, C297, C298, C299, c300;"
     theUpdCur.execute(theSQL)
     conn.commit()
     #ensure no sllivers
     theSQL = "delete from lpfm.working where st_area(geom) / st_perimeter(geom) "
     theSQL = theSQL + " < 0.00000000001;"
     theUpdCur.execute(theSQL)
     conn.commit()
     theUpdCur.close()     
     del theUpdCur, theSQL, myGID
     return()



#function for slicing up an individual polygon
def lpfm_slice (myGID):
     #delete from <schema>.<finalTB> the intersecting ones
     theUpdCur = conn.cursor()
     theSQL = "DELETE FROM " + schema + "." + finalTB + " using " + schema + "."
     theSQL = theSQL + finalTB + "_data where st_intersects( " + finalTB + ".geom, "
     theSQL = theSQL + finalTB + "_data.geom) and " + finalTB + "_data.gid = " + myGID
     theUpdCur.execute(theSQL)
     conn.commit()       
     #then insert into <schema>.<finalTB> these ones
     theSQL = "INSERT INTO " + schema + "." + finalTB
     theSQL = theSQL + " SELECT geom FROM ST_Dump(( "
     theSQL = theSQL + "     SELECT ST_Polygonize(the_geom) AS the_geom FROM ( "
     theSQL = theSQL + "          SELECT ST_Union(geom) AS the_geom FROM ( "
     theSQL = theSQL + "SELECT ST_ExteriorRing( (ST_Dump(geom)).geom ) AS geom FROM " + schema + ".working) AS lines " #st_dump here solves for ensuring that slivers are split to two unique polys, rather than one
     theSQL = theSQL + "     ) AS noded_lines "
     theSQL = theSQL + ") ); "
#     print theSQL
     theUpdCur.execute(theSQL)
     conn.commit()
     theUpdCur.close()
     del theUpdCur, theSQL
     return()

def lpfm_transfer_attributes():
     #if the new polygon is is within the old polygon, transfer the attributes
     theUpdCur = conn.cursor()
     for i in range(200,301):
          theSQL = "UPDATE " + schema + "." + finalTB
          theSQL = theSQL + " set c" + str(i) + " = working.c" + str(i)
          theSQL = theSQL + " from " + schema + ".working where ST_CONTAINS(st_buffer(working.geom, 0.000001), " #st_buffer here solves for exact polygons not being w/i; and solves for donut holes
          theSQL = theSQL + finalTB + ".geom) and " + finalTB + ".total is null "
          theSQL = theSQL + " and working.c" + str(i) + " is not null;"
          theUpdCur.execute(theSQL)
          conn.commit()
     theUpdCur.close()
     del theUpdCur, theSQL, i    
     return()
 
#function for updating the total field value
def lpfm_set_total ():
     theSQL = "Update " + schema + "." + finalTB + " set total = "
     theSQL = theSQL + "coalesce(c200,0) + coalesce(c201,0) + coalesce(c202,0) + coalesce(c203,0) + coalesce(c204,0) + coalesce(c205,0) + coalesce(c206,0) + coalesce(c207,0) + coalesce(c208,0) + coalesce(c209,0) + "
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
     return() 

#function for creating the needed final output table w/ full fields
def lpfm_mk_tbl(myTbl):
     theMkCur = conn.cursor()
     theSQL = "DROP TABLE IF EXISTS " + schema + "." + myTbl + ";"
     theSQL = theSQL + "DROP INDEX if exists " + schema + ".lpfm_geom_gist_" + myTbl;
     theMkCur.execute(theSQL)
     theSQL = "CREATE TABLE "  + schema + "." + myTbl
     theSQL = theSQL + " (geom geometry, total numeric, c200 numeric, c201 numeric, c202 numeric, "
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
     theSQL = theSQL + "CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 4236) "
     theSQL = theSQL + ") WITH (OIDS=TRUE);"
     theSQL = theSQL + "ALTER TABLE " + schema + "." + myTbl + " OWNER TO postgres;"
     theSQL = theSQL + "CREATE INDEX lpfm_geom_gist_" + myTbl + " ON " + schema + "."
     theSQL = theSQL + myTbl + " USING gist (geom); "
     theMkCur.execute(theSQL)
     conn.commit()
     theMkCur.close()  
     del theMkCur, theSQL, myTbl
     #     theSQL = theSQL + "CONSTRAINT " + myTbl + "_test_pkey PRIMARY KEY (gid), "
     return()
   
conn = psycopg2.connect("dbname=" + db + " host=localhost port=54321 user=postgres")
# Query the database and obtain data as Python objects
cur = conn.cursor()

#create final table
#os.system("psql -p 54321 -h localhost feomike -c 'DROP TABLE if exists analysis.lpfm'")
lpfm_mk_tbl(finalTB)

#figure out how to trap a variable
#cur.execute("SELECT count(*) FROM analysis.lpfm_nc;")
#theVal = cur.fetchone()[0] #returns a tuple, so you have to parse it w/ var[n]

#import shape
#using the name <finalTB>_data to denote the dataset containing the buffered shapes
#origin of <finalTB>_data is a shapefile
#first we import <finalTB>_data
cur.execute("DROP TABLE if exists " + schema + "." + finalTB + "_data")
conn.commit()
theSQL = "shp2pgsql -s 4236 -I -W latin1 -g geom " + srcshp + ".shp " +  schema + "."
theSQL = theSQL + finalTB + "_data " +  db + " | psql -p 54321 -h localhost " + db
os.system(theSQL )

#loop for each gid
cur.execute("SELECT * FROM " + schema + "." + finalTB + "_data;")
for record in cur:
     #set up a cursor on all records to cycle through one at a time
     theSQL = "select count(" + finalTB + "_data" + ".gid) "
     theSQL = theSQL + "from " + schema + "." + finalTB + "_data, " + schema + "."
     theSQL = theSQL + finalTB + " where st_intersects("
     theSQL = theSQL + finalTB + "_data.geom, " + finalTB + ".geom) and " + finalTB
     theSQL = theSQL + "_data.gid = " + str(record[0]) + ";"
     chkCur = conn.cursor()
     chkCur.execute(theSQL)
     theCnt = chkCur.fetchone()[0]
     #[0] is gid               [3] is buffer_typ     [4] is channel
     print "processing: " + str(record[0]) + ", " + str(record[3]) + ", " + str(record[6])
     #if theSQL returns a count of 0, then there is no intersection,
     #proceed to insert only this one polygon into finalTB
     #this one polygon is where gid = record[0]
     if  theCnt == 0:
#     	print "doesn't intersect anything; " + str(record[4]) + " - " + str(record[6])
     	theSQL = "insert into " + schema + "." + finalTB + " select st_buffer(geom,0) from " #st_buffer here solves for geometry errors
     	theSQL = theSQL +  schema + "." + finalTB + "_data "
     	theSQL = theSQL + "where gid = " + str(record[0]) + ";"
     	chkCur.execute(theSQL)
     	conn.commit()
     	#call the update fields code
     	lpfm_calc_exclusions (finalTB, record[3], record[4])
     #if theSQL returns a count > 0, then there is an intersection,
     #perform the intersection
     #this one polygon is where gid = record[0]  
     if theCnt > 0:
#     	print "intersect anything; " + str(record[4]) + " - " + str(record[6])
     	#push the total of all intersecting polygons into a working table        
     	#push the final polygons into working first, then push the single new poly
     	lpfm_mk_tbl("working")
     	lpfm_insert_to_working(str(record[0]))           
     	#take the working polygons and slice them
     	lpfm_slice(str(record[0]))
     	#transfer attributes from source to the sliced polygons
     	lpfm_transfer_attributes()
     	#update total
     	lpfm_set_total()
     chkCur.close()
     lpfm_set_total
     
cur.close()
conn.close()

 
 
  

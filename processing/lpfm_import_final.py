### ---------------------------------------------------------------------------
###   VERSION 0.1 (for postgis)
### lpfm_import_final.py
### Created on: Novermber 11 2012
### Created by: Michael Byrne
### Federal Communications Commission 
### ---------------------------------------------------------------------------
###the intent of this script is to take the output split shapes after union processing in 
###arcgis, and input them back into postgis for map development

# Import system modules
import sys, string, os

myHost = "localhost"
myPort = "54321"
db = "feomike"
schema = "lpfm"
theShp1 = "lpfm_lt_750.shp"
myTab1 = "lpfm_lt_750"
theShp2 = "lpfm_gt_750.shp"
myTab2 = "lpfm_gt_750"

theCmd = "shp2pgsql -s 4326 -I -W latin1 -g geom " + theShp1 + " " + schema + "." + myTab1 
theCmd = theCmd + " " + db + " | psql -p " + myPort + " -h " + myHost + " " + db
print theCmd
os.system(theCmd)

theCmd = "shp2pgsql -s 4326 -I -W latin1 -g geom " + theShp2 + " " + schema + "." + myTab2 
theCmd = theCmd + " " + db + " | psql -p " + myPort + " -h " + myHost + " " + db
print theCmd
os.system(theCmd)

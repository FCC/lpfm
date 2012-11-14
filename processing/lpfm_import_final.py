### ---------------------------------------------------------------------------
###   VERSION 0.1 (for postgis)
### lpfm_import_final.py
### Created on: Novermber 11 2012
### Created by: Michael Byrne
### Federal Communications Commission 
### ---------------------------------------------------------------------------
###the intent of this script is to take output split shapes after union processing in 
###arcgis, and input them back into postgis for map development

# Import system modules
import sys, string, os

shp2pgsql -s 4326 -I -W latin1 -g geom lpfm_lt_750.shp lpfm.lpfm_lt750 feomike | psql -p 54321 -h localhost feomike
shp2pgsql -s 4326 -I -W latin1 -g geom lpfm_gt_750.shp lpfm.lpfm_gt750 feomike | psql -p 54321 -h localhost feomike

db = "feomike"
myHost = "localhost"
theShp1 = "lpfm_lt_750.shp"
theShp2 = "lpfm_gt_750.shp"

theCmd = "shp2pgsql -s 4326 -I -W latin1 -g geom " + theShp1 + " " + db 
theCmd = theCmd + " | psql -p 54321 -h " + myHost + " " + db
os.system(theCmd)
theCmd = theCmd = "shp2pgsql -s 4326 -I -W latin1 -g geom " + theShp2 + " " + db 
theCmd = theCmd + " | psql -p 54321 -h " + myHost + " " + db

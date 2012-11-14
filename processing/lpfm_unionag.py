### ---------------------------------------------------------------------------
###   VERSION 0.1 (for ArcGIS 10)
### lpfm_unionag.py
### Created on: Novermber 11 2012
### Created by: Michael Byrne
### Federal Communications Commission 
### ---------------------------------------------------------------------------
###the intent of this script is to take input shape files of one per channel 
###and develop a union dataset of all channels

# Import system modules
import sys, string, os, arcpy
from arcpy import env
import time
from datetime import date
from os import remove, close
today = date.today()

#acquire arguments
theFD = "C:/users/analysis/lpfm/processing.gdb"
theDir = "C:/users/analysis/lpfm/shapes/"

#Create Reciept
try:
        #first one through is 201; special case
	for i in range(202,301):
                arcpy.AddMessage("    Processing: " + str(i))
		str1 = theFD + "/c" + str(i-1)
		str2 = theDir + "c" + str(i) + ".shp"
                theList = [str1, str2]
		theOut = theFD + "/c" + str(i)
		if arcpy.Exists(theOut):
                        arcpy.Delete_management(theOut)
                arcpy.Union_analysis(theList, theOut, "NO_FID")

except:
    arcpy.AddMessage(arcpy.GetMessage(0))
    theMsg = "Something bad happened during the process"
    arcpy.AddMessage(theMsg)
    del theMsg


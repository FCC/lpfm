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
	theFC = theDir + "c201.shp"
	arcpy.copy_management(theFC, theFD + "/c201" )
	for i in range(202,204):
		#		#cycle through a range, delete the output if already exists, 
		#		#union the next one
		theList = theFD + "/c" + str(i-1) + ";" + theFD + "/c" + str(i)
		theOut = theFD + "/c" + str(i-1)
		gp.delete_management(theOut)
		arcpy.union_analysis(theList, theOut)

except:
    arcpy.AddMessage(arcpy.GetMessage(0))
    arcpy.AddMessage(arcpy.GetMessage(1))
    arcpy.AddMessage(arcpy.GetMessage(2))
    theMsg = "Something bad happened during the process"
    arcpy.AddMessage(theMsg)
    del theMsg


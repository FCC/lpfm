readme.md
=========

This directory contains the processing steps required to manipulate the source data and process it to the end map product.  this file outlines those steps and the code used to process those steps.

Steps in order are:
- read the source text file into a postgres table; this file contains the tower locations, channel and engineering data required to create exclusion (protection) areas around all FM stations
- [apply the rules](https://github.com/feomike/lpfm/blob/master/processing/lpfm_buffer_code.sql) in the LPFM FCC order (LINK) to the table created in the previous step; creates the buffer table.
- output the buffer table to a shapefile 
- [create separate channel exclusion tables](https://github.com/feomike/lpfm/blob/master/processing/lpfm_setup.py) read in shapefile and apply rules to separate exclusion areas into 100 separate tables representing exclusion areas for each channel
- [run union](https://github.com/feomike/lpfm/blob/master/processing/lpfm_unionag.py) of all 100 channel exclusion datasets one at time 
- [read in exported shape files](https://github.com/feomike/lpfm/blob/master/processing/lpfm_import_final.py) of unioned exclusion tables with columns for total exclusions and opportunities for channels
- [create final table of results](https://github.com/feomike/lpfm/blob/master/processing/lpfm_import_final.py)
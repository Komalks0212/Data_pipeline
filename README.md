# Data Pipeline to load clinical trial data from flat files to database tables

I built a databse that contains schemas, metadata, procedures and tables specifically to store data as per the SDTM data standards. This standard is followed worldwide to store, share, and analyze clinical trial data. 
I also built a data pipeline. that would pick data from a folder (in my laptop) and load that data into PostgreSQL database. This pipeline can then be run anytime some data needs to be loaded into the database by someone who is not tech savvy as well. 
This popeline is built using Python and SQL. 

Part 1 - SQL queries to build schemas, metadata tables and tables that will hold the actual data, as per SDTM standards 

Part 2 - Procedures and tables in database used for the pipeline

Part 3 - Python code for the pipeline

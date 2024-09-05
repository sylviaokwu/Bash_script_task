# ETL Pipeline Project

This project demonstrates a simple ETL (Extract, Transform, Load) pipeline built using Bash scripts for data storage. 


The goal of this task was to implement a full ETL process in Bash, which:

Extracts a CSV file from a remote URL and stores it in a local folder (raw).
Transforms the CSV by renaming one column (Variable_code to variable_code) and selecting only specific columns to save in a Transformed folder.
Loads the transformed CSV into a final directory (Gold) for further use.
The process was broken down into three phases:
## Task 1: ETL Process
### Extract Phase 
The script downloads the file using curl and verifies the download by checking the file’s existence in the raw folder.

### Transform Phase
Using awk, the script processes the CSV to rename a column and filter only the necessary columns, saving the results to the Transformed folder.

### Load Phase
Finally, the transformed CSV file is moved into the Gold folder.

## Task 2: Scheduling with Cron
To automate the ETL process, I used cron to schedule the script at 12am daily. I initially set the cron job to run every minute for testing purposes to ensure that the script executed correctly without errors.


## Task 3: Moving CSV and JSON Files
This task aimed to automate the organization of files. The script identifies CSV and JSON files in a specified directory and moves them to a destination folder.

Using a for-loop, I ensured that both CSV and JSON files were identified and moved efficiently.


## Task 4: Loading Data into PostgreSQL
The objective was to load several CSV files into a PostgreSQL database dynamically, creating the necessary tables based on the CSV file names.

Key steps:
The script  created tables based on the CSV file names. I ensured that the table structure matched the content of the CSV files. Using the PostgreSQL \copy command, I loaded the data from the CSV files into the respective tables. The script also handled error checking to confirm the successful import of data.
This task automated the process of populating a PostgreSQL database with structured data from CSV files, making the database setup efficient and repeatable.


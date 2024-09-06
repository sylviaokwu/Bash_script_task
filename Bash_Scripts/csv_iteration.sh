#!/bin/bash

# Database credentials
DB_NAME="posey"
DB_USER="sylviaokwu" 
DB_PASSWORD="sylvia"  
CSV_DIR="/Users/sylviaokwu/Documents/Scripts/posey_csv" 


# Export the database password for non-interactive usage
export PGPASSWORD=$DB_PASSWORD

# Iterate over each CSV file in the directory and copy it to PostgreSQL
for csv_file in "$CSV_DIR"/*.csv
do
    echo "Processing $csv_file"

    # Extract the table name from the CSV file name (e.g., accounts.csv -> accounts)
    table_name=$(basename "$csv_file" .csv)

    # Create tables according to the specific CSV structure
    case $table_name in
        accounts)
            psql -U $DB_USER -d $DB_NAME -c "
            CREATE TABLE IF NOT EXISTS accounts (
                id INT PRIMARY KEY,
                name VARCHAR(100),
                website VARCHAR(255),
                lat NUMERIC,
                long NUMERIC,
                primary_poc VARCHAR(100),
                sales_rep_id INT
            );"
            ;;

        orders)
            psql -U $DB_USER -d $DB_NAME -c "
            CREATE TABLE IF NOT EXISTS orders (
                id SERIAL PRIMARY KEY,
                account_id INT,
                occurred_at TIMESTAMP,
                standard_qty INT,
                gloss_qty INT,
                poster_qty INT,
                total INT,
                standard_amt_usd NUMERIC,
                gloss_amt_usd NUMERIC,
                poster_amt_usd NUMERIC,
                total_amt_usd NUMERIC
            );"
            ;;

        region)
            psql -U $DB_USER -d $DB_NAME -c "
            CREATE TABLE IF NOT EXISTS region (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100)
            );"
            ;;

        sales_reps)
            psql -U $DB_USER -d $DB_NAME -c "
            CREATE TABLE IF NOT EXISTS sales_reps (
                id INT PRIMARY KEY,
                name VARCHAR(100),
                region_id INT
            );"
            ;;

        web_events)
            psql -U $DB_USER -d $DB_NAME -c "
            CREATE TABLE IF NOT EXISTS web_events (
                id SERIAL PRIMARY KEY,
                account_id INT,
                occurred_at TIMESTAMP,
                channel VARCHAR(100)
            );"
            ;;
    esac

    # Copy the CSV data into the table
    psql -U $DB_USER -d $DB_NAME -c "\copy $table_name FROM '$csv_file' DELIMITER ',' CSV HEADER;"

    if [ $? -eq 0 ]; then
        echo "Successfully loaded $csv_file into $table_name table."
    else
        echo "Failed to load $csv_file."
    fi
done

echo "All files processed."

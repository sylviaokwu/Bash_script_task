#!/bin/bash

# environment variables
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
RAW_DIR="raw"
TRANSFORMED_DIR="Transformed"
GOLD_DIR="Gold"
RAW_FILE_NAME="finance_data.csv"
TRANSFORMED_FILE_NAME="2023_year_finance.csv"

# Function to print a message
function print_message {
    echo "$1"
}

# Extract Phase: Download the CSV file and save it into the raw folder
print_message "Starting the Extract phase..."

mkdir -p $RAW_DIR # Create the raw directory 

curl -o "$RAW_DIR/$RAW_FILE_NAME" $CSV_URL # Download the CSV file into the raw directory

# Confirm the file has been saved in the raw folder
if [ -f "$RAW_DIR/$RAW_FILE_NAME" ]; then
    print_message "File successfully downloaded to $RAW_DIR/$RAW_FILE_NAME."
else
    echo "Error: File not downloaded. Exiting."
    exit 1
fi

# Transform Phase
print_message "Starting the Transform phase..."

mkdir -p $TRANSFORMED_DIR # Create the Transformed directory 

# Performing the transformation
awk -F, '
BEGIN {OFS=","}
NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i == "Variable_code") $i = "variable_code"
        header[i] = $i
    }
    print header[1], header[2], header[3], header[4]
}
NR>1 {print $1, $2, $3, $4}
' "$RAW_DIR/$RAW_FILE_NAME" > "$TRANSFORMED_DIR/$TRANSFORMED_FILE_NAME"

# Confirm the transformed file has been saved
if [ -f "$TRANSFORMED_DIR/$TRANSFORMED_FILE_NAME" ]; then
    print_message "Transformed file saved to $TRANSFORMED_DIR/$TRANSFORMED_FILE_NAME."
else
    echo "Error: Transformed file not created. Exiting."
    exit 1
fi

# Load Phase: Moving the transformed data to the Gold directory
print_message "Starting the Load phase..."

mkdir -p $GOLD_DIR # Create the Gold directory 

# Moving the transformed file to the Gold directory
mv "$TRANSFORMED_DIR/$TRANSFORMED_FILE_NAME" "$GOLD_DIR/"

# Confirm the file has been moved to the Gold folder
if [ -f "$GOLD_DIR/$TRANSFORMED_FILE_NAME" ]; then
    print_message "File successfully moved to $GOLD_DIR/$TRANSFORMED_FILE_NAME."
else
    echo "Error: File not moved to Gold folder. Exiting."
    exit 1
fi

print_message "ETL process completed successfully."

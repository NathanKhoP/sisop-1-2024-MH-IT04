#!/bin/bash

# Define CSV URL
CSV_URL='https://drive.usercontent.google.com/u/0/uc?id=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0&export=download'

# Download the CSV file from Google Drive
echo "=== Downloading CSV from Google Drive ==="
curl -L -o sandbox.csv "$CSV_URL"

# Check if the download was successful
echo "=== Checking download status ==="
if [ $? -ne 0 ]; then
  echo "=== Failed to download the CSV file from $CSV_URL. Exiting. ==="
  exit 1
fi
echo "=== Download successful ==="
printf "\n"

# Customer with the Most Sales
echo "=== Customer with the Most Sales ==="
awk -F, '{print $17, $6}' sandbox.csv | sort -nr | head -n 1 | awk '{print $2, $3}'
echo -e "\n"

# Customer Segment with the Least Profit
echo "=== Customer Segment with the Least Profit ==="
awk -F, '{print $20, $7}' sandbox.csv | sort | head -n 1 | awk '{print $2, $3}'
echo -e "\n"

# Categories with the Most Total Profit
echo "=== Categories with Most Total Profit ==="
awk -F, '{profit[$14] += $20} END {for (category in profit) print profit[category], category}' sandbox.csv | sort -nr | head -n 3
echo -e "\n"

# Get Quantity and Order Date for Customer with "Adriaens"
echo "=== Getting Order Date and Quantity for Customer Named 'Adriaens' ==="
awk -F, '$6 ~ /Adriaens/ {print "Order Date: ", $2}' sandbox.csv
awk -F, '$6 ~ /Adriaens/ {print "Quantity: "$18}' sandbox.csv
echo -e "\n"

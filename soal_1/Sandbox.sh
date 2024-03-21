#!/bin/bash

# Download the CSV file from Google Drive
echo "=== Downloading CSV from Google Drive ==="
curl -L -o sandbox.csv 'https://drive.usercontent.google.com/u/0/uc?id=1cC6MYBI3wRwDgqlFQE1OQUN83JAreId0&export=download'

# Check if the download was successful
echo "=== Checking download status ==="
if [ $? -ne 0 ]; then
  echo "=== Failed to download the CSV file. Exiting. ==="
  exit 1
fi
echo "=== Download succesful ==="
printf "\n"
# Extract specific columns, sort numerically, and print the maximum value
echo "Costumer with the most sales: "
awk -F, '{print $17, $6}' sandbox.csv | sort -nr | head -n 1

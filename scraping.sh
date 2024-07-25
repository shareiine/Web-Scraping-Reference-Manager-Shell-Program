#!/bin/bash

echo "WEB SCRAPING"
echo "Enter website link to scrape"
read url

# create csv (title, date, creator?, and link)
echo "Headline, Creator, Date, Link" > trial.csv

# get HTML elements of input URL
content=$(curl -s "$url")

# extract json elements  
headline=$(echo "$content" | grep -Po '"headline": "\K[^"]*')
date=$(echo "$content" | grep -Po '"datePublished": "\K[^"]*')
creator=$(echo "$content" | grep -Po '"name": "\K[^"]*')

# Convert name to an array since there's a lot of "name" used
toArr=$'\n' read -r -d '' -a arr <<< "$creator"


# save to csv
echo "\"$headline\",\"${arr[0]}\",\"$date\",\"$url\"" >> trial.csv

#!/bin/bash

echo "WEB SCRAPING"

echo "Enter Citation List Name"
read list

if [ ! -f "$list.csv" ]; then
	# create csv (title, date, creator?, and link)
	echo "Headline, Creator, Date, Link" > "$list.csv"
fi





# GFG function
GFG_cite(){
	
	# get HTML elements of input URL
	content=$(curl -s "$url")
	# extract json elements  
	headline=$(echo "$content" | grep -Po '"headline": "\K[^"]*')
	date=$(echo "$content" | grep -Po '"datePublished": "\K[^"]*')
	creator=$(echo "$content" | grep -Po '"name": "\K[^"]*')
	# Convert name to an array since there's a lot of "name" used
	toArr=$'\n' read -r -d '' -a arr <<< "$creator"

	# save to csv
	echo "\"$headline\",\"${arr[0]}\",\"$date\",\"$url\"" >> "$list.csv"
	
}


# loop to create citation list
while true; do
	
	echo "Enter website link to scrape"
	read url
	
	if echo "$url" | grep -q "geeksforgeeks"; then
		# GFG function call
		GFG_cite
	else
		echo "Invalid!"
	fi
	

	# check if user wants to continue
	echo "Would you like to add more citations? Type 'Y' if yes."
	read ans

	if [ "$ans" != "Y" ]; then
		break
	fi

done


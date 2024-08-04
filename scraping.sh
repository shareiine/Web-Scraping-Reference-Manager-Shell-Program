#!/bin/bash

echo "WEB SCRAPING"

# ask for the citation list name
echo "Enter Citation List Name"
read list


# check if csv file exists; if it doesn't exist, create one and place header row
if [ ! -f "$list.csv" ]; then
	# create csv (title, creator, date, and link)
	echo "Headline, Creator, Date, Link" > "$list.csv"
fi

# Function definitions for the websites

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

TP_cite(){
	# extract elements
	TP_content=$(curl -s "$url")

	# extract contents of title tag
	TP_title=$(echo "$TP_content" | grep -Po '(?<=<title>)(.*)(?=</title>)')
	# extract "title" from a tag to get organization name
	TP_creator=$(echo "$TP_content" | grep -Po '(?<=<a href="https://www.tutorialspoint.com" title=").*(?=">)')
	# save to csv file, n.d. stands for no date since there's no date publushed
	echo "\"$TP_title\",\"$TP_creator\",\"n.d.\",\"$url\"" >> "$list.csv"

}


# loop to create citation list
while true; do
	
	echo "Enter website link to scrape"
	read url
	
	if echo "$url" | grep -q "geeksforgeeks"; then
		# GFG function call
		GFG_cite
	elif echo "$url" | grep -q "tutorialspoint"; then
		# TP function call
		TP_cite
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


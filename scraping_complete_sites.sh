#!/bin/bash

source is_scrapable.sh
echo "WEB SCRAPING"

# ask for the citation list name
echo "Enter Citation List Name"
read list


# check if csv file exists; if it doesn't exist, create one and place header row
if [ ! -f "$list.csv" ]; then
	# create csv (title, author, date, website name, and link)
	echo "Title, Author, Date, Website Name, Link" > "$list.csv"
fi

# Function definitions for the websites

# GFG function
GFG_cite(){
	
	# get HTML elements of input URL
	GFG_content=$(curl -s "$url")
	# extract json elements  
	headline=$(echo "$GFG_content" | grep -Po '"headline": "\K[^"]*')
	date=$(echo "$GFG_content" | grep -Po '"datePublished": "\K[^"]*')
	date=${date:0:10} 
	creator=$(echo "$GFG_content" | grep -Po '"name": "\K[^"]*')
	# Convert name to an array since there's a lot of "name" used
	toArr=$'\n' read -r -d '' -a arr <<< "$creator"

	# save to csv
	echo "\"$headline\",\"${arr[0]}\",\"$date\",\"GeeksforGeeks\",\"$url\"" >> "$list.csv"
	
}

TP_cite(){
	# extract elements
	TP_content=$(curl -s "$url")

	# extract contents of title tag
	TP_title=$(echo "$TP_content" | grep -Po '(?<=<title>)(.*)(?=</title>)')

	# Tutorials Point pages have no page authors, that field is filled with a NULL value
	# save to csv file, n.d. stands for no date since there's no date publushed
	echo "\"$TP_title\",\"NULL\",\"n.d.\",\"Tutorials Point\",\"$url\"" >> "$list.csv"

}

W3S_cite(){
	# extract elements
	W3S_content=$(curl -s "$url")

	# extract contents of title tag
	W3S_title=$(echo "$W3S_content" | grep -Po '(?<=<title>)(.*)(?=</title>)')

	# W3Schools pages have no page authors, that field is filled with a NULL value
	# save to csv file, n.d. stands for no date since there's no date publushed
	echo "\"$W3S_title\",\"NULL\",\"n.d.\",\"W3Schools\",\"$url\"" >> "$list.csv"
}

BYJ_cite(){
	# extract elements
	BYJ_content=$(curl -s "$url")

	# extract contents of title tag
	BYJ_title=$(echo "$BYJ_content" | grep -Po '(?<=<title>)(.*)(?=</title>)')

	# Byju's pages have no page authors, that field is filled with a NULL value

	BYJ_date=$(echo "$BYJ_content" | grep -Po '"datePublished": "\K[^"]*')
	BYJ_date=${BYJ_date:0:10} 

	echo "\"$BYJ_title\",\"NULL\",\"$BYJ_date\",\"BYJU'S\",\"$url\"" >> "$list.csv"
}

# loop to create citation list
while true; do
	
	echo "Enter website link to scrape. Type in 'X' to capture webpage in Firefox."
	read url

	# If this portion of the code is not working install dependency by typing in 
		# sudo apt install xdotool
	# in your terminal
	# The Firefox window must not be minimized
	# If errors are occuring, restart Firefox and restore your session in through the upper right options button > History
	# Should errors continue to occur, remove the if statement below

	if [ "$url" = "X" ]; then
		window_id=$(xdotool search --onlyvisible --class "firefox")
		xdotool key --window $window_id --delay 20 --clearmodifiers ctrl+l ctrl+c Escape
		url=$( xsel -ob )
	fi

	echo "Captured URL: $url";

	# Check if the website is accessible
	if ! check_url "$url"; then
		continue
	fi

	# Check for Captcha
	if ! check_captcha "$url"; then
		continue
	fi

	# Check robots.txt
	check_robots_txt "$url"
	
	if echo "$url" | grep -q "geeksforgeeks"; then
		# GFG function call
		GFG_cite
	elif echo "$url" | grep -q "tutorialspoint"; then
		# TP function call
		TP_cite
	elif echo "$url" | grep -q "w3schools"; then
		# W3S function call
		W3S_cite
	elif echo "$url" | grep -q "byjus"; then
		# BYJ function call
		BYJ_cite
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

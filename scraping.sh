#!/bin/bash

echo "WEB SCRAPING"

# Function to check if URL is valid
check_url() {
    url=$1
    http_status=$(curl -o /dev/null -s -w "%{http_code}\n" "$url")
    if [ "$http_status" -eq 200 ]; then
        echo "URL is valid."
        return 0
    else
        echo "URL is not accessible. HTTP status: $http_status"
        return 1
    fi
}

# Function to check for CAPTCHA on the website
check_captcha() {
    url=$1
    content=$(curl -s "$url")
    if echo "$content" | grep -qE '(class="h-captcha"|class="recaptcha"|<div id="captcha")'; then
        echo "Website has CAPTCHA protection."
        return 1
    fi
    echo "No CAPTCHA detected."
    return 0
}

# Function to check robots.txt file for scraping restrictions
check_robots_txt() {
    url=$1
    robots_url="${url%/}/robots.txt"
    
    echo "Checking robots.txt at $robots_url ..."
    
    if curl --silent --head --fail "$robots_url" > /dev/null; then
        disallows=$(curl --silent "$robots_url" | grep -i "Disallow:")
        
        if [ -n "$disallows" ]; then
            echo "robots.txt found with the following disallow rules:"
            echo "$disallows"
            echo "Scraping might be restricted by these rules."
        else
            echo "robots.txt found but no disallow rules for scraping."
        fi
    else
        echo "No robots.txt file found. Scraping is allowed."
    fi
}

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
	TP_creator=$(echo "$TP_content" | grep -Po '(?<=<a href="https://www.tutorialspoint.com
" title=").*(?=">)')
	# save to csv file, n.d. stands for no date since there's no date publushed
	echo "\"$TP_title\",\"$TP_creator\",\"n.d.\",\"$url\"" >> "$list.csv"

}


# loop to create citation list
while true; do
	
	echo "Enter website link to scrape"
	read url

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
	else
		echo "Please enter a website from one of the following: GeeksforGeeks, Tutorialspoint, W3C, or BYJU'S."
	fi
	

	# check if user wants to continue
	echo "Would you like to add more citations? Type 'Y' if yes."
	read ans
	
	
	if [ "$ans" != "Y" ]; then
		break
	fi

done

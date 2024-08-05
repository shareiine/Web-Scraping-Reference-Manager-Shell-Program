#!/bin/bash

# Function to check if URL is valid
check_url() {
    url=$1
    http_status=$(curl -o /dev/null -s -w "%{http_code}\n" "$url")
    if [ "$http_status" -eq 200 ]; then
        # Extract the domain name
    	domain=$(echo "$url" | awk -F/ '{print $3}')
    	case "$domain" in "www.geeksforgeeks.org"|"geeksforgeeks.org"|"www.tutorialspoint.com"|"tutorialspoint.com"|"www.w3schools.com"|"w3schools.com"|"www.byjus.com"|"byjus.com")	
				echo "Valid URL."
				return 0
				;;
    	    *)
    	    	echo "Valid URL, but does not match the available domains."
    	    	return 1
				;;
    	esac
    else
    	echo "URL not accessible. Status Code: $http_status"
    	return 1
    fi
}

# Function to check robots.txt file for scraping restrictions
check_robots_txt() {
    url=$1
    # robots.txt = standardised file to indicate which parts of a website are allowed for scraping
    robots_url="${url%/}/robots.txt"
    
    echo "Checking robots.txt at $robots_url ..."
    
    if curl --silent --fail "$robots_url" > /dev/null; then
        disallows=$(curl --silent "$robots_url" | grep -i "Disallow:")
        
        if [ -n "$disallows" ]; then
            echo "robots.txt found with the following disallow rules:"
            echo "$disallows"
            echo "Scraping may be restricted."
        else
            echo "robots.txt found but no disallow rules for scraping."
        fi
    else
        echo "No robots.txt file found. Scraping is allowed."
    fi
}

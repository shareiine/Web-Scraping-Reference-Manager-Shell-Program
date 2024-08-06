#!/bin/bash
# *with author* Author last name, First name. (Date). Title of Article. Website Name. URL.
# *without author* Title of Article. (Date). Website Name. URL.
# Special Note: No bold, underline, or italic features in text editor so title cannot be italicized.

process_txt() {
    txt_file="$1"
    apa_file="$2"

    # Create or clear the APA file
    > "$apa_file"

    # Read the text file and process each line
    while IFS='|' read -r title author date website link; do
        # Skip header line
        if [ "$title" == "Title" ]; then
             continue
	fi
	
        # NULL or no human name author
        if [ "$author" == "NULL" ] || [ "$author" == "$website" ] || [ "$author" == "0" ]; then
            author=""
        fi

        #date format
        if [ "$date" != "n.d." ]; then
            formatted_date=$(date -d  "$date" '+%Y, %B %-d')
        else
            formatted_date="n.d."
        fi
        
        # Format APA citation
        if [ -z "$author" ]; then
       	    citation="$title. ($formatted_date). $website. $link."
        else
            citation="$author. ($formatted_date). $title. $website. $link."
        fi

        echo "$citation" >> "$apa_file"
    done < "$txt_file"
}

# Function to sort the APA file alphabetically
sort_apa_file() {
    local apa_file="$1"
    sort -t '.' -k1,1 "$apa_file" > "${apa_file}.sorted"
    mv "${apa_file}.sorted" "$apa_file"
}

echo "Enter the text file name (without extension):"
read base_name

txt_file="${base_name}.txt"
apa_file="${base_name}_apa.txt"

# Check if txt file exists
if [ ! -f "$txt_file" ]; then
    echo "File $txt_file does not exist."
    exit 1
fi

process_txt "$txt_file" "$apa_file"
sort_apa_file "$apa_file"

echo "APA citations have been saved and sorted in $apa_file."

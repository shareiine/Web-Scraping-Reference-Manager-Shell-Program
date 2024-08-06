#!/bin/bash
# *with author* [] First name initial last name. Title of Article. Website Name. URL. [accessed date]
# *without author* [] "Title of Article", Website Name. URL.
# Special Note: No bold, underline, or italic features in text editor so title cannot be italicized.

process_txt() {
    txt_file="$1"
    ieee_file="$2"

    # Create or clear the IEEE file
    > "$ieee_file"

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

        #accessed date format
	accessed_date=$(date '+%B%e, %Y')
        
        # Format IEEE citation
        if [ -z "$author" ]; then
       	    citation="[] \"$title,\" $website. $link [Accessed on $accessed_date]."
    	else
            citation="[] $author, \"$title,\" $website. $link [Accessed on $accessed_date]."
        fi

        echo "$citation" >> "$ieee_file"
    done < "$txt_file"
}

# Function to sort the IEEE file alphabetically
sort_ieee_file() {
    local ieee_file="$1"
    sort -t '.' -k1,1 "$ieee_file" > "${ieee_file}.sorted"
    mv "${ieee_file}.sorted" "$ieee_file"
}

echo "Enter the text file name (without extension):"
read base_name

txt_file="${base_name}.txt"
ieee_file="${base_name}_ieee.txt"

# Check if txt file exists
if [ ! -f "$txt_file" ]; then
    echo "File $txt_file does not exist."
    exit 1
fi

process_txt "$txt_file" "$ieee_file"
sort_ieee_file "$ieee_file"

echo "IEEE citations have been saved and sorted in $ieee_file."


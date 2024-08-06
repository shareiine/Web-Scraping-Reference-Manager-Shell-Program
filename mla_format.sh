#!/bin/bash
# Author last name, First name. “Title of Article.” Website Name, Day Month Year, URL.

process_txt() {
    txt_file="$1"
    mla_file="$2"

    # Create or clear the MLA file
    > "$mla_file"

    # Read the text file and process each line
    while IFS='|' read -r title author date website link; do
        # Skip header line
        if [ "$title" == "Title" ]; then
            continue
        fi

        # NULL and n.d. fields
        if [ "$author" == "NULL" ]; then
            author=""
        fi
        if [ "$date" == "n.d." ]; then
            date=""
        fi

        # Format MLA citation
        if [ -z "$author" ]; then
            if [ -z "$date" ]; then
                citation="\"$title\". $website, $link."
            else
                citation="\"$title\". $website, $date, $link."
            fi
        else
            if [ -z "$date" ]; then
                citation="$author. \"$title\". $website, $link."
            else
                citation="$author. \"$title\". $website, $date, $link."
            fi
        fi

        echo "$citation" >> "$mla_file"
    done < "$txt_file"
}

# Function to sort the MLA file alphabetically
sort_mla_file() {
    local mla_file="$1"
    sort -t '.' -k1,1 "$mla_file" > "${mla_file}.sorted"
    mv "${mla_file}.sorted" "$mla_file"
}

echo "Enter the text file name (without extension):"
read base_name

txt_file="${base_name}.txt"
mla_file="${base_name}_mla.txt"

# Check if txt file exists
if [ ! -f "$txt_file" ]; then
    echo "File $txt_file does not exist."
    exit 1
fi

process_txt "$txt_file" "$mla_file"
sort_mla_file "$mla_file"

echo "MLA citations have been saved and sorted in $mla_file."
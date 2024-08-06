#!/bin/bash

while true; do
    clear

    echo '
   _______       _______
  /       \     /       \
 |         |   |         |
 |         |   |         |
 |         |   |         |
  \____    |    \____    |
       |   |         |   |
      /   /         /   /
     /   /         /   /
 ___/   /      ___/   /
|______/      |______/

    Welcome to WebCite
   '

    echo "========= WebCite Main Menu ========="
    echo "| 1. Citation List Maker            |"
    echo "|-----------------------------------|"
    echo "| 2. Generate APA Citations         |"
    echo "|-----------------------------------|"
    echo "| 3. Generate MLA Citations         |"
    echo "|-----------------------------------|"
    echo "| 4. Generate IEEE Citations        |"
    echo "|-----------------------------------|"
    echo "| 5. Exit                           |"
    echo "====================================="
    echo -n "Enter your choice (1-5): "
    read choice

    case $choice in
        1)  bash scraping_complete_sites.sh
       	    ;;
            
        2)
            bash apa_format.sh
            ;;
        3)
            bash mla_format.sh
            ;;
        4)
            bash ieee_format.sh
            ;;
	5) 
	    echo "Exiting the program. Thank you for using WebCite!"
            exit 0
            ;;
        *)
            echo "Invalid choice. Please select a number from 1 to 5."
            ;;
    esac

    echo
    echo "Function executed."
    read -p "Press Enter to return to the main menu..."
done

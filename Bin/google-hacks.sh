#!/bin/bash 

# Original idea by sebb at Archlinux: http://aur.archlinux.org/packages.php?ID=15978
# Script improved by Emmanuele Massimi <finferflu AT gmail DOT com>

# Type -h as argument to the script to get some help about usage.

#BROWSER="elinks"
BROWSER="w3m"

NONE="\E[0m"
GREEN="\E[1;32m"
BLUE="\E[1;34m"
RED="\E[1;31m"
WHITE="\E[1;37m"

function search_audio {
	echo -e "\n   ${GREEN}Enter artist or album name:"
	echo -n -e "  ${BLUE}> ${NONE} "
	read keyword

	if [ "$keyword" == "" ]; then main_routine; fi
	$BROWSER "http://www.google.com/search?hl=en&q=-inurl%3A%28htm%7Chtml%7Cphp%29+intitle%3A%22index+of%22+%2B%22last+modified%22+%2B%22parent+directory%22+%2Bdescription+%2Bsize+%2B%28.mp3%7C.wma%7C.ogg%29+%22$keyword%22"
}

function search_ebooks {
	echo -e "\n   ${GREEN}Enter ebook or author name:"
	echo -n -e "  ${BLUE}> ${NONE} "
	read keyword
	if [ "$keyword" == "" ]; then main_routine; fi
	$BROWSER "http://www.google.com/search?hl=en&q=-inurl%3A%28htm%7Chtml%7Cphp%29+intitle%3A%22index+of%22+%2B%22last+modified%22+%2B%22parent+directory%22+%2Bdescription+%2Bsize+%28.pdf%7C.doc%7C.rtf%7C.chm%29+%22$keyword%22"
}

function search_videos {
	echo -e "\n    ${GREEN}Enter movie name:"
	echo -n -e "   ${BLUE}> ${NONE}"
	read keyword
	if [ "$keyword" == "" ]; then main_routine; fi
	$BROWSER "http://www.google.com/search?hl=en&q=-inurl%3A%28htm%7Chtml%7Cphp%29+intitle%3A%22index+of%22+%2B%22last+modified%22+%2B%22parent+directory%22+%2Bdescription+%2Bsize+%2B%28.mpg%7C.avi%7C.wmv%7C.divx%7C.flv%29+%22$keyword%22"
}

function search_torrents {
	echo -e "\n    ${GREEN}Enter torrent name:"
	echo -n -e "    ${BLUE}> ${NONE}"
	read keyword
	if [ "$keyword" == "" ]; then main_routine; fi
	$BROWSER "http://www.google.com/search?q=$keyword&btnG=Search&q=filetype%3Atorrent"
}

function main_routine {

clear

while true; do
echo -e "  ${BLUE}What do you want to search for?"
echo -e "  =====================================${NONE}" 

echo -e "${GREEN}  1) audio\n  2) ebooks\n  3) videos\n  4) torrents\n"
echo -n -e "  ${BLUE}>${NONE} "
read type

case $type in
	1)  search_audio ;;
	2)  search_ebooks ;;
	3)  search_videos ;;
	4)  search_torrents ;;
	"") exit ;;
	*) echo -e "${RED}Please enter a valid number${NONE}" ;;
esac
echo ""
done 
}

NO_ARGS=0

if [ $# -eq "$NO_ARGS" ]
then
	main_routine
fi
while getopts ":h :b:" option
do
	case $option in
		h) echo -e "\nThis is a script to search for specific file types on Google.\nAt the prompt type the number corresponding to the file type you wish to search for. In the next screen type in your keywords, or press ${WHITE}ENTER${NONE} to go back to the main screen. Pressing ${WHITE}ENTER${NONE} at the main screen exits the program." 
		echo -e "\nUsage: `basename $0` [arguments]\n\nArguments:\n   -h\t\t   Show help text\n   -b <browser>\t   Set browser to <browser> for current session\n\n
Notice that if the script is invoked without specifying the browser, the default will be ${WHITE}w3m${NONE}.\n" ;;

		b) BROWSER=$2; main_routine  ;;
		*) echo -e "\nUsage: `basename $0` [arguments]\n\nArguments:\n   -h\t\t   Show help text\n   -b <browser>\t   Set browser to <browser> for current session\n" ;;

	esac
done


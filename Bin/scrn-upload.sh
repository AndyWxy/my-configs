#!/bin/sh

# (c) Corsair <chris.corsair@gmail.com>, GPLv3

User=username
Pass=passwd

help()
{
    echo 'An uploader for ScrnShots.com.'
    echo 
    echo 'Usage: '$0' [OPTION]... [FILE]...'
    echo 'Upload FILEs to ScrnShots.com.'
    echo 
    echo 'OPTIONs:'
    echo '  -d, --description=DESC  set DESC as description'
    echo '  -f, --format=FMT        set image format to FMT.  eg.: png, jpeg'
    echo '  -t, --tag=TAGS          set tags TAGS, space seperated'
    echo '  -s, --srcurl=URL        set sorce url to URL'
    echo '  -h, --help              display this help and exit'
    return 0
}
    
TEMP=$(getopt --longoptions tag:,description:,srcurl:,format:,help \
    --name "Scrn Uploader" --options t:d:s:f:h \
    -- "$@")

# echo ${TEMP}

if [ $? != 0 ]; then echo "Parameters error..." >&2; exit 1; fi

eval set -- "$TEMP"

FMT=png

while true ; do
    case "$1" in
		-t|--tag) TAGS=$2; shift 2;;
		-d|--description) TITLE=$2; shift 2;;
        -s|--srcurl) SRC=$2; shift 2;;
        -f|--format) FMT=$2; shift 2;;
        -h|--help) help; exit 0;;
		--) shift ; break ;;
		*) echo "WTF??" ; exit 1 ;;
	esac
done

for arg; do
    echo -n "Uploading ${arg}... "
    curl http://www.scrnshots.com/screenshots.xml -H 'Accept: application/xml' \
        -F "screenshot[uploaded_data]=@${arg};type=image/$FMT" \
        -F "screenshot[description]=${TITLE}" \
        -F "screenshot[tag_list]=${TAGS}" \
        -u "${User}:${Pass}" --basic 2> /dev/null | grep "<screenshot>" >& /dev/null
    if [ $? != 0 ]; then
        echo "failed."
    else
        echo "done."
    fi
done    

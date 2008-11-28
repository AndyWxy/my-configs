#!/bin/sh
### Monitor free disk space
# Send an email to $ADMIN, if the free percentage of space is >= $ALERT

#
# Static Config Variables
#
ADMIN="abc@abc.com"       # email to recieve alerts
ALERT=20                        # free space percentage to trigger an alert

#
# Static Binary Paths
#
DF='/bin/df'
GREP='/bin/grep'
AWK='/bin/awk'
CUT='/bin/cut'
MAIL='/usr/bin/mail'
HOSTNAME='/bin/hostname'
DATE='/bin/date'

#
# Static System Variables
#
THIS_HOST=`${HOSTNAME}`

#
# Check CLI Options
#
VERBOSE=false
for ARG in "$@" ; do
        case $ARG in
        "-v")
                VERBOSE=true
                ;;
        esac
done

[ $VERBOSE = true ] && echo "Checking free disk space on ${THIS_HOST}"
[ $VERBOSE = true ] && echo "Threshold for warning is ${ALERT}%"
[ $VERBOSE = true ] && echo "------------------------------------------------------------------"

# Dynamic Variables
DATE_STR=`${DATE} "+%d-%B-%y @ %H%Mhrs"`

# Call df to find the used percentages. Grep for only local disks (not remote mounts like nfs or smb)
# Pipe the output to awk to get the needed columns, then start a while loop to process each line.
$DF -HPl | $GREP -E "^/dev/" | $AWK '{ print $5 " " $6 " " $1 }' | while read OUTPUT ; do
    USED_PCENT=$(echo ${OUTPUT} | $AWK '{ print $1}' | $CUT -d'%' -f1  )    # Used space as a percentage
    PARTITION=$(echo ${OUTPUT} | $AWK '{ print $2 }' )                      # Mount Point (eg, /home)
    DEVICE=$(echo ${OUTPUT} | $AWK '{ print $3 }' )                         # Device (eg, /dev/sda1 or LABEL or UUID)
    if [ $VERBOSE = true ] ; then
        echo -e "Checking device ${DEVICE} which is mounted to ${PARTITION} \t${USED_PCENT}% used"
    fi
    if [ ${USED_PCENT} -ge $ALERT ]; then
        if [ $VERBOSE = true ] ; then
            echo "ALERT: ${PARTITION} (${DEVICE}) is ${USED_PCENT}% full on ${THIS_HOST} (${DATE_STR})"
        else
            echo "ALERT: ${PARTITION} (${DEVICE}) is ${USED_PCENT}% full on ${THIS_HOST} (${DATE_STR})" |
            $MAIL -s "Sir, some of the partitions on your Arch box has been eaten too much!" $ADMIN
        fi
    fi
done

exit 0

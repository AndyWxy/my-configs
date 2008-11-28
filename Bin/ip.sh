#!/bin/sh
#
USER=
PASSWD=
DDNS=

lynx -mime_header -auth=$USER:$PASSWD "http://www.3322.org/dyndns/update?system=dyndns&hostname=$DDNS"

#!/bin/bash
/bin/echo "[======= Removed info | `date +%F` =======]" >> /home/andywxy/pkg-info/removed-recent
/bin/cat /var/log/pacman.log | /bin/grep `date +%F` | /bin/grep removed >> /home/andywxy/pkg-info/removed-recent

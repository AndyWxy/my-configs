#!/bin/bash
/bin/echo "<====== Upgraded info | `date +%F` =======>" >> /home/andywxy/pkg-info/upgraded-recent
/bin/cat /var/log/pacman.log | /bin/grep `date +%F` | /bin/grep upgraded >> /home/andywxy/pkg-info/upgraded-recent

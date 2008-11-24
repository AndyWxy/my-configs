#!/bin/bash
/bin/echo "[======= Installed info | `date +%F` =======]" >> /home/andywxy/pkg-info/installed-recent
/bin/cat /var/log/pacman.log | /bin/grep `date +%F` | /bin/grep installed >> /home/andywxy/pkg-info/installed-recent

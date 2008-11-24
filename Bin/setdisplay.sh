#!/bin/sh

case "$1" in
    solo)
        xrandr --output VGA --off --output LVDS --mode 1024x768
        ;;
    beamer)
        xrandr --output VGA --mode 1680x1050 --same-as LVDS --output LVDS --mode 1024x768
        ;;
    dual)
        xrandr --output VGA --mode 1680x1050 --pos 0x0 --right-of LVDS --output LVDS --mode 1024x768 --left-of VGA
        ;;
    *)
        echo "Usage ./setdisplay.sh solo|beamer|dual"
        exit 1
        ;;
esac

exit 0

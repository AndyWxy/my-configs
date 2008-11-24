#普通命令提示符，在控制台下可以正常显示，如需使用取消注释，并把底部有关提示符的语句注释掉
##RPROMPT='%/'
#PROMPT='%{[36m%}%n%{[35m%}@%{[34m%}%M %{[33m%}%D %T  %{[32m%}%/ 
#%{[31m%}>>%{[m%}'
# PS1 and PS2
 export PS1="$(print '[%{\e[1;34m%}%n%{\e[0m%}'):$(print '%{\e[0;34m%}%~%{\e[0m%}')]$(print '%{\e[1;34m%}$%{\e[0m%}') "
 export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"
 export PATH=$PATH:~/bin


#关于历史纪录的配置
# number of lines kept in history
export HISTSIZE=10000
# # number of lines saved in the history after logout
export SAVEHIST=10000
# # location of history
export HISTFILE=~/.zhistory
# # append command to history file once executed
setopt INC_APPEND_HISTORY

#Disable core dumps
limit coredumpsize 0

#Emacs风格键绑定
bindkey -e
#设置DEL键为向后删除
bindkey "\e[3~" delete-char

#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'

#自动补全功能
setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE

autoload -U compinit
compinit

# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path .zcache
#zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Completion Options
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

# Path Expansion
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:default' force-list always

# GNU Colors 需要/etc/DIR_COLORS文件 否则自动补全时候选菜单中的选项不能彩色显示
#[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
[ -f ~/.dir_colors ] && eval $(dircolors -b ~/.dir_colors)
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'ps -au$USER'

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

#路径别名 进入相应的路径时只要 cd ~xxx
hash -d WWW="/srv/http"
hash -d ARCH="/mnt/arch"
hash -d ED2K="/home/andywxy/.mldonkey/incoming/files"
hash -d PKG="/var/cache/pacman/pkg"
hash -d E="/etc/env.d"
hash -d C="/etc/conf.d"
hash -d I="/etc/rc.d"
hash -d X="/etc/X11"
hash -d GA="/media/d/Scrapbook/GAbroad"

##for Emacs在Emacs终端中使用Zsh的一些设置 不推荐在Emacs中使用它
#if [[ "$TERM" == "dumb" ]]; then
#setopt No_zle
#PROMPT='%n@%M %/
#>>'
#alias ls='ls -F'
#fi 

# key bindings
 bindkey "\e[1~" beginning-of-line
 bindkey "\e[4~" end-of-line
 bindkey "\e[5~" beginning-of-history
 bindkey "\e[6~" end-of-history
 bindkey "\e[3~" delete-char
 bindkey "\e[2~" quoted-insert
 bindkey "\e[5C" forward-word
 bindkey "\eOc" emacs-forward-word
 bindkey "\e[5D" backward-word
 bindkey "\eOd" emacs-backward-word
 bindkey "\e\e[C" forward-word
 bindkey "\e\e[D" backward-word
 bindkey "^H" backward-delete-word
# for rxvt
 bindkey "\e[8~" end-of-line
 bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
 bindkey "\eOH" beginning-of-line
 bindkey "\eOF" end-of-line
# for freebsd console
 bindkey "\e[H" beginning-of-line
 bindkey "\e[F" end-of-line
# completion in the middle of a line
 bindkey '^i' expand-or-complete-prefix

# Use with GNU Screen
#screen integration to set caption bar dynamically
function title {
if [[ $TERM == "screen" || $TERM == "screen.linux" ]]; then
  # Use these two for GNU Screen:
   print -nR $'\033k'$1$'\033'\\\

   print -nR $'\033]0;'$2$'\a'
   elif [[ $TERM == "xterm" || $TERM == "urxvt" ]]; then
  # Use this one instead for XTerms:
   print -nR $'\033]0;'$*$'\a'
  #trap 'echo -ne "\e]0;$USER@$HOSTNAME: $BASH_COMMAND\007"' DEBUG
   fi
}



#set screen title if not connected remotely
function precmd {
    title "`print -Pn "%~" | sed "s:\([~/][^/]*\)/.*/:\1...:"`" "$TERM $PWD"
    echo -ne '\033[?17;0;127c'
}

function preexec {
    emulate -L zsh
    local -a cmd; cmd=(${(z)1})
   if [[ $cmd[1]:t == "ssh" ]]; then
    title "@"$cmd[2] "$TERM $cmd"
   elif [[ $cmd[1]:t == "sudo" ]]; then
    title "#"$cmd[2]:t "$TERM $cmd[3,-1]"
   elif [[ $cmd[1]:t == "for" ]]; then
    title "()"$cmd[7] "$TERM $cmd"
   elif [[ $cmd[1]:t == "svn" ]]; then
    title "$cmd[1,2]" "$TERM $cmd"
   else
    title $cmd[1]:t "$TERM $cmd[2,-1]"
   fi
}

# End of lines added by compinstall
## ====================
##  My personal alias 
## ====================

## --------------------
## Ordinary cli command
## --------------------
alias so='source ~/.zshrc'
#alias so='source ~/.bashrc'
alias ls='/bin/ls --color=auto' 
alias la='/bin/ls -a --color=auto' 
alias ll='/bin/ls -aoth --color=auto'
alias c='clear'
alias x='startx'
#alias man="TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man"
alias disk='df -lh'

## --------------------
##   Dual Head related
## --------------------
alias 2head='xrandr --output VGA --right-of LVDS'

# ---------------
# file operations
# ---------------
alias s-cp='sudo cp'
alias cpr='cp -r'
alias s-cpr='sudo cp -r'
alias rmr='rm -r'
alias rmf='rm -f'
alias rmrf='rm -rf'
alias srm='sudo rm'
alias srmf='sudo rm -f'
alias srmr='sudo rm -r'
alias srmrf='sudo rm -rf'
alias smv='sudo mv'
alias ..='cd ..'
alias ....='cd ../../'
alias sln='sudo ln -s'

# ----------------
# searching
# ----------------
alias lt='locate'
alias ltdb='sudo updatedb'

## -------------------
##  for Editors
## -------------------
alias v='vim'
alias sv='sudo vim'
alias gv='gvim'
alias sgv='sudo gvim'

## --------------------
##   Pacman related
## --------------------
alias vu='cat /home/andywxy/bin/updates.log | grep pkg' # view updates
alias pacman='powerpill --nomessages'
alias p='pacman -S'
alias sp='sudo pacman -S'
alias pp='powerpill -S'
alias spp='sudo powerpill -S'
alias t='tupac -S'
alias st='sudo tupac -S'


alias ts='tupac -Ss'

alias spU='sudo pacman -U'

alias tr='tupac -R'
alias trd='tupac -Rd'
#alias trd='tupac -Rscn'
alias tu='tupac -Syu'
alias ppu='sudo powerpill -Syu'
alias auru='yaourt -Su --aur'
alias spc='sudo pacman -Scc' 
alias spo='sudo pacman-optimize'
alias spiu='srm /var/lib/pacman/db.lck'
alias pq='pacman -Q |grep'
alias pl='tail /var/log/pacman.log'
alias pacbuilder='sudo pacbuilder'

## --------------------
##  Mount commands
## --------------------
alias mta='sudo mount -a'
alias umta='sudo umount -a'
alias mtu-f='sudo mount -t vfat -o iocharset=gb2312 /dev/sdb1 /media/usb'
alias mtu-n='sudo mount -t ntfs-3g -o iocharset=gb2312 /dev/sdb1 /media/usb'
alias umtu='sudo umount /media/usb'
alias miso='sudo mount -o loop,iocharset=utf8'

## -------------------
##     Transset
## -------------------
alias t5='transset .5'
alias t10='transset .10'
alias t15='transset .15'
alias t20='transset .20'
alias t25='transset .25'
alias t30='transset .30'
alias t35='transset .35'
alias t40='transset .40'
alias t45='transset .45'
alias t50='transset .5'
alias t55='transset .55'
alias t60='transset .60'
alias t65='transset .65'
alias t70='transset .70'
alias t75='transset .75'
alias t80='transset .80'
alias t85='transset .85'
alias t90='transset .90'
alias t95='transset .95'
alias t100='transset 1'

## -------------------
##   Reboot, etc.
## -------------------
alias rt='sudo reboot'
alias ht='sudo halt'
alias 2r='sudo pm-suspend'
alias 2d='sudo pm-hibernate'

## ------------------
##   Network apps
## ------------------
alias mitter='mitter -u username -p passwd -i cmd -s'
alias w='w3m'
alias dh='ssh -qTfnN -D 7070 username@blog.username.cn'
alias us0ftp='lftp -p 21 -u username,passwd ftp.andywx.host4.meyu.net'
alias us1ftp='lftp -p 21 -u username,passwd hzhan.com'
alias dh1ftp='lftp -p 21 -u username,passwd daxter.dreamhost.com'
alias mld='mlnet &> /dev/null &'
alias mldstp='sudo /etc/rc.d/mldonkey stop'
alias rtorrent='dtach -A /tmp/rtorrent.dtach /usr/bin/rtorrent'

## ------------------
##    MPD Related
## ------------------
alias mdb='sudo /etc/rc.d/mpd create-db'
alias mst='sudo /etc/rc.d/mpd start'
alias mstp='sudo /etc/rc.d/mpd stop'
alias madd='mpc ls | mpc add'

## -----------------
##     MP3 Tags
## -----------------
alias tag='find . -iname "*.mp3" -execdir java -jar /home/andywxy/id3iconv-0.2.1.jar -e Big5 {} \;'
alias tag2='find . -iname "*.mp3" -execdir java -jar /home/andywxy/id3iconv-0.2.1.jar -e GB2312 {} \;'
alias tag3='find . -iname "*.mp3" -execdir java -jar /home/andywxy/id3iconv-0.2.1.jar -e GBK {} \;'

## ----------------
##    Screenshot
## ----------------
alias screenst='scrot -d 5 -c '%Y-%m-%d_$wx$h.png''


## -----------------
##    Other alias
## -----------------
alias obm='mmaker -vf Openbox3 && openbox --reconfigure'
alias sapd='v /media/d/Scrapbook/GAbroad/SA-Pod.text'
#alias cmbi='v /home/andy/Desktop/CMBI-Daily.Papers/Intro_Index'
alias apg='v /media/d/Arch/settings/Arch_Personal_Guide.text'
alias chl='wget http://channel.sopcast.com/chlist.xml & cp chlist.xml ~/.gmlive/sopcast.lst & rm chlist.xml'
alias logit='lodgeit.py'
alias psen='v /media/d/Scrapbook/GAbroad/PS_en.txt'
alias lynx='lynx -cfg .lynxrc'

## =====================
##    Bash Scripts
## =====================

## ---------------------
##  Systerm Upgrade
## System update using powerpill, yaourt, abs
## ---------------------
# # # Arch32bit + AUR + ABS, Arch32 chroot + AUR
 function syu()
 {
  #mplayer -nolirc -really-quiet 
  mpg123 -q /home/andywxy/Desktop/Sound/Dexter\ Sounds\ 1.0/login\ screen/loginscreenready2dexter.mp3 > /dev/null 
 echo -e '\e[1;39mHi, sir. 
\e[1;39mStart \e[1;34mArch \e[0;32m+ \e[1;32mAUR \e[0;32m+ \e[1;35mABS \e[1;39mfull upgrade ... right now? \e[1;32m[y|n]\033[0m'
 read ans
 case $ans in
   Y|y) ;;
     [Yy][Ee][Ss]) ;;
       N|n) return ;;
         [Nn][Oo]) return ;;
           *) echo "Invalid Command"
             return ;;
             esac
             echo -e '\e[0;32m-------------------------------------\033[0m'
             echo -e '\e[1;33m==> \e[1;39mStart \e[1;34mArch \e[1;39mupgrading ...\033[0m'
             echo -e '\e[0;32m-------------------------------------\033[0m'
             #sudo powerpill -Syu 
	     tupac -Su
             echo -e '\e[0;32m-------------------------------------\033[0m'
             echo -e '\e[1;33m==> \e[1;39mSearching for \e[1;32mAUR \e[1;39mupdates ...\033[0m'
             echo -e '\e[0;32m-------------------------------------\033[0m'
             yaourt -Su --aur
             echo -e '\e[0;32m-------------------------------------\033[0m'
             echo -e '\e[1;33m==> \e[1;39mRsync \e[1;35mABS \e[1;39mnow ...\033[0m'
             echo -e '\e[0;32m-------------------------------------\033[0m'
             sudo abs
	     #rsync
	     echo -e '\e[1;39mCongradulations sir! Your Arch has been in the latest stage! Hooray!\033[0m'
	     echo -e '\e[1;39mYou may now have a look at what has been updated after this upgrade by using \e[1;31mpl \e[1;39mcommand :)\033[0m'
	     #mplayer -nolirc -really-quiet 
	     mpg123 -q /home/andywxy/Desktop/Sound/Dexter\ Sounds\ 1.0/login\ screen/loginsuccessdexter.mp3 > /dev/null 
 }
#             #echo -e '\e[0;36m--------------------------------------------\033[0m'
#             #echo -e '\e[1;36m==> \e[0;36m现在开始 \e[1;36mArch32 chroot \e[0;36m系统升级 \e[1;36m+ AUR\e[0;36m...\033[0m'
#             #echo -e '\e[0;36m--------------------------------------------\033[0m'
#             #sudo chroot /opt/arch32 yaourt -Syu --aur
#             }


## ---------------------
## Show the size of dir
## dirsize - finds directory sizes and lists them for the current directory
## ---------------------

dirsize ()
{
	du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
	egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
	egrep '^ *[0-9.]*M' /tmp/list
	egrep '^ *[0-9.]*G' /tmp/list
	rm /tmp/list
}

## ----------------------
## Show IP
## myip - finds your current IP if your connected to the internet
## ----------------------
myip ()
{
lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' 
}

## --------------------
## clock - A bash clock that can run in your terminal window.
## --------------------
clock ()
{
while true;do clear;echo "===========";date +"%r";echo "===========";sleep 1;done
}

## --------------------
## netinfo - shows network information for your system
## --------------------
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
#myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
#echo "${myip}"
echo "---------------------------------------------------"
}

## ---------------------
##   Import shotscreen
## shot - takes a screenshot of your current window
## ---------------------
shot ()
{
import -frame -strip -quality 75 "$HOME/$(date +%s).png"
}

## ---------------------
##   Quick backup
## bu - Back Up a file. Usage "bu filename.txt" 
## ---------------------
bu () { cp $1 ${1}-`date +%Y%m%d%H%M`.backup ; }

## ---------------------
##   Quick navigation
##  'up' is the same as 'cd ..'; 'up 3' is the same as 'cd ../../..'; etc
## ---------------------
up ()
{
  [[ $# -eq 0 ]] && cd ..
  if [[ $1 =~ ^[0-9]+$ ]] && [[ $1 -gt 0 ]]
  then
      dirs=1
      until [[ $dirs -gt $1 ]]
      do
          command="${command}../"
      dirs=$(($dirs+1))
      done
      cd $command
      command=''
  fi
}

## ---------------------
##  Linux Console Platte
## ---------------------
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P8555753" #darkgrey
    echo -en "\e]P1a40000" #darkred
    echo -en "\e]P9cc0000" #red
    echo -en "\e]P24e9a06" #darkgreen
    echo -en "\e]PA73d216" #green
    echo -en "\e]P3edd400" #brown
    echo -en "\e]PBffc123" #yellow
#    echo -en "\e]PBc4a000" #yellow
    echo -en "\e]P4204a87" #darkblue
    echo -en "\e]PC3465a4" #blue
    echo -en "\e]P5ce5c00" #darkmagenta
    echo -en "\e]PDf57900" #magenta
#    echo -en "\e]P6038e82" #darkcyan
#    echo -en "\e]PE05d2c1" #cyan
    echo -en "\e]P689b6e2" #darkcyan
    echo -en "\e]PE46a4ff" #cyan
    echo -en "\e]P7babdb6" #lightgrey
    echo -en "\e]PFd3d7cf" #white
    clear #for background artifacting
fi

## =======================
##    Auto login to WMs
## =======================
if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/vc/1 ]]; then
	  exec startx
fi

if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/vc/2 ]]; then
	  exec uf
fi

#############################
##    Only for Bash
############################
## Color your Terminal
#PS1='[\u@\h \W]\$ '
#export LS_COLORS='no=00:fi=00:di=01;37;44:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mng=01;35:*.xcf=01;35:*.pcx=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.avi=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.mov=01;35:*.qt=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.pdf=00;32:*.ps=00;32:*.txt=00;32:*.patch=00;32:*.diff=00;32:*.log=00;32:*.tex=00;32:*.doc=00;32:*.mp3=01;32:*.wav=01;32:*.mid=01;32:*.midi=01;32:*.au=01;32:*.ogg=01;32:*.flac=01;32:*.aac=01;32:';

## Bash Completion
#if [ -f /etc/bash_completion ]; then
#	    . /etc/bash_completion
#fi

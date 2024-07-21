# .bashrc

################################################################################
# General setup:
#
[ -f /etc/bashrc ] && . /etc/bashrc # Source global definitions
[ -f /etc/bash_completion ] && . /etc/bash_completion || echo 'no bash completion' # bash completions
[ -z $SSH_AUTH_SOCK ] && eval `ssh-agent -s` >/dev/null # start ssh-agent if not already running

################################################################################
# Configure the prompt:
#
# black 0;30
# blue 0;34
# green 0;32
# cyan 0;36
# red 0;31
# purple 0;35
# brown 0;33
# light gray 0;37
# dark gray 1;30
# light blue 1;34
# light green 1;32
# light cyan 1;36
# light red 1;31
# light purple 1;35
# yellow 1;33
# white 1;37
#
# '\[' starts non-printing chars
# '\e' declares an escape character
# '\033[' escape sequence
# '0' uses default attribute
# ';32m' sets the color
# '\]' ends non-printing chars
# '\[\033[0;34m\]' turns font color blue
# '\!' is the command number, \h is hostname, \w is current directory
#
alias parenspace='sed "s/.*/ (&)/"' 
function git_branch_name() { git branch --show  2> /dev/null | parenspace; }
function virtualenv_name() { [[ -n $VIRTUAL_ENV ]] && (basename $VIRTUAL_ENV | parenspace); }
function set_terminal_window_name() { echo -ne "\033]0;$@\007"; }
function set_prompt() {
    set_terminal_window_name $(hostname)
	green='\[\e[0;32m\]'
	brown='\[\e[0;33m\]'
	purple='\[\e[0;35m\]'
	cyan='\[\e[0;36m\]'
	color_stop='\[\e[m\]'
	PS1="$green\h$brown$(git_branch_name)$purple$(virtualenv_name) $cyan\w$color_stop$ "
}
export PROMPT_COMMAND=set_prompt


################################################################################
# Set commands
#
set -o vi # Vi command line mode
set -o noclobber
unset autologout
set nobeep
set visualbell
set wildmode=longest,list
set wildmenu
bind -m vi-insert "\C-l":clear-screen # clear screen with ^L
bind Space:magic-space
set page-completions off

################################################################################
# Environment variables:
#
#
export EDITOR=vim
export CDPATH=.:~/amyris/src:~/src:~/Dropbox/gcloud/projects
export PATH=~/bin:$PATH
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export HISTCONTROL=erasedups
export WORDS=/usr/share/dict/american-english

# append to the history file, don't overwrite it
shopt -s histappend

################################################################################
# Aliases:
#
alias grep='egrep --color'
alias page=less
alias findgrep='find -type f | xargs grep'
alias ls='ls -F --color'
alias la='ls -a'
alias ll='ls -l'
alias lh='ll -h'
alias lt='ls -X1'
alias lstype=lt
#alias lc=lscat
alias llsort='ll -rSh'
alias dir=ll
alias vi=vim
alias vip='vim -c "set paste"'
alias rm='rm -i'
alias en='enscript -G -r -2'
alias myps='ps -ef | grep -i'
alias cat='bat'
alias sortlength="awk '{print length, \$0}' | sort -h"
function spellingbee {
    usage="
        Specify 7 letters (center letter first), without spaces. 
        For example: 

            spellingbee ontymax
    "
    ([[ $# -ne 1 ]] || [[ ${#1} -ne 7 ]]) && echo "$usage" && return 1
    allowed=$1
    required="${allowed:0:1}"
    grep -i "^[$allowed]+$" $WORDS | grep -i "$required" | sortlength
}


alias mplayer='mplayer -zoom -af volume'
alias gmplayer='gmplayer -zoom -af volume -ao sdl'
alias fish='~/src/cpp_prog/cscie234/fish/a.out'

alias good_pics_export='~/.virtualenv/twitter/bin/python ~/bin/good_pics_export.py'
alias library_search='~/.virtualenv/twitter/bin/python ~/bin/library_search.py'

alias is_vpn_on='nmcli connection show --active | grep "amyris|csco" > /dev/null'
#alias vpn_on_no_matter_what='nmcli connection up amyris_sstp && sleep 2'
alias vpn_on_no_matter_what='\cat ~/.login_info_vpn | /opt/cisco/anyconnect/bin/vpn -s connect sslvpn.amyris.com/fulldns &> /dev/null'
alias vpn_on='is_vpn_on || (vpn_on_no_matter_what)' # the parens after the || prevent the sleep from happening if is_vpn_on is true: "a || (b && c)" instead of "(a || b) && c"
#alias vpn_off='nmcli connection down amyris_sstp'
alias vpn_off='/opt/cisco/anyconnect/bin/vpn disconnect &> /dev/null'
alias vpn_off_on='vpn_off; vpn_on_no_matter_what'
alias wifi_off_on='nmcli connection down hogwarts && nmcli connection up hogwarts'

alias wifispeed_network='nmcli --terse connection show --active | cut -d: -f 1 | sort -r | xargs | sed "s/ /_/"'
alias wifispeed_speedtest='speedtest --simple --no-upload 2> /dev/null | grep Download | cut -d\  -f 2 || echo "0.00"'
alias wifispeed='(date +%F\ %R; (wifispeed_network && wifispeed_speedtest) || echo "no-network 0.0") | xargs'
alias wifispeed_tee=' wifispeed | tee -a ~/Dropbox/export/apple_health_export/wifi_speed_data.txt'
function testwifispeeds {
    for ssid in $*; do
        date
        echo "swtiching to $ssid"
        nmcli connection up $ssid > /dev/null;
        sleep 120;
        wifispeed_tee
        sleep 600;
    done
}
alias lynx='lynx -accept_all_cookies'
#alias g++='g++ -Wall -g -lm'
#alias gcc='gcc -Wall -g -lm'
alias g++='g++ -Wall -g -lgsl -lgslcblas -lm'
alias gcc='gcc -Wall -g -lgsl -lgslcblas -lm'
alias gobj='\gcc -lgnustep-base -lobjc -lm -lc -I/usr/include/GNUstep'
#alias g++='g++ -Werror -Wall -Wpointer-arith -Wwrite-strings -Woverloaded-virtual -Wsynth -W -Wconversion -Wno-non-template-friend -Wno-long-long -Wsign-promo -Wundef -Wmissing-noreturn -Wcast-qual -g -lGL -lGLU -lglut'
function g++gl { g++ -Werror -Wall -Wpointer-arith -Wwrite-strings -Woverloaded-virtual -Wsynth -W -Wconversion -Wno-non-template-friend -Wno-long-long -Wsign-promo -Wundef -Wmissing-noreturn -Wcast-qual -g $* -lGL -lX11 -lXmu -lGLU -lglut; }
alias gccgl='gcc \!* -lGL -lX11 -lXmu -lGLU -lglut'

alias mp3length='~/.virtualenv/discord-1.7.3/bin/python ~/bin/mp3length.py'
function mp4tomp3 { ffmpeg -i $1 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 $2; }
function id3tag_all { cd ~/books && find . -type f | sort -n | grep -v '^$' | id3tag_everything; }
#function mp3downcode_all { find . -type f -name \*.mp3 | xargs mp3downcode; }
#function mp3downscode { find . -type f -name \*.mp3 | sort -n | perl -anle 'system qq/lame --preset voice "$_" "${_}.downcoded"; id3cp "$_" "${_}.downcoded"/'; }
#function mp3downscodesingle { lame --preset voice "$1" "$1.downcoded"; id3cp "$1" "$1.downcoded"; }

function hist { [[ $# -lt 1 ]] && history || history | grep $*; }

function flatten {
    if [ $# -lt 1 ]; then
        dir="."
    else
        dir=$1
    fi

    find $dir  -type f | sort -n | \
        perl -nle '$_ =~ s/^\.\///; $post = $_; $post =~ s/\//_/g; print qq/cp "$_" "$post"/'
}

# Dev machine connections:
#
function is_dev_reachable() { ping -q -c1 $1 > /dev/null 2>&1; }
# Connect to existing tmux on remote machine, and give the local window a helpful name
# The ${@:2} allows putting a "-d" or something on the end of a dev174 call
function connect_dev {
    dest_name=$1
    is_dev_reachable $dest_name.amyris.local || ( vpn_off_on ) # the parens after the || enclose the vpn_on alias, see comment for vpn_on
    set_terminal_window_name $dest_name
    ssh kallen@$dest_name.amyris.local -t tmux a ${@:2}
    vpn_off
}
alias dev02="connect_dev dev02"
alias dev116="connect_dev dev116"
alias dev174="connect_dev dev174"
alias devaz14="connect_dev az-dev14" 
alias dev169="connect_dev dev169" # Ted
alias dev187="connect_dev dev187" # Nathan Dunn
alias dev189="connect_dev dev189" # Joe B

alias restore_tmux="python3 ~/src/tmux_scripts/tmux_state_restore.py >| /tmp/tmp.sh && bash /tmp/tmp.sh"

# Remote machine protocol RDP connections:
#
alias kallenlaptop_ip='xfreerdp /u:kallen /v:10.10.10.238 /h:668 /w:1266'
alias kallenlaptop_fullscreen_ip='xfreerdp /u:kallen /v:10.10.10.238 /h:768 /w:1366 /f'
alias kallenlaptop='xfreerdp /u:kallen /v:lt-kallen.amyris.local /h:668 /w:1266'
alias kallenlaptop_fullscreen='xfreerdp /u:kallen /v:lt-kallen.amyris.local /h:768 /w:1366 /f'
alias themis_windows_fullscreen='xfreerdp /u:kallen /v:10.10.11.136 /h:768 /w:1366 /f'
alias lab-cm7-094='echo "lab user"; xfreerdp /u:lab /v:lab-cm7-04.amyris.local /h:768 /w:1366 /f'
alias nirhts96='echo "lab user"; xfreerdp /u:lab /v:lab-nirhts96.amyris.local /h:768 /w:1366 /f'
alias phillaptop='echo "phil laptop"; xfreerdp /u:kallen /v:lt-norton2.amyris.local /h:768 /w:1366 /f'
alias empower_machine='echo "empower machine"; xfreerdp /u:lab /v:lab-lantern.amyris.local /h:768 /w:1366 /f'

alias jazzlist='find ~/iTunes/iTunes\ Music/Music -type f -name \*.mp3 | grep -i mingus\|monk\|coltrane\|davis | grep -v -i monkey\|skauthentic | python3 ~/bin/discord_song_name.py | python3 ~/bin/uniq_filter.py'
alias itunes_update='start_itunes_date=$(date); echo "rsync"; rsync -ah /media/kester/itunes2020/iTunes/ /home/kester/iTunes/; date; echo "convert"; find ~/iTunes/ -type f -name \*.m4a | grep -v "\/\._[0123456789]" | ~/.virtualenv/discord-1.7.3/bin/python ~/bin/convert_m4a_to_mp3.py ; echo "start: $start_itunes_date"; echo "end:   $(date)"'



# Add an "alert" alias for long running commands. Use like so:
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

function webcamremote { 
    if [ $# -lt 1 ]; then
        echo "specify remote IP"; return;
    else
        remote_ip=$1
        ssh $remote_ip mplayer tv:// -tv driver=v4l2:device=/dev/video0:outfmt=rgb24 -frames 1 -vo jpeg && \
            rsync $remote_ip:00000001.jpg . && \
            display 00000001.jpg;
    fi
}

#function wormcam rsync --rsync-path=/usr/bin/rsync --rsh='ssh -p2289' movie_2020050*_10th* storybo@storybookdachshunds.com:www/wormcam/
#function makegif {
    #output_gif=${@:~0};
    #input_files=${@:1:$#-1};
    #convert -delay 10 -loop 0 $( $input_files | awk 'NR % 10 == 0') $output_gif;
#}
#convert -delay 10 -loop 0 $(\ls ~/Desktop/wormcam/img_20200502_1* | awk 'NR % 10 == 0') movie_20200502_10th.gif
alias storybook='ssh -p2289 storybo@storybookdachshunds.com'





################################################################################
# Nostalgia:

#export TY2_PATH=~
#function storybook { rsync -a --inplace --rsh='ssh -p2289' ~/www/storybook/www/ storybo@storybookdachshunds.com:www; }

#alias fat32='sudo mount /dev/hda6 /mnt/fat32 '
#alias google='browse --picksite 0'
#alias dict='browse --picksite 1'
#alias ask='browse --picksite 2'
#alias jeeves=ask
#alias thes='browse --picksite 3'
#alias x500='browse --picksite 4'
#alias dictionary=dict 
#alias thesaurus=thes

#alias darkmatter='ssh -X kester@darkmatter.arc.nasa.gov'
#alias hive='ssh fc@99.33.86.72 -p 8903'
#alias flux='ssh -X kester@flux.arc.nasa.gov'
#alias fluxtunnel='ssh kester@flux.arc.nasa.gov -o TCPKeepAlive=yes -L 1521:143.232.108.135:1521 -L 2049:abyss:2049 -L 8888:flux:80 -L 9999:ecliptic:8080'

#export ORACLE_HOME=/home/kester/OraHome_1
#export ORACLE_SID=kepler_localhost
#export JAVA_HOME=/home/kester/jdk1.6.0_20
#export JAVA_HOME=/usr/java/latest
#export ANT_HOME=~/svn/vendor/ant/latest
#export KDE_HOME=~/.kde
#export CVSROOT=flux.arc.nasa.gov:/home/cvs
#export CVS_RSH=ssh
#export FVTMP=/home/kester/.fvtmp
#export HEADAS=/home/kester/bin/headas-6.2/i686-pc-linux-gnu-libc2.2.4
#export HEADAS=/home/kester/bin/heasoft-6.5.1/x86_64-unknown-linux-gnu-libc2.3.4/
#export PATH=~/bin:~/svn/vendor/ftools/ftools-libc2.2.4/bin/:~/svn/vendor/ftools/ftools-libc2.2.4/:~/svn/vendor/ftools:$ANT_HOME/bin:~/eclipse:/usr/bin/mh:~/bin/comics:~/OraHome_1/bin:~/bin/matlab2010b/etc:~/bin/matlab2010b/bin:~/bin/funtools:~/bin/fv4.4:$PATH:/sbin:~/spice_tests/tspice_c/exe::~/bin/wcstools-3.6.8:~/bin/wcstools-3.6.4:~/svn/soc/code/dist/bin:~/bin/vnc-4_1_3-x86_linux/:~/bin/Adobe/Reader8/bin:/home/kester/vigilent/git/vigs/vpy/rigger
#export PATH=~/bin:/home/kester/svn/vendor/ftools/ftools-libc2.2.4/bin/:/home/kester/svn/vendor/ftools/ftools-libc2.2.4/:/home/kester/svn/vendor/ftools:$ANT_HOME/bin:~/eclipse:/usr/bin/mh:$JAVA_HOME/bin:~/bin/comics:~/OraHome_1/bin:/usr/local/matlab/etc:/usr/local/matlab/bin:~/bin/funtools:~/bin/fv4.4:$PATH:/sbin:~/spice_tests/tspice_c/exe:~/svn/soc/code/java/fc/bin:~/bin/wcstools-3.6.8:~/bin/wcstools-3.6.4:~/svn/soc/code/dist/bin:~/bin/vnc-4_1_3-x86_linux/:~/bin/Adobe/Reader8/bin
#export REFPIXPATH=/soc/abyss/soc/java/dr/pixels/src-monthly/etem/results/6/refpix_data
#export REFPIXLOCALPATH=/home/kester/ETEM/runs/refpix_data
#export KEPLER_CONFIG_PATH=/home/kester/svn/soc/code/stable/kepler.properties
#export SOC_CODE_ROOT=/home/kester/svn/soc/code
#export SOC_DIST_ROOT=/home/kester/svn/soc/code/dist
#export MATLAB_HOME=/home/kester/bin/matlab2010b
## FTOOLS init:
##
#. $HEADAS/headas-init.sh
#export PGPLOT_DIR=/usr/local/pgplot
#
#alias get_dirs   "perl -MWWW::Yahoo::DrivingDirections=get_dirs -e 'get_dirs ( \!* )'"
#alias make_plot  "perl -MChart::Scientific=make_plot -e 'make_plot ( \!* )'"
#alias sshcp      'ssh target_address cat <localfile ">" remotefile'
#alias id3tag_all 'find . -type f | perl -anle '"'"'system qq{id3tag -a"\!:1" -A"\!:2" -s"$_" "$_"}'"'"' '
#alias la2ps='set f = \!*; latex ${f}.tex && latex ${f}.tex && dvips -Ppdf -tletter ${f}.dvi && ps2pdf ${f}.ps ${f}.pdf && acroread ${f}.pdf'
#alias ns=''firefox "\!*" &'
#alias maskdir='cd /soc/abyss/soc/java/dr/pixels/src-monthly/etem/results/6/'
#alias inc='fetchmail -q; fetchmail -k; inc && pick -to commits | xargs refile +commits; fetchmail -q'
#alias matlab='~/bin/matlab -desktop -r "dbstop if error; format long g; initialize_soc_variables;"'
#alias matlabquiet='~/bin/matlab -nodesktop -nosplash -r "dbstop if error; format long g; initialize_soc_variables;"; stty echo'
#function matlabfnquiet { ~/bin/matlab -nodesktop -nosplash -r "format long g; initialize_soc_variables;" -r "$*"; stty echo; } 
#function far { ssh -X flux.arc.nasa.gov "ssh albedo $*"; }
#function ds9 { ~/bin/ds9 $* -scale log -cmap bb -zoom to fit; }
#alias javaPlot='java -jar ~/bin/javaPlot.jar'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec sway -c /home/le/.config/sway/config
fi

# PS1='[\u@\h \W]\$ '
PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

# Alias and function location
source ~/.profile

# powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1

# . /usr/share/powerline/bindings/bash/powerline.sh
# . "$HOME/.cargo/env"

function arecord-mic {
    [[ $1 == *[![:digit:]]* ]] || return
    typeset tmpFile
    tmpFile=$(mktemp --suffix .wav) || return

typeset -a arecordOpts=(
        -c 1          # number of channels
        -D plughw:0,0 # device name
        -d "$1"       # duration
        -f S32_LE     # format
        -r 48000      # sample rate
        -V mono       # VU meter type
    )

arecord "${arecordOpts[@]}" -- "$tmpFile" && aplay -- "$tmpFile"
    rm -f -- "$tmpFile"
}

alias py='python'
alias db='sudo updatedb'
alias ls='ls --color=auto'
alias db='sudo updatedb'
alias la='ls -a'
alias l='ls -lah'
# alias spotify='flatpak run com.spotify.Client'
alias rld='source .bashrc'
alias gorp='rg -i'; alias glorp='rg -i'; alias grop='rg -i'; alias gpor='rg -i'; alias gpro='rg -i'; alias pogr='rg -i'; alias rgop='rg -i'
alias order_66='seek_destroy'
alias ~='cd ~'
alias ..='cd ..'
alias this='pwd'
alias chatgpt='firefox https://chat.openai.com/'
alias sms='sway-focus kdeconnect-sms'
alias gsms='sway-focus firefox https://messages.google.com/web/conversations'
alias ugee='bash /usr/lib/ugee-pentablet/ugee-pentablet.sh'
alias update='sudo pacman -Syu'
alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
alias wttr='curl -s wttr.in/seattle'
alias alacritty='alacritty --print-events > /home/le/.alacritty-events'
alias redshift='redshift -l "$LATITUDE":"$LONGITUDE"'
alias android-finder='firefox https://www.google.com/android/find/'
# alias firefox='firefox-developer-edition'
alias helix="hx"
alias vim="nvim"
alias spotify="/home/le/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/spotify"
alias emacs="doom run" 

# path shortcuts
alias .keyboard-config="cd /usr/share/X11/xkb/symbols"
alias .kernel-config="cd /usr/src/linux" # do ```make menuconfig``` here
alias .portage-config="cd /etc/portage"
alias .config-home="cd $XDG_CONFIG_HOME"

# soundboard
source /home/le/.sounds

# PS1='[\u@\h \W]\$ '
# PS1=\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$

# Particle accelerator.
# $1  sound to be accelerated.
# $2  starting time. (default 1)
# $3  acceleration factor.  (default .1)
# $4  end iteration. (default 
accelerate() {    
  case $# in
  1)  time=1;
      acc=.1;
      end=100;;
  2)  time=$2;
      acc=.1;
      end=100;;
  3)  time=$2;
      acc=$3;
      end=100;;
  4)  time=$2;
      acc=$3;
      end=$4;;
  esac
  cpu=0  
  iter=0
  while [ "$iter" -le "$end" ] || [ "$cpu" -gt 80 ]; do
    eval $1 & sleep "$time";
    let "time=time/(1+acc*time)" "iter=iter+1"
    if [ `expr $iter % 5` -eq 15 ]; then
      cpu=$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,' |awk '{print ($6)}' &)
    fi
  done
  vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print ($5)}')
  pactl set-sink-volume @DEFAULT_SINK@ 100%
  explosion & $1 & $1 & $1 & $1 & $1 & $1 & $1 & $1 & $1 & $1 &
  while pgrep mpv > /dev/null; do
    pactl set-sink-volume @DEFAULT_SINK@ 100%
  done
    
  pactl set-sink-volume @DEFAULT_SINK@ "$vol"

}

# Evil. Annoy people with smoke detector sounds every minute.
# $1  number of beeps.
smoke-detector-machine() {
  if [ "$#" -eq 1 ]; then
    time=$1
    iter=0
    while [ "$iter" -lt "$time" ]; do
      mpv /home/le/Music/sounds/smoke-detector-beep.wav --volume=100 &
      let "iter=iter+1"      
      sleep 60    
    done
  else
    while [ 1 ]; do
      mpv /home/le/Music/sounds/smoke-detector-beep.wav --volume=100 &
      sleep 60
    done
    
  fi
}

soundlist() {
  cat ~/.sounds | cut -d'=' -f1 | cut -d' ' -f2
}

mkcd() {
  mkdir "$1" && cd "$1"
}

google() {
  url=https://www.google.com/search?q="$1"
}

set_path() {

  # Check if user id is 1000 or higher
  [ "$(id -u)" -ge 1000 ] || return

  for i in "$@";
  do
    # Check if the directory exists
    [ -d "$i" ] || continue

    # Check if it is not already in your $PATH
    echo "$PATH" | grep -Eq "(^|:)$i(:|$)" && continue

    # Then append it to $PATH and export it
    export PATH="$PATH:$i"
  done
}

seek_destroy() {
  sudo updatedb;

  locate -i "$@";
  read -p "Remove all? (N/y): " yn
  case $yn in
    [Yy]* ) locate -0 "$@" | sudo xargs -0 rmv -rf;
      echo Targets destroyed;;
    [Nn]* ) echo "Everything will remain intact.";;
    * ) echo "Everything will remain intact.";;
  esac
}

rmv() {
  mv "$@" /tmp
}

cs() {
        cd "$1" && ls -ah "${@:2}";
}

cps(){
  cd "$1" && pwd && ls "${@:2}";
}

cheat() {
      curl cht.sh/$@
}

power() {
    currentP=$(cat /sys/class/power_supply/BAT0/charge_now)
    fullP=$(cat /sys/class/power_supply/BAT0/charge_full)
    statusP=$(cat /sys/class/power_supply/BAT0/status)
    percentP=$((100 * currentP / fullP))
    echo "$percentP%\n$statusP"
}

# . "$HOME/.cargo/env"

# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export XDG_CURRENT_DESKTOP=Sway

export FILE_MANAGER=ranger
export XDG_CONFIG_HOME=/home/le/.config
export EDITOR=nvim
export PDF_VIEWER=evince
export term=alacritty; export TERM=alacritty

export PATH=$PATH:/home/le/.spicetify

export WINEFSYNC=1
export WINE_LARGE_ADDRESS_AWARE=1
WINEPREFIX=/usr/bin/setup_dxvk.sh install --symlink
WINEPREFIX=/usr/bin/setup_vkd3d_proton.sh install --symlink

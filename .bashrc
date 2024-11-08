# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\n\$ "

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
alias rld='source ~/.bashrc'
alias glorp='rg -i';
alias order_66='seek_destroy'
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
# alias vim="nvim"; alias vi="nvim"; alias nivm="nvim"
# alias spotify="/home/le/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/spotify"
alias rust-repl="evcxr"; alias rusti="evcxr"
# path shortcuts
alias .keyboard-config="cd /usr/share/X11/xkb/symbols"
alias .kernel-config="cd /usr/src/linux" # do ```make menuconfig``` here
alias .portage-config="cd /etc/portage"
alias .config-home="cd $XDG_CONFIG_HOME"
alias zotify='zotify --root-path=$(pwd)'
alias diff='diff --color=auto'
alias firefox='firefox-devedition'
alias track='track-command'

mkcd() {
  mkdir "$1" && cd "$1"
}

google() {
  url=https://www.google.com/search?q="$1"
  firefox-devedition "$url"
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

export XDG_HOME_DIR=/home/le
export XDG_CURRENT_DESKTOP=Sway
export XDG_CONFIG_HOME=/home/le/.config
# export NIXOS_XDG_OPEN_USE_PORTAL=1

export FILE_MANAGER=lf
export EDITOR=nvim
export PDF_VIEWER=firefox-devedition
export term=alacritty; export TERM=alacritty

export PATH=$PATH:"$XDG_HOME_DIR"/.spicetify:"$XDG_HOME_DIR"/.dotnet/tools:"$XDG_HOME_DIR"/.gem/ruby/3.2.0/bin:/usr/bin/hla

export WINEFSYNC=1
export WINE_LARGE_ADDRESS_AWARE=1
# WINEPREFIX=/usr/bin/setup_dxvk.sh install --symlink
# WINEPREFIX=/usr/bin/setup_vkd3d_proton.sh install --symlink

export DOTNET_CLI_TELEMETRY_OPTOUT=0
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

export PYTHONSTARTUP=~/.pyrc

export PATH=$PATH:/usr/bin/hla:/home/le/perl5/bin
export XDG_BACKGROUND_DIR=$XDG_HOME_DIR/Pictures/Wallpapers/
PERL5LIB="/home/le/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/le/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/le/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/le/perl5"; export PERL_MM_OPT;

export NIX_PATH="$NIX_PATH:nixpkgs-overlays=/etc/nixos/overlays"
# export GTK_USE_PORTAL=1

# export NIXOS_XDG_OPEN_USE_PORTAL=1
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND="1"

# systemctl --user import-environment PATH
# systemctl --user restart xdg-desktop-portal.service

if [ -f "$LFCD" ]; then
    source "$LFCD"
fi

wmname LG3D # For ghidra to run

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

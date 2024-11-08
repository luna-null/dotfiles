# if not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec sway
fi

alias android-finder='firefox https://www.google.com/android/find/'

# path shortcuts
alias .keyboard-config="cd /usr/share/X11/xkb/symbols"
alias .kernel-config="cd /usr/src/linux" # do make menuconfig here
alias .config-home="cd $XDG_CONFIG_HOME"

# soundboard
source /home/le/.sounds

# PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "


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
<<<<<<< HEAD

power() {
    currentP=$(cat /sys/class/power_supply/BAT0/charge_now)
    fullP=$(cat /sys/class/power_supply/BAT0/charge_full)
    statusP=$(cat /sys/class/power_supply/BAT0/status)
    percentP=$((100 * currentP / fullP))
    echo "$percentP%\n$statusP"
}

# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export FILE_MANAGER=ranger
export XDG_CONFIG_HOME=/home/le/.config
<<<<<<< HEAD
export EDITOR=nvim
export PDF_VIEWER=evince
=======
>>>>>>> 67261ada362766d19b2095a9f6a492ddc45110bb

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

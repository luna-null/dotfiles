#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  dbus-run-session sway -c /home/le/.config/sway/config -Dv > ~/sway.log
fi

alias android-finder='firefox https://www.google.com/android/find/'

# path shortcuts
alias .keyboard-config="cd /usr/share/X11/xkb/symbols"
alias .kernel-config="cd /usr/src/linux" # do make menuconfig here
alias .config-home="cd $XDG_CONFIG_HOME"

# soundboard
source /home/le/.sounds

# PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "


# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export FILE_MANAGER=ranger
export XDG_CONFIG_HOME=/home/le/.config
export EDITOR=nvim
export PDF_VIEWER=evince

export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[ -f /home/le/.config/.dart-cli-completion/bash-config.bash ] && . /home/le/.config/.dart-cli-completion/bash-config.bash || true
## [/Completion]


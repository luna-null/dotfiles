# bin

Some scripts that I use.

- **argp.sh**: wrapper for **getopt**(3) for **bash**(1) scripts - used in many scripts here
- **bluetooth-timeout**: turns bluetooth off if no connections 
- **ccd**: redefines the **cd**(1) command to use **fzf**(1)
- **check-links**: checks that all links to this git repo are in place
- **dark-mode**: toggles or refreshes dark-mode for **emacs**(1), any terminal eg **foot**(1), gtk and qt
- **get-podcasts**: downloads mp3 podcasts from RSS feeds
- **logit**: add datestamps to stdout and err
- **lookup**: will prompt for and save a password using **gpg2**(1).
- **lswifi**: calls **nmcli**(1) and adds physical location data
- **myautotype**: Autotype using **xvkdb**(1)/**xdotool**(1)/**ydotool**(1)
- **mybluetooth**: popup a menu for bluetooth operations
- **myclipman**: keepassxc-safe wrapper for **clipman**(1)
- **mykp**: Wrapper for **keepass-cli**(1) - safe for **clipman**(1)
- **mylock**: Set up **swayidle**(1) with automatic screen blanking, lock and/or suspend after an idle period.
- **mypass**: Wrapper for **pass**(1) - safe for **clipman**(1)
- **myreload**: reload the **sway**(1) configuration, possibly with confirmation; also check if reload is necessary
- **myrofi**: Calls **rofi**(1) with my theme
- **myscreendump**: Take a screendump with a choice of window, frame, rectangle or root. wlroots or Xorg.
- **myterm**: Run a terminal
- **mywob**: pops up **wob**(1)
- **play-mythtv**: list all mythtv recording with **fzf**(1) and plays the one selected with **mpv**(1)
- **singleton**: make sure there is one <program> running on _this_ session
- **sway-border-tweak**: tweak window borders avoiding csd (**kitty**(1) barfs on them).
- **sway-count**: graphical countdown
- **sway-fit-floats**: arrange floating windows between visible and scratchpad 
- **sway-focus**: Give focus to a program based on app_id (wayland) or class (Xwayland)
- **sway-hide**: Hides the current terminal and runs the gui-program
- **sway-kill**: kills the focused program
- **sway-menu**: popup a menu of sway commands
- **sway-mode**: displays some help for a sway 'mode' (uses nwg-wrapper)
- **sway-move-to**: move a window to top-right, bottom-right, etc
- **sway-next-empty-workspace**: Jumps to the next empty workspace.
- **sway-pip**: make the current window (or run a command) Picture-In-Picture
- **sway-prep-xwayland**: once **sway**(1) is running, load up xwayland's xrdb database, etc
- **sway-prop**: shows the properties of the focused window
- **sway-run-or-raise**: jump to a running program and focus it - else start it
- **sway-runner**: Run a swaymsg command on the Nth sway session, typically from a ssh tty or from **cron**(1) or **at**(1)
- **sway-select-window**: show running programs and select one to display with **wofi**(1)
- **sway-select-window2**: show running programs and select one to display with **wofi**(1) (in **python**(1))
- **sway-start**: start a **sway**(1) session from a console tty
- **sway-start-apps**: system-specific auto-startup apps for **sway**(1)
- **sway-toolwait**: a python version of **toolwait**(1) - run a program and wait for a new window
- **sway-track-firefox**: when **firefox**(1) gets focus, bind Shift+Insert to paste PRIMARY
- **sway-track-prev-focus**: tracks focus changes in **sway**(1)
- **sway-vnc**: run a VNC connection to a remote system, starting **wayvnc*(1) and/or **sway**(1) if necessary
- **toggle-devices**: display a bunch of buttons and take appropriate actions on pressing them
- **toggle-easyeffects**: run easyeffects if not running; else kill it
- **toolwait**: a bash version of **toolwait**(1) - run a program and wait for a change in the windows
- **xcheck**: run a GUI command (incl Wayland) capturing stdout and stderr.

<!-- 
Local Variables:
mode: gfm
markdown-command: "pandoc -s -f gfm --metadata title=README"
eval: (add-hook 'after-save-hook (lambda nil (shell-command (concat markdown-command " README.md > README.html"))) nil 'local)
End:
-->

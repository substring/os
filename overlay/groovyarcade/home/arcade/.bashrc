MYTTY=$(tty)
if [ "$MYTTY" = "/dev/tty1" ]; then
    sudo setterm -powerdown 0 -powersave off -blank 0
    sudo gasetup
fi
alias ls='ls --color=auto'
alias startx="startx -- vt7"

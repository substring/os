#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\033[48;2;250;40;40;249m\] \[\033[48;2;100;220;70;249m\] \[\033[48;2;50;90;200;249m\] \e[m[\u@\h \W]\$ '

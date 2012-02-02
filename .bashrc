#--------- Mac vs Non-Mac ENV Variables --------#

if [ `uname` == 'Darwin' -a `whoami` == 'sparky' ]; then
	#Crosspack MAN Files
	if [ -d /usr/local/CrossPack-AVR/man ]; then
		export MANPATH=/usr/local/CrossPack-AVR/man:$MANPATH
	fi

	#ARM Compile Tools
	if [ -d /usr/local/arm-cs-tools/bin ]; then
		export PATH=/usr/local/arm-cs-tools/bin:$PATH
	fi

	#XTerm (Octave and GnuPlot)
	export GNUTERM='x11'

	#SVN diff/merge tool
	export SVN_MERGE=fmdiff

	#Editor
	export EDITOR='subl -w'

	#Mac Aliases
	alias wmate='mate -w'
	alias wsubl='subl -w'

	alias eagle='/Applications/EAGLE/EAGLE.app/Contents/MacOS/EAGLE&'

	alias ls='ls -hlG'
	alias l='ls -hlG'
	alias la='ls -ahlG'
else
	#EDITOR
	export EDITOR='vi'

	alias ls='ls -hl --color'
	alias l='ls -hl --color' 
	alias la='ls -ahl --color'
fi


#--------- Homebrew stuff --------#

if [ `which brew` ]; then
	#Brew path settings (should be last to alter the PATH
	export PATH=/usr/local/share/python:/usr/local/bin:/usr/local/sbin:$PATH

	#Brew bash_completion
	if [ -f `brew --prefix`/etc/bash_completion ]; then
		. `brew --prefix`/etc/bash_completion
	fi
fi

#--------- Prompt --------#

function parse_git_dirty() {
	if [ `which git` ]; then
		[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
	fi
}

function parse_git_branch() {
	if [ `which git` ]; then
		git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ \1$(parse_git_dirty)/"
	fi
}

if [ `uname` == 'Darwin' -a `whoami` == 'sparky' ]; then
	export PS1="\[\e[1;31m\][\[\e[0;37m\]\W\[\e[1;33m\]\$(parse_git_branch)\[\e[1;31m\]]\[\e[0m\] "
	export PS2="\[\e[1:31m\] >\[\e[0m\] "
else
	export PS1="\[\e[1;36m\][\[\e[0;37m\]\W\[\e[1;33m\]\$(parse_git_branch)\[\e[1;36m\]]\[\e[0m\] "
	export PS2="\[\e[1:36m\] >\[\e[0m\] "
fi

#--------- Handy Functions --------#

function muxx() {
	tmux new-session -d -s muxx -n scratch
	tmux split-window -p 20 python
	tmux split-window -h -p 20
	tmux clock-mode -t scratch.2
	tmux attach-session -t muxx
}

#--------- Generic Aliases and Bash Stuff --------#

shopt -s cdspell
shopt -s nocaseglob

alias vi='vim'

alias ..='cd ..'
alias c='clear'
alias p='cd ~/Projects/'

#avrdude
alias usbasp='avrdude -c usbasp -P usb'
alias usbtiny='avrdude -c usbtiny -P usb'
alias mk2='avrdude -c avrispmkII -P usb'

#Screen
alias pirate='screen -t "BusPirate" /dev/tty.usbserial-A700e6Gc 115200'

#--------- ASCII Art --------#

alias cherry='echo "                       8888  8888888
                  888888888888888888888888
               8888:::8888888888888888888888888
             8888::::::8888888888888888888888888888
            88::::::::888:::8888888888888888888888888
          88888888::::8:::::::::::88888888888888888888
        888 8::888888::::::::::::::::::88888888888   888
           88::::88888888::::m::::::::::88888888888    8
         888888888888888888:M:::::::::::8888888888888
        88888888888888888888::::::::::::M88888888888888
        8888888888888888888888:::::::::M8888888888888888
         8888888888888888888888:::::::M888888888888888888
        8888888888888888::88888::::::M88888888888888888888
      88888888888888888:::88888:::::M888888888888888   8888
     88888888888888888:::88888::::M::;o*M*o;888888888    88
    88888888888888888:::8888:::::M:::::::::::88888888    8
   88888888888888888::::88::::::M:;:::::::::::888888888
  8888888888888888888:::8::::::M::aAa::::::::M8888888888       8
  88   8888888888::88::::8::::M:::::::::::::888888888888888 8888
 88  88888888888:::8:::::::::M::::::::::;::88:88888888888888888
 8  8888888888888:::::::::::M::\"@@@@@@@\"::::8w8888888888888888
  88888888888:888::::::::::M:::::\"@a@\":::::M8i888888888888888
 8888888888::::88:::::::::M88:::::::::::::M88z88888888888888888
8888888888:::::8:::::::::M88888:::::::::MM888!888888888888888888
888888888:::::8:::::::::M8888888MAmmmAMVMM888*88888888   88888888
888888 M:::::::::::::::M888888888:::::::MM88888888888888   8888888
8888   M::::::::::::::M88888888888::::::MM888888888888888    88888
 888   M:::::::::::::M8888888888888M:::::mM888888888888888    8888
  888  M::::::::::::M8888:888888888888::::m::Mm88888 888888   8888
   88  M::::::::::::8888:88888888888888888::::::Mm8   88888   888
   88  M::::::::::8888M::88888::888888888888:::::::Mm88888    88
   8   MM::::::::8888M:::8888:::::888888888888::::::::Mm8     4
       8M:::::::8888M:::::888:::::::88:::8888888::::::::Mm    2
      88MM:::::8888M:::::::88::::::::8:::::888888:::M:::::M
     8888M:::::888MM::::::::8:::::::::::M::::8888::::M::::M
    88888M:::::88:M::::::::::8:::::::::::M:::8888::::::M::M
   88 888MM:::888:M:::::::::::::::::::::::M:8888:::::::::M:
   8 88888M:::88::M:::::::::::::::::::::::MM:88::::::::::::M
     88888M:::88::M::::::::::*88*::::::::::M:88::::::::::::::M
    888888M:::88::M:::::::::88@@88:::::::::M::88::::::::::::::M
    888888MM::88::MM::::::::88@@88:::::::::M:::8::::::::::::::*8
    88888  M:::8::MM:::::::::*88*::::::::::M:::::::::::::::::88@@
    8888   MM::::::MM:::::::::::::::::::::MM:::::::::::::::::88@@
     888    M:::::::MM:::::::::::::::::::MM::M::::::::::::::::*8
     888    MM:::::::MMM::::::::::::::::MM:::MM:::::::::::::::M
      88     M::::::::MMMM:::::::::::MMMM:::::MM::::::::::::MM
      88    MM:::::::::MMMMMMMMMMMMMMM::::::::MMM::::::::MMM
        88    MM::::::::::::MMMMMMM::::::::::::::MMMMMMMMMM
         88   8MM::::::::::::::::::::::::::::::::::MMMMMM"'

alias truck='echo "
                            _,..=xxxxxxxxxxxx,
                           /L_Y.=\"\"\"\"\"\"\"\"\"\`,--n.
            .........      .--\"[=======]|| |  []\\         .........
    ................       |  _   _     ||   _   |         ................
                           \"-(_)-(_)--------(_)--\"

"'

##### RUN COMMANDS BEFORE START #####

truck #draw a pretty picture

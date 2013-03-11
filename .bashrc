#--------- Mac vs Non-Mac ENV Variables --------#

if [[ `uname` == 'Darwin' ]]; then
	if [[ -z $BASHCONFIGD ]]; then
		#Crosspack Files
		if [[ -d /usr/local/CrossPack-AVR/man ]]; then
			export MANPATH=/usr/local/CrossPack-AVR/man:$MANPATH
			export PATH=/usr/local/Crosspack-AVR/bin:$PATH
		fi

		#ARM Compile Tools
		if [[ -d /usr/local/arm-cs-tools/bin ]]; then
			export PATH=/usr/local/arm-cs-tools/bin:$PATH
		fi

		#Latex Tools
		if [[ -d /usr/texbin ]]; then
			export PATH=/usr/texbin:$PATH
		fi


		#--------- Go Lang --------#

		if [[ `command -v go` ]]; then
			if [[ -d /usr/local/opt/go && -d /usr/local/share/go ]]; then
				export GOROOT='/usr/local/opt/go':$GOROOT
				export GOPATH='/Users/sparky/Projects/rter/prototype/server':$GOPATH
				export GOPATH='/Users/sparky/Projects/go':$GOPATH
				export GOPATH='/usr/local/share/go':$GOPATH
				for i in ${GOPATH//:/ }; do
					export PATH=$i/bin:$PATH
				done
			fi
		fi

		#--------- Homebrew stuff --------#

		#Brew path settings (should be last to alter the PATH)
		export PATH=/usr/local/share/npm/bin:$PATH
		export PATH=/usr/local/share/python:/usr/local/sbin:/usr/local/bin:$PATH
	fi;

	#XTerm (Octave and GnuPlot)
	export GNUTERM='x11'

	#SVN diff/merge tool
	if [[ `command -v fmdiff` ]]; then
		export SVN_MERGE=fmdiff
	fi

	#Mac Aliases
	if [[ `command -v /Applications/EAGLE/EAGLE.app/Contents/MacOS/EAGLE` ]]; then
		alias eagle='/Applications/EAGLE/EAGLE.app/Contents/MacOS/EAGLE&'
	fi

	if [[ `command -v subl` ]]; then
		alias s='subl'
	fi

	alias ls='ls -hlG'
	alias l='ls -hlG'
	alias la='ls -ahlG'
	
	#Screen
	alias pirate='screen -t "BusPirate" /dev/tty.usbserial-A700e6Gc 115200'

	if [[ `command -v brew` ]]; then
		#Brew bash_completion
		if [[ -f `brew --prefix`/etc/bash_completion ]]; then
			. `brew --prefix`/etc/bash_completion
		fi
	fi
else
	alias ls='ls -hl --color'
	alias la='ls -ahl --color'
	alias l='ls -hl --color' 

	if [[ -f /etc/bash_completion ]]; then
		. /etc/bash_completion
	fi
fi

#--------- Oddities --------#

function parse_git_dirty() {
	if [[ `command -v git` ]]; then
		[[ $(git status --porcelain 2> /dev/null) != "" ]] && echo "*"
	fi
}

function parse_git_branch() {
	if [[ `command -v git` ]]; then
		git branch 2> /dev/null | awk '($1 ~ /\*/) && ($2 !~ /master/) {for(i=2;i<=NF;i++) {{printf "%s%s", (i>2?" ":""), $i}}}'
	fi
}

function parse_svn_dirty() {
	if [[ `command -v svn` ]]; then
		[[ $(svn status 2> /dev/null) != "" ]] && echo "*"
	fi
}

#--------- Prompt --------#

PROMPT_COLOR="\[\e[0;31m\]" #Red
TEXT_COLOR="\[\e[0;37m\]"

if [[ `uname` == 'Darwin' ]]; then
	if [[ `scutil --get ComputerName | cut -d . -f 1 | grep -i 0x0C` ]]; then
		PROMPT_COLOR="\[\e[0;36m\]" #Cyan
	elif [[ `scutil --get ComputerName | cut -d . -f 1 | grep -i 0x0A` ]]; then
		PROMPT_COLOR="\[\e[0;33m\]" #Yellow
	fi
fi

export PS1="$PROMPT_COLOR[\h$TEXT_COLOR \W$PROMPT_COLOR]\[\e[0m\] "
export PS2="$PROMPT_COLOR >\[\e[0m\] "


#--------- Generic Aliases and Shell Stuff --------#

export EDITOR='vi'
export AVR_ISP='dragon_isp'

shopt -s cdspell
shopt -s nocaseglob

if [[ `command -v vim` ]]; then
	alias vi='vim'
fi

alias ..='cd ..'
alias c='clear'
alias p='cd ~/Projects/'

#avrdude
if [[ `command -v avrdude` ]]; then
	alias usbasp='avrdude -c usbasp -P usb'
	alias usbtiny='avrdude -c usbtiny -P usb'
	alias mk2='avrdude -c avrispmkII -P usb'
	alias dragon='avrdude -c dragon_isp -P usb'
fi

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

export BASHCONFIGD=true

truck #draw a pretty picture

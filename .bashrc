if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

##### ENV VARIABLES #####

#SPICE
export SPICE_ASCIIRAWFILE=1

#SuperCollider
export PATH=/Applications/SuperCollider:$PATH

#EDITOR
#export EDITOR='vi'
export EDITOR='mate -w'

#TERMINAL (Octave and GnuPlot)
export GNUTERM='x11'

#PROMPT
function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ \1$(parse_git_dirty)/"
}

export PS1="\[\e[1;31m\][\[\e[0;37m\]\W\[\e[1;33m\]\$(parse_git_branch)\[\e[1;31m\]\[\e[1;31m\]]\[\e[0m\] "
export PS2="\[\e[1:31m\] >\[\e[0m\] "

#GO
export GOROOT=/usr/local/Cellar/go/HEAD
export GOBIN=/usr/local/Cellar/go/HEAD/bin
export GOSRC=/usr/local/Cellar/go/HEAD/src

#BREW
export PATH=/usr/local/share/python:/usr/local/bin:/usr/local/sbin:/usr/local/Cellar/go/HEAD/bin:$PATH

#SVN
export SVN_MERGE=fmdiff

shopt -s nocaseglob

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# [ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2)" scp sftp ssh

##### ALIASES #####

#General
alias ls='ls -hlG'
alias l='ls -hlG'
alias la='ls -ahlG'

alias ..='cd ..'
alias c='clear'

alias p='cd ~/Projects/'

alias wmate='mate -w'

alias eagle='/Applications/EAGLE/EAGLE.app/Contents/MacOS/EAGLE&'

alias usbasp='avrdude -c usbasp -P usb'
alias usbtiny='avrdude -c usbtiny -P usb'

#Screen
alias pirate='screen -t "BusPirate" /dev/tty.usbserial-A700e6Gc 115200'

#Screen + SSH
alias sair='screen -t "Air" ssh air'
alias simac='screen -t "0x0A" ssh imac'
alias shome='screen -t "0x0A" ssh home'

alias ssbd='screen -t "SbD" ssh sbd'

alias scim='screen -t "CIM" ssh cim'
alias sbach='screen -t "Bach" ssh bach'
alias snightcap='screen -t "NightCap" ssh nightcap'
alias sferrari='screen -t "Ferrari" ssh ferrari'

alias scitec='screen -t "CITEC" ssh citec'

alias smcgillcs='screen -t "McGill CS" ssh mcgillcs'
alias smcgillece='screen -t "McGill ECE" ssh mcgillece'

alias smcgilleus='screen -t "EUS" ssh eus'

#Screen + FUSE
# alias mntcim='mkdir ~/CIM;sshfs cim:/home/sre/sparky/ ~/CIM -oauto_cache,reconnect,volname=CIM'
# alias umntcim='umount ~/CIM;rmdir ~/CIM'
# 
# alias mnteus='mkdir ~/EUS;sshfs eus:/srv/http/thefactory/ ~/EUS -oauto_cache,reconnect,volname=EUS'
# alias umnteus='umount ~/EUS;rmdir ~/EUS'
# 
# alias mntsbd='mkdir ~/SBD;sshfs sbd:/home/28445/users/.home/domains/smallbutdigital.com/html/ ~/SBD -oauto_cache,reconnect,volname=SBD'
# alias umntsbd='umount ~/SBD;rmdir ~/SBD'
# 
# alias mnthci='mkdir ~/HCI;sshfs sbd:/home/28445/users/.home/domains/hci.smallbutdigital.com/html/wp-content/themes/hci/ ~/HCI -oauto_cache,reconnect,volname=HCI'
# alias umnthci='umount ~/HCI;rmdir ~/HCI'

# example() {
#     if [ -n "${1:-}" ]; then
#         echo $1
#     fi
# }

##### ASCII ART #####

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

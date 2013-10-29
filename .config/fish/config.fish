#--------- Mac vs Non-Mac ENV Variables --------#

if test ! $FISHCONFIGD;
	set -xg MANPATH (man --path) $MANPATH
end;

if test (uname) = "Darwin";
	if test ! $FISHCONFIGD;
		#Crosspack Files
		if test -d /usr/local/CrossPack-AVR;
			set -xg MANPATH /usr/local/CrossPack-AVR/man $MANPATH;
			set -xg PATH /usr/local/CrossPack-AVR/bin $PATH;
		end;

		#ARM Compile Tools
		if test -d /usr/local/arm-cs-tools/bin;
			set -xg PATH /usr/local/arm-cs-tools/bin $PATH;
		end;

		#Latex Tools
		if test -d /usr/texbin;
			set -xg PATH /usr/texbin $PATH;
		end;

		if which go ^&1 >&-;
			#--------- Go Lang --------#
			set -xg GOROOT /usr/local/opt/go $GOROOT
			set -xg GOPATH /Users/sparky/Projects/rter/prototype/server $GOPATH
			set -xg GOPATH /Users/sparky/Projects/rter/prototype/videoserver $GOPATH
			set -xg GOPATH /Users/sparky/Projects/go $GOPATH
			set -xg GOPATH /usr/local/share/go $GOPATH
			for i in $GOPATH;
				set -xg PATH $i/bin $PATH;
			end;
		end;

		#--------- Android stuff --------#

		if test -d /android/sdk;
			set -xg PATH $PATH /android/sdk/tools;
			set -xg PATH $PATH /android/sdk/platform-tools;
		end;

		if test -d /android/ndk;
			set -xg PATH $PATH /android/ndk;
		end;

		#--------- Homebrew stuff --------#
		#Brew path settings (should be last to alter the PATH)
		set -xg PATH /usr/local/share/npm/bin $PATH;
		set -xg PATH /usr/local/bin $PATH;
		set -xg PATH /usr/local/sbin $PATH;
		#set -xg PATH /usr/local/share/python $PATH;

	end;

	#XTerm (Octave and GnuPlot)
	set -xg GNUTERM 'x11';

	#SVN diff/merge tool
	if which fmdiff ^&1 >&-;
		set -xg SVN_MERGE fmdiff;
	end;

	#Mac Aliases
	if test -x /Applications/EAGLE/EAGLE.app/Contents/MacOS/EAGLE;
		function eagle; /Applications/EAGLE/EAGLE.app/Contents/MacOS/EAGLE&; end;
	end;

	if which subl ^&1 >&-;
		function s; subl $argv; end;
	end;

	if which subl2 ^&1 >&-;
		function s2; subl2 $argv; end;
	end;

	if which subl3 ^&1 >&-;
		function s3; subl3 $argv; end;
	end;

	function ls; command ls -hlG $argv; end;
	function l; ls -hlG $argv; end;
	function la; ls -ahlG $argv; end;

	#Screen
	function pirate; 
		screen -t "BusPirate" /dev/tty.usbserial-A700e6Gc 115200;
	end;
else;
	function ls; command ls -hl --color $argv; end;
	function la; ls -ahl --color $argv; end;
	function l; ls -hl --color $argv; end;
end;

#--------- Oddities --------#

function adb_minuum -d "Get all Minuum adb logcat results";
	adb logcat | grep --line-buffered -i '^[A-Za-z]/Minuum' | sed -l -E "s/^[A-Za-z]\/Minuum ([^:]*:[0-9]*)[^:]*:(.*)/\1~\2/g" | sed -l -e :a -e "s/^\(.\{1,60\}\)~\(.*\)\$/\1 ~\2/;ta" | sed -l -e "s/\(.*\)~\(.*\)/"(set_color yellow)"\1"(set_color normal)"\2/" | grep --line-buffered -i "$argv";
end;

function testz
	if count $argv > 0;
		echo "yes";
	else;
		echo "no";
	end;
end;

function parse_git_dirty -d "Return a marker if inside a dirty git repo";
	if which git ^&1 >&-;
		set -l result (git status --porcelain ^&-);
		if test -n "$result";
			printf "☐";
		end;
	end;
end;

function parse_git_branch -d "Return branch name if inside a git repo and the master branch is not checked out";
	if which git ^&1 >&-;
		set -l branch (git branch ^&- | awk '($1 ~ /\*/) && ($2 !~ /master/) {for(i=2;i<=NF;i++) {{printf "%s%s", (i>2?" ":""), $i}}}');
		printf "%s" $branch;
	end;
end;

function parse_svn_dirty -d "Return a marker if inside a dirty svn repo";
	if which svn ^&1 >&-;
		set -l result (svn status ^&-);
		if test -n "$result";
			printf "■";
		end;
	end;
end;

#--------- Prompt --------#

set prompt_color red
set text_color white
set anote_color yellow

if test (uname) = "Darwin";
	if scutil --get ComputerName | cut -d . -f 1 | grep -i 0x0C ^&1 >&-
		set prompt_color cyan;
	end;
	if scutil --get ComputerName | cut -d . -f 1 | grep -i 0x0A ^&1 >&-;
		set prompt_color yellow;
	end;
end;

function fish_prompt;
	set_color $prompt_color;

	if test (uname) = "Darwin";
		printf "[%s " (scutil --get ComputerName | cut -d . -f 1);
	else;
		printf "[%s " (hostname | cut -d . -f 1);
	end;

	set_color $text_color;
	printf "%s" (prompt_pwd);

	set_color $prompt_color;
	printf "] ";

	set_color normal;
end;

#--------- Generic Aliases and Shell Stuff --------#

set -xg CC gcc
set -xg EDITOR vi
set -xg AVR_ISP dragon_isp

if which avrdude ^&1 >&-;
	function vi; vim $argv; end;
end;

function ..; cd ..; end;
function c; clear; end;
function p; cd ~/Projects/; end;

#avrdude
if which avrdude ^&1 >&-;
	function usbasp; avrdude -c usbasp -P usb $argv; end;
	function usbtiny; avrdude -c usbtiny -P usb $argv; end;
	function mk2; avrdude -c avrispmkII -P usb $argv; end;
	function dragon; avrdude -c dragon_isp -P usb $argv; end;
end;

#--------- ASCII Art --------#

function cherry -d "Print a chick";
	echo "                       8888  8888888
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
         88   8MM::::::::::::::::::::::::::::::::::MMMMMM";
end;

function truck -d "Print a truck";
	echo "
                            _,..=xxxxxxxxxxxx,
                           /L_Y.=\"\"\"\"\"\"\"\"\"\`,--n.
            .........      .--\"[=======]|| |  []\\         .........
    ................       |  _   _     ||   _   |         ................
                           \"-(_)-(_)--------(_)--\"

";
end;

#truck;

set fish_greeting ""

set -xg FISHCONFIGD true

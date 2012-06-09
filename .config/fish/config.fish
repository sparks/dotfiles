#--------- Mac vs Non-Mac ENV Variables --------#

if test (uname) = "Darwin";
	#Crosspack MAN Files
	if test -d /usr/local/CrossPack-AVR/man;
		set MANPATH /usr/local/CrossPack-AVR/man $MANPATH
	end;

	#ARM Compile Tools
	if test -d /usr/local/arm-cs-tools/bin;
		set PATH /usr/local/arm-cs-tools/bin $PATH
	end;

	#XTerm (Octave and GnuPlot)
	set GNUTERM 'x11'

	#SVN diff/merge tool
	if hash fmdiff;
		set SVN_MERGE fmdiff
	end;

	if hash subl;
		function s; subl $argv; end;
	end;

	function ls; ls -hlG $argv; end;
	function l; ls -hlG $argv; end;
	function la; ls -ahlG $argv; end;

	#Screen
	function pirate; 
		screen -t "BusPirate" /dev/tty.usbserial-A700e6Gc 115200;
	end;

	#--------- Homebrew stuff --------#

	set PATH /usr/local/share/python /usr/local/bin /usr/local/sbin $PATH;
	#Brew path settings (should be last to alter the PATH)
else;
	function ls; ls -hl --color; end;
	function l; ls -hl --color; end;
	function la; ls -ahl --color; end;
end;

#--------- Prompt --------#
function parse_git_dirty;
	git diff --quiet HEAD ^&-;
	if test $status = 1;
		printf "☐";
	end;
end;

function parse_git_branch
	set -l branch (git branch ^&- | awk '($1 ~ /\*/) && ($2 !~ /master/) {print $2}');
	printf "%s" $branch;
end

set prompt_bracket_color yellow

if test (uname) = "Darwin";
	if test (hostname | cut -d . -f 1) = "0x0C";
		set prompt_bracket_color cyan;
	end;
	if test (hostname | cut -d . -f 1) = "0x0A";
		set prompt_bracket_color purple;
	end;
end;

function fish_prompt;
	set_color -o $prompt_bracket_color;
	printf "[";

	set_color normal;
	set_color white;
	printf "%s" (prompt_pwd);

	set_color yellow
	set -l branch (parse_git_branch)
	set -l dirty (parse_git_dirty)
	if test -n "$branch";
		printf " (%s)%s" $branch $dirty;
	else;
		if test -n "$dirty";
			printf " %s" $dirty;
		end;
	end;

	set_color -o $prompt_bracket_color;
	printf "] ";

	set_color normal;
end;

#--------- Generic Aliases and Bash Stuff --------#

set EDITOR vi
set AVR_ISP dragon_isp

function vi; vim; end;

function ..; cd ..; end;
function c; clear; end;
function p; cd ~/Projects/; end;

#avrdude
if hash avrdude;
	function usbasp; avrdude -c usbasp -P usb; end;
	function usbtiny; avrdude -c usbtiny -P usb; end;
	function mk2; avrdude -c avrispmkII -P usb; end;
	function dragon; avrdude -c dragon_isp -P usb; end;
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

set fish_greeting "
                            _,..=xxxxxxxxxxxx,
                           /L_Y.=\"\"\"\"\"\"\"\"\"\`,--n.
            .........      .--\"[=======]|| |  []\\         .........
    ................       |  _   _     ||   _   |         ................
                           \"-(_)-(_)--------(_)--\"

"
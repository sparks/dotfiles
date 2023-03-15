#--------- Mac vs Non-Mac ENV Variables --------#

if test -f ~/.config/fish/secrets.fish;
	source ~/.config/fish/secrets.fish
end;

set -xg WHIRLSCAPE_KEYSTORE /Users/sparky/Documents/Whirlscape/keystores/whirlscape.keystore
set -xg WHIRLSCAPE_P12 /Users/sparky/Documents/Whirlscape/keystores/whirlscape-play-key.p12

set -xg HEADSPIN_HOME /Users/sparky/headspinio;

set -xg MANPATH (man --path) $MANPATH

if test (uname) = "Darwin";
	set -xg PATH "/Applications/Sublime Text.app/Contents/SharedSupport/bin" $PATH;

	set -xg PATH /Users/sparky/Library/Android/sdk/platform-tools $PATH;
	
	#Brew path settings (should be last to alter the PATH)
	# set -xg PATH /opt/homebrew/bin $PATH;
	# set -xg PATH /opt/homebrew//sbin $PATH;

	# set -xg PATH /opt/homebrew/opt/mysql@5.7/bin $PATH;
	/opt/homebrew/bin/brew shellenv | source


	if type -q pyenv;
		status is-login; and pyenv init --path | source
		pyenv init - | source
	end;

	if type -q subl;
		function s;
			if test -d $argv[1];
				for result in (find "$argv[1]" -iname "*.sublime-project" -maxdepth 1 | head -n 1)
		            subl $result
		            return 0;
		        end
		    end;
	        
			subl $argv;
		end;
	end;

	function ls; command ls -hlG $argv; end;
	function l; ls -hlG $argv; end;
	function la; ls -ahlG $argv; end;

	function tclip -d "Copy tmux clipboard to system clipboard";
		tmux showb | pbcopy
	end;

else;
	function ls; command ls -hl --color $argv; end;
	function la; ls -ahl --color $argv; end;
	function l; ls -hl --color $argv; end;
end;

#--------- Oddities --------#

function findrm -d "delete files in subdirs using find";
	find ./ -iname "$argv" -exec rm \{\} \;;
end;

function gerbermv -d "reorganize gerber files after an eagle cam job";
	mkdir gerber
	rm ./*.*#*
	mv ./*.* gerber
	mv gerber/*.sch gerber/*.brd .
	rm gerber/*.dri gerber/*.gpi
	cp ~/Projects/md/gerber/README.txt ./gerber
	gerbv gerber/*
end;

function aadb
	set -l avail_devices
	set -l final_device

	for i in (adb devices | tail -n +2 | tail -r | tail -n +2 | tail -r | awk '{print $1}')
		set avail_devices $avail_devices $i
	end

	function prompt_text
		echo "Please select device index to use: "
	end

	if test (count $avail_devices) -eq 0
		echo "No devices connected"
		return;
	else if test (count $avail_devices) -gt 1
		set -l final_device_index -1
		while test $final_device_index -lt 1 -o $final_device_index -gt (count $avail_devices)
			echo "Available devices:"
			for i in (seq (count $avail_devices))
				echo $i: $avail_devices[$i]
			end
			read -l -p prompt_text index
			set final_device_index $index
		end
		set final_device $avail_devices[$final_device_index]
	else
		set final_device $avail_devices[1]
	end

	adb -s $final_device $argv
end

function phonecap -d "grab a screen capture from a connected android phone";
	# adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $argv;
	adb shell screencap -p > $argv;
end;

function diffsettings -d "diff android settings for a device";
	rm tmp_a tmp_b
	touch tmp_a tmp_b

	adb shell settings list system >> tmp_a
	adb shell settings list global >> tmp_a
	adb shell settings list secure >> tmp_a

	read

	adb shell settings list system >> tmp_b
	adb shell settings list global >> tmp_b
	adb shell settings list secure >> tmp_b
	diff tmp_a tmp_b
end;


function norig -d "remove all .orig files in the current directory tree";
	find ./ -iname "*.orig" -exec rm \{\} \+
	find ./ -iname "*_BACKUP_*" -exec rm \{\} \+
	find ./ -iname "*_BASE_*" -exec rm \{\} \+
	find ./ -iname "*_LOCAL_*" -exec rm \{\} \+
	find ./ -iname "*_REMOTE_*" -exec rm \{\} \+
end;

function lfsfix -d "Fix broken LFS file pointers, WARNING will reset hard";
	git lfs uninstall
	git reset --hard
	git lfs install
	git lfs pull
end;

function tmp -d "upload to the tmp dir on my webserver"
	if test (count $argv) -gt 0;
		scp -r $argv sbd:~/domains/smallbutdigital.com/html/tmp
		set -l JOIN
		for arg in $argv
			set JOIN (echo -e "http://www.smallbutdigital.com/tmp/$arg\n$JOIN")
		end;
		echo -n $JOIN
		echo -n $JOIN | pbcopy
	else;
		echo "tmp requires some files";
	end;
end;

function pushover -d "push notification to my phone"
	curl -s \
	  --form-string "token=aXccxuskjLM5AX2N5Xye9jm7KtDJa4" \
	  --form-string "user=$PUSH_OVER_USER_TOKEN" \
	  --form-string "message=$argv" \
	  https://api.pushover.net/1/messages.json
end;

function adbpush -d "push to /Download on my phone"
	if test (count $argv) -gt 0;
		adb push $argv /storage/sdcard0/Download/
	else;
		echo "push requires some files";
	end;
end;

function parse_git_dirty -d "Return a marker if inside a dirty git repo";
	if type -q git;
		set -l result (git status --porcelain ^&-);
		if test -n "$result";
			printf "☐";
		end;
	end;
end;

function parse_git_branch -d "Return branch name if inside a git repo and the master branch is not checked out";
	if type -q git;
		set -l branch (git branch ^&- | awk '($1 ~ /\*/) && ($2 !~ /master/) {for(i=2;i<=NF;i++) {{printf "%s%s", (i>2?" ":""), $i}}}');
		printf "%s" $branch;
	end;
end;

#--------- Prompt --------#

set prompt_color red
set text_color white
set anote_color yellow

if test (uname) = "Darwin";
	if scutil --get ComputerName | cut -d . -f 1 | grep -i -E "sonny" -q;
		set prompt_color yellow
	end;
	if scutil --get ComputerName | cut -d . -f 1 | grep -i 0x0C -q;
		set prompt_color cyan;
	end;
	if scutil --get ComputerName | cut -d . -f 1 | grep -i -E "dexter" -q;
		set prompt_color ff8402;
	end;
	if scutil --get ComputerName | cut -d . -f 1 | grep -i -E "ornette" -q;
		set prompt_color cyan;
	end;
	if scutil --get ComputerName | cut -d . -f 1 | grep -i 0x0A -q;;
		set prompt_color yellow;
	end;
end;

function fish_prompt;
	if set -q VIRTUAL_ENV
		set_color yellow;
		printf "(%s) " (basename "$VIRTUAL_ENV");
	end

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

function timer;
	utimer -c $argv[1]m;
	say $argv[2..-1];
end;

#--------- Generic Aliases and Shell Stuff --------#

set -xg EDITOR vi
set -xg AVR_ISP dragon_isp

function ..; cd ..; end;
function c; clear; end;
function p; cd ~/Projects/; end;

function hs;
	cd ~/headspinio/;
	source activate.fish
end;

function hsi;
	cd ~/Projects/contract/headspin;
end;


#avrdude
if type -q avrdude;
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


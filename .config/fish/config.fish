#--------- Mac vs Non-Mac ENV Variables --------#

source ~/.config/fish/secrets.fish

set -xg WHIRLSCAPE_KEYSTORE /Users/sparky/Documents/Whirlscape/keystores/whirlscape.keystore
set -xg WHIRLSCAPE_P12 /Users/sparky/Documents/Whirlscape/keystores/whirlscape-play-key.p12

set -xg MANPATH (man --path) $MANPATH

if test (uname) = "Darwin";
	#Latex Tools
	if test -d /usr/local/esp;
		set -xg PATH /usr/local/esp/toolchain/xtensa-esp32-elf/bin/ $PATH;
		set -xg PATH /usr/local/esp/toolchain/bin/ $PATH;
		set -xg IDF_PATH /usr/local/esp/esp-idf/;
	end;

	if which go ^&1 >&-;
		#--------- Go Lang --------#
		# set -xg GOPATH /Users/sparky/Projects/rter/prototype/server;
		# set -xg GOPATH /Users/sparky/Projects/rter/prototype/videoserver:$GOPATH;
		# set -xg GOPATH /Users/sparky/Projects/whirlscape/MinuumWDK/download:$GOPATH;
		set -xg GOPATH /Users/sparky/Projects/go;
		set -xg GOPATH /usr/local/share/go:$GOPATH;
		# for i in $GOPATH;
		# 	set -xg PATH $i/bin $PATH;
		# end;
	end;

	#--------- Android stuff --------#

	if test -d /Application/Android/sdk;
		set -xg PATH $PATH /Application/Android/sdk/tools;
		set -xg PATH $PATH /Application/Android/sdk/platform-tools;
	end;

	if test -d /Application/Android/ndk;
		set -xg PATH $PATH /Application/Android/ndk;
		alias agp /Applications/Android/ndk/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-gprof
	end;

	#--------- Applications Android stuff --------#

	if test -d /Applications/Android/sdk;
		set -xg PATH $PATH /Applications/Android/sdk/tools;
		set -xg PATH $PATH /Applications/Android/sdk/platform-tools;
		set -xg PATH $PATH /Applications/Android/sdk/build-tools/23.0.3;
	end;

	if test -d /Applications/Android/ndk;
		set -xg PATH $PATH /Applications/Android/ndk;
	end;

	#--------- Homebrew stuff --------#
	#Brew path settings (should be last to alter the PATH)
	set -xg PATH /usr/local/bin $PATH;
	#set -xg PATH /usr/local/share/python $PATH;

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

function findrm -d "delete files in subdirs using find";
	find ./ -iname "$argv" -exec rm \{\} \;;
end;

function adb_minuum -d "Get all Minuum adb logcat results";
	adb logcat | grep --line-buffered -i '^[A-Za-z]/Minuum' | sed -l -E "s/^[A-Za-z]\/Minuum ([^:]*:[0-9]*)[^:]*:(.*)/\1~\2/g" | sed -l -e :a -e "s/^\(.\{1,60\}\)~\(.*\)\$/\1 ~\2/;ta" | sed -l -e "s/\(.*\)~\(.*\)/"(set_color yellow)"\1"(set_color normal)"\2/" | grep --line-buffered -i "$argv";
end;

function saydle -d "Gradle + say \"done\"";
	gradle $argv;
	set -l cached_status $status
	if test $cached_status = 0
		say -v "Daniel" "Build done"
	else
		say -v "Daniel" "Build failed"
	end
	return $cached_status
end

function sals -d "sls + say \"deployed\"";
	sls $argv;
	set -l cached_status $status
	if test $cached_status = 0
		say -v "Daniel" "Serverless deployed"
	else
		say -v "Daniel" "Serverless failed"
	end
	return $cached_status
end

function abe;
	java -jar /usr/local/abe/abe.jar $argv;
end;

function bakextrak;
	if test -e apps;
		echo "Directory ./apps already exists and I don't want to overwrite it";
		return 1;
	end;

	if test -e $argv;
		echo "Directory ./$argv already exists and I don't want to overwrite it";
		return 1;
	end;

	rm -rf tmp.ab
	adb backup -f tmp.ab $argv
	java -jar /usr/local/abe/abe.jar unpack tmp.ab tmp.tar
	tar -xf tmp.tar
	mv ./apps/$argv ./
	rmdir ./apps
	rm tmp.ab tmp.tar
end;

function layoutbounds;
	set enable "false"
	if test (adb shell getprop debug.layout | tr -d "\r\n") = "false";
		set enable "true"
	end;
	adb shell setprop debug.layout $enable;
	adb shell am force-stop (echo $argv | sed "s#/.*##");
	adb shell am start -n $argv
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

function lilyserver -d "Build lilypond file and open preview wherever file is saved";
	fswatch $argv | xargs -n1 -I '{}' sh -c "lilypond {}; open /Applications/Preview.app/"
end;

function phonecap -d "grab a screen capture from a connected android phone";
	adb shell screencap -p | perl -pe 's/\x0D\x0A/\x0A/g' > $argv;
end;

function norig -d "remove all .orig files in the current directory tree";
	find ./ -iname "*.orig" -exec rm \{\} \+
	find ./ -iname "*_BACKUP_*" -exec rm \{\} \+
	find ./ -iname "*_BASE_*" -exec rm \{\} \+
	find ./ -iname "*_LOCAL_*" -exec rm \{\} \+
	find ./ -iname "*_REMOTE_*" -exec rm \{\} \+
end;

function office-say -d "Say stuff in the office";
	ssh office-speakers "say $argv";
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

function push -d "push to /Download on my phone"
	if test (count $argv) -gt 0;
		adb push $argv /storage/sdcard0/Download/
	else;
		echo "push requires some files";
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
	if scutil --get ComputerName | cut -d . -f 1 | grep -i dexter ^&1 >&-
		set prompt_color cyan;
	end;
	if scutil --get ComputerName | cut -d . -f 1 | grep -i 0x0A ^&1 >&-;
		set prompt_color yellow;
	end;
	if scutil --get ComputerName | cut -d . -f 1 | grep -i ornette ^&1 >&-
		set prompt_color A0FF33;
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

function night;
	pmset displaysleepnow
end;

function timer;
	utimer -c $argv[1]m;
	say $argv[2..-1];
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

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
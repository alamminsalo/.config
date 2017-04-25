#!/usr/bin/fish

function quit
	exit
end

#function vim
#	nvim $argv
#end

function editkeys
	vim ~/.config/sxhkd/sxhkdrc
end

# Terminal notifier
# ! install xdotool first - it is needed to check if the terminal is in foreground (or disable that if you don't want)
# then append this to ~/.config/fish/config.fish (create it if not existent)
function alert_cmd_done --on-event fish_postexec
	set status_code $status # save for later
	set active_window (ps -p (xdotool getwindowpid (xdotool getactivewindow)) -o comm=) # get the process name of the currently active window
	if status --is-interactive # Check for interactive session (keyboard attached)
		if [ $active_window != urxvt -a \
			$CMD_DURATION -a \
			$CMD_DURATION -gt (math "1000 * 5") ] # in background, after a job longer than 5 seconds
            set secs (math "$CMD_DURATION / 1000")
			if [ $status_code = 0 ]
				notify-send -i "terminal" "Job completed in "$secs"s" "$argv[1]"
			else # increase timeout to 4s, and use error icon
				notify-send -i "dialog-error" "Exit code $status_code after "$secs"s" "$argv[1]"
			end
		end
	end
end


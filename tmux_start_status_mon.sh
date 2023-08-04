#!/bin/bash
#V1.0-initial script, lots of tweaking

#@TODO-get to work
FOLDER="/opt/lora_logger"

#tmux doesn't work at boot @TODO-figure out WHY
# Create a new session with the script we want to run
tmux new-session -d -s status_mon '/opt/lora_logger/resource_monitor.sh'

# Split the window into panes and run status commands
#I think format is: -t [session].[window].[pane] @TODO-double check
#sleep .1
tmux split-window -v -t status_mon:0 'tail -f serial_log_python_lora_V1.1.txt'
#tmux split-window -h -t status_mon:0
tmux split-window -h -t status_mon:0 'htop'
tmux select-pane -t status_mon:0.0
#@TODO-figure out why this has a problem starting all commands with atop
tmux split-window -h -t status_mon:0 'journalctl -u lora_startup'
#tmux split-window -h -t status_mon:0
tmux attach-session -t status_mon

#this doesn't hit enter
#tmux send-keys -t status_mon:0.0 'python ~/lora_python_log_serialV1.1.py'

exit




#if running from ~/.tmux.conf
# Set the default prefix key to Ctrl+a (optional, if you prefer something other than the default Ctrl+b)
#unbind C-b
#set-option -g prefix C-a

# Example configuration for starting tmux with a specific layout and commands
# Note: Use "C-m" for Enter and "C-c" for Ctrl+C in the send-keys command

split-window -v #split vertically
split-window -h #now in the bottom pane
select-pane -t 0 #go back up to the top
split-window -h #split horizontal

# Send commands to the panes (starts at -t 0)
#send-keys -t 0 'python ~/lora_python_log_serialV1.1.py' C-m     # Replace 'your_script.sh' with the path to your script
send-keys -t 1 'opt/lora_logger/resource_monitor.sh' C-m
send-keys -t 2 'htop' C-m
send-keys -t 3 'atop' C-m
#send-keys -t 0 'your_script.sh' C-m     # Replace 'your_script.sh' with the path to your script

# Set the default pane
#select-pane -t 0

# Attach to the tmux session
#attach-session -t status_mon

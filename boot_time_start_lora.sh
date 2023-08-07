#!/bin/bash
#V1.0-initial startup script

#@TODO-get this to work
#FOLDER="/opt/lora_logger"

FILE="/opt/lora_logger/DEBUG-ran_boot_script_$(date +'%Y-%m-%d_%H-%M-%S').debug"
echo "output of id -a below" >> $FILE
echo $(id -a) >> $FILE
echo "output of PATH below" >> $FILE
echo $PATH >> $FILE
echo "output of pwd below" >> $FILE
echo $(pwd) >> $FILE
echo $(type python) >> $FILE
echo $(type tmux) >> $FILE


#@TODO- add command to sync time
python /opt/lora_logger/lora_python_log_serial_CURRENT.py

echo "done running at this time:" >> $FILE
echo $(date) >> $FILE


exit

echo "done running SHOULD NEVER GOTO HERE" >> $FILE
echo $(date) >> $FILE

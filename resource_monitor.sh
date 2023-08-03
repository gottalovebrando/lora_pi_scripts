#!/bin/bash

<<comment
Author-Brand~o
V 1.1
Dec 2021
https://elinux.org/RPI_vcgencmd_usage
https://www.raspberrypi.org/documentation/raspbian/applications/vcgencmd.md

@TODO-play around with values from vcgencmd otp_dump
https://github.com/jriwanek/RaspberryPi/wiki/OTP
comment

while [ true ]; do

#echo "system voltages:"
for id in sdram_c sdram_i sdram_p core ; do \
  echo -e "$id:\t$(vcgencmd measure_volts $id)" ; \
done

echo -n -e '\n'

echo "Clock speeds:"
for src in core arm h264 isp v3d uart pwm emmc pixel vec hdmi dpi ; do \
  echo -e "$src:\t$(vcgencmd measure_clock $src)" ; \
  #code from reference -e=enables interpretation of backslash escapes
done

echo -n -e '\n'

#echo "Use of CPU, RAM, SWAP and file systems with GBs of space:"
#https://askubuntu.com/questions/726333/how-to-save-htop-output-to-file
#original command: top -b -n1 > top.txt
#before first time running this script, run top and press m, then t, then W
#@TODO-automate pressing m (bar graph of memory) then t (bargraph CPU) then W (save) while htop running
# Wrote configuration to '/home/pi/.config/procps/toprc'
echo "@TODO- this seems to result in rather high estimates of CPU, %Cpu(s):  xx.x/xx.x   %USE[|..., Mem : %USE/TOTAL, Swap: %USE/TOTAL" 
top -b -n1 | grep -e Cpu -e Mem -e Swap
df -h | grep -e G -e Use%

echo -n -e '\n'

echo "Soft throttle:60C (not done on pi zero) Hard throttle:80C (https://www.raspberrypi.org/blog/thermal-testing-raspberry-pi-4/)"
vcgencmd measure_temp

echo -n -e '\n'

echo "FORMAT of below 'throttled=0xY000X' X=current occuring Y=in past, bit0=undervolt, bit1=freq cap, bit2=throttled, bit3=soft temp limit"
#echo "verbose:"
#echo "If X is greater than zero, either undervolt (bit 0), frequency capped (bit 1), throttled (bit 2), or soft temp limit (bit 3) is currently occuring."
#echo "If Y is greater that zero, one or more of the above has occured in the past"
#echo "To figure out which, convert X or Y to binary and look at which bit number(s) are high"
vcgencmd get_throttled
#@TODO-get below to work better
#first remove the text 'throttled=0x' from the vcgencmd:
#https://stackoverflow.com/questions/41594625/how-to-isolate-part-of-a-line-of-text-in-order-to-use-it-as-a-variable
#vcgencmd get_throttled | grep -oP 'throttled=\K[^ ]*'
#then convert to binary (but this part is work in progress):
#https://unix.stackexchange.com/questions/82561/convert-a-hex-string-to-binary-and-send-with-netcat
#ORIGINAL COMMAND:$ echo '0006303030304e43' | xxd -r -p | nc -l localhost 8181
#-r | -revert              Reverse operation: convert (or patch) hexdump into binary. (NEEDS TO BE FIRST?)
#-b | -bits              Switch  to bits (binary digits) dump
#-p | -ps | -postscript | -plain              Output  in postscript continuous hexdump style. Also known as plain hexdump style.
echo "(work in progress) FORMAT of below '00000000: 0011dcba 00110000 00110000 0011DCBA 00001010 ... HEX.' uppercase=currenty occuring"
echo "lowercase=in past. bit0 or A=undervolt, bit1 or B=freq cap, bit2 or C=throttled, bit3 or D=soft temp limit"
vcgencmd get_throttled | grep -oP 'throttled=0x\K[^ ]*' | xxd -b

echo "sleeping 10 seconds..."
sleep 10s

clear

done

read -p "how did you make it to here? press any key to exit"

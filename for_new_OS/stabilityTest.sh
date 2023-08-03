#!/bin/bash
#Simple stress test for system. If it survives this, it's probably stable.
#Free software, GPL2+
#V1.1
#modified by Brand~o

#@TODO- add better handling of 2-SIGINT and 15-SIGTERM
echo "Running simple stress test for system. If you press CTRL-C ****BE SURE**** to run:"
echo "killall yes"
echo "rm deleteme.dat"
echo "to clean up!"
echo -n -e '\n'
echo "If program finishes on its own, it will clean up when it is done."
echo -n -e '\n'
echo "Maxing out all CPU cores (by running command 'yes' for entire test) Heats it up, loads the power-supply."
for ((i=0; i<$(nproc --all); i++)); do nice yes >/dev/null & done

echo "Read the entire SD card 10x. Tests RAM and I/O..."
for i in `seq 1 10`; do echo reading: $i; sudo dd if=/dev/mmcblk0 of=/dev/null bs=4M; done

echo "Writing 512 MB test file, 10x..."
for i in `seq 1 10`; do echo writing: $i; dd if=/dev/zero of=deleteme.dat bs=1M count=512; sync; done

#yes is a process that outputs a string repeatedly until killed
echo "Done with test. Cleaning up..."
killall yes
rm deleteme.dat

echo -n -e '\n'
echo -n -e '\n'

echo "Printing summary within *** below. Anything nasty will appear in dmesg."
echo "**************************************"
echo -n "CPU freq: " ; cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
echo -n "CPU temp: " ; cat /sys/class/thermal/thermal_zone0/temp
dmesg | tail 
echo "**************************************"
echo "Not crashed yet, probably stable. Especially if nothing written above in ***s from dmesg."
echo "DONE. Exiting."
echo -n -e '\n'
echo -n -e '\n'

#!/bin/bash

#author Brandon
#V1.0-initial

# Serial port settings
serial_port="/dev/ttyS0"  # Replace with the appropriate serial port path "/dev/ttyAMA0" or "/dev/ttyS0" seem to be right for rbpi4
baud_rate="9600"  # Adjust to match the transmitting device's baud rate
#@TODO-add other settings for serial

# File settings
log_file="/home/lora2/picocom_log.txt"  # Replace with the desired path for the log file

# Function to log serial data
log_serial_data() {
    picocom -b "$baud_rate" "$serial_port" -l -r "$log_file"
}

# Call the function to start logging serial data
log_serial_data

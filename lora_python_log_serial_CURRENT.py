#!/usr/bin/python3
# author: Brandon
# V1.0-initial,  assumes the data being transmitted is text-based. Binary data requires modification
# V1.1-modify to handle binary data & write to file more frequently
# V1.2- Collin's cleanup.
import logging
import serial
from pathlib import Path

# Serial port settings
serial_port = "/dev/ttyS0"  # Replace with the appropriate serial port path
baud_rate = 9600  # Adjust to match the transmitting device's baud rate
timeout_seconds = 0.05  # time it will wait for a newline. 0.05 secs is more than enough time for ~30 characters of serial data to transmit at 9600 baud.

# File settings
base_dir = Path("/opt/lora_logger")
log_file = base_dir / Path("lora_python_serial_log_V1.2.txt")

# DEBUG -> INFO -> WARNING -> ERROR -> CRITICAL
# Logging logs every level above the current one.
logging.basicConfig(filename=log_file,
                    format='%(asctime)s %(message)s',
                    filemode='a',
                    encoding='utf-8',
                    level=logging.DEBUG)


def main():
    try:
        ser = serial.Serial(serial_port, baud_rate, timeout=timeout_seconds)
        while True:
            data = ser.readline() 
            # data = ser.read(ser.in_waiting or 1)  # Read all available bytes or at least 1 byte
            # time.sleep(0.05) #more than enough time for ~30 characters of serial data to transmit at 9600 baud. @TODO-needed?
            if data:
                logging.info(data)
    except serial.SerialTimeoutException:
        logging.critical("No data received within the timeout period.")
    except KeyboardInterrupt:
        logging.info("Logging stopped by the user.")
    except Exception as e:
        logging.error(e)
    finally:
        ser.close() # This is potentially unbounded but this will probably never happen

if __name__ == "__main__":
    main()

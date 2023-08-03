# author: Brandon
# V1.0-initial,  assumes the data being transmitted is text-based. Binary data requires modification
# V1.1-modify to handle binary data & write to file more frequently

import serial
from datetime import datetime
import time

# general variables
debug_on = True

# Serial port settings
serial_port = "/dev/ttyS0"  # Replace with the appropriate serial port path
baud_rate = 9600  # Adjust to match the transmitting device's baud rate
timeout_seconds = 0.05  # time it will wait for a newline. 0.05 secs is more than enough time for ~30 characters of serial data to transmit at 9600 baud.

# File settings
log_file = "/opt/lora_logger/serial_log_python_lora_V1.1.txt"
# Time interval for flushing aka forcing write of log to disk (in seconds)
flush_interval = 120  # 2 minute
# Variables to track time
last_flush_time = time.time()

print("lora_python_log_serialV1.1.py-beginning to log serial data. Anything received will go in file.")


def get_timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def main():
    global last_flush_time
    try:
        ser = serial.Serial(serial_port, baud_rate, timeout=timeout_seconds)
        with open(
            log_file, "ab"
        ) as f:  # @TODO- see what "ab" vs "a" means. ASCII vs binary?
            while True:
                data = ser.readline()
                # data = ser.read(ser.in_waiting or 1)  # Read all available bytes or at least 1 byte
                # time.sleep(0.05) #more than enough time for ~30 characters of serial data to transmit at 9600 baud. @TODO-needed?
                if data:
                    timestamp = get_timestamp()
                    log_line = f"[{timestamp}] {data}\n"
                    f.write(log_line.encode("utf-8"))
                    current_time = time.time()
                    if current_time - last_flush_time >= flush_interval:
                        f.flush()  # Flush data to the file
                        last_flush_time = current_time

                    #print(log_line, end="")  # Optional: Display data on the console

    except serial.SerialTimeoutException:
        if debug_on:
            print("DEBUG: No data received within the timeout period.")
        pass  # pass to signify no action is required
    except KeyboardInterrupt:
        print("Logging stopped by the user.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        ser.close()


if __name__ == "__main__":
    main()

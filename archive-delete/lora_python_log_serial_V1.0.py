import serial
from datetime import datetime
import time

#author: Brandon
#V1.0-initial,  assumes the data being transmitted is text-based. If you are dealing with binary data, update is needed

# Serial port settings
serial_port = "/dev/ttyS0"  # Replace with the appropriate serial port path "/dev/ttyAMA0" or "/dev/ttyS0"
baud_rate = 9600  # Adjust to match the transmitting device's baud rate

# File settings
log_file = "lora_python_serial_log_V1.0.txt"

def get_timestamp():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

def main():
    try:
        ser = serial.Serial(serial_port, baud_rate)
        with open(log_file, "a") as f:
            while True:
                data = ser.readline().decode().strip()
                timestamp = get_timestamp()
                log_line = f"[{timestamp}] {data}\n"
                f.write(log_line)
                print(log_line, end='')  # Optional: Display data on the console
    except KeyboardInterrupt:
        print("Logging stopped by the user.")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        ser.close()

if __name__ == "__main__":
    main()

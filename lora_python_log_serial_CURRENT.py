#!/usr/bin/python3
# author: Brandon
# V1.0-initial,  assumes the data being transmitted is text-based. Binary data requires modification
# V1.1-modify to handle binary data & write to file more frequently
# V1.2- Collin's cleanup.
import json
import logging
import re
import serial
import time
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
logging.basicConfig(
    filename=log_file,
    format="%(asctime)s %(message)s",
    filemode="a",
    encoding="utf-8",
    level=logging.DEBUG,
)


def parse_line(l):
    splits = [s for s in re.split("['\s]", l) if s]
    message_info = re.split(",", splits[-1])
    logging.info(splits)
    logging.info(message_info)
    return {
        "rx_message_number": splits[1],
        "rssi": splits[5],
        "snr": splits[6],
        "frequency_error": splits[7],
        "bytes_recieved": splits[8],
        "spreading_factor": splits[9],
        "signal_bandwidth": splits[10],
        "frequency": splits[11],
        "message": message_info[0],
        "node_id": message_info[1],
        "battery_voltage": message_info[2],
        "motion_events": message_info[3],
        "last_motion_time": message_info[4],
        "time_recieved": time.time(),
    }


def format_json(m, longitude, latitude):
    working = m["motion_events"] >= "1" and not 2**16 - 1
    return (
        json.dumps(
            {
                "longitude": longitude,
                "latitude": latitude,
                "id": m["node_id"],
                "name": "Elevator",
                "isWorking": working,
                "isAccessibleWithWheelChair": True,
                "shortDescription": {"string": "An elevator motion event detector."},
                "longDescription": {
                    "string": "A sensor repsonsible for reporting the last known motion event from an elevator"
                },
                "stateLastUpdate": {"$date": int(time.mktime(m["time_recieved"]))},
            }
        )
        if working
        else None
    )


def main():
    ser = serial.Serial(serial_port, baud_rate, timeout=timeout_seconds)

    while True:
        try:
            line = ser.readline().decode("utf-8").strip()
            # data = ser.read(ser.in_waiting or 1)  # Read all available bytes or at least 1 byte
            # time.sleep(0.05) #more than enough time for ~30 characters of serial data to transmit at 9600 baud. @TODO-needed?
            if line:
                message = parse_line(line)
                json_line = format_json(
                    message, 1.111111, 1.111111
                )  # precision must be to 6 decimal places for accesibility.cloud
                if json_line:
                    with open(base_dir / Path("api_objects.jsonl"), "a") as outfile:
                        outfile.write(json_line)
                logging.info(line)
        except serial.SerialTimeoutException:
            logging.critical("No data received within the timeout period.")
        except KeyboardInterrupt:
            logging.info("Logging stopped by the user.")
        except Exception as e:
            logging.error(e)
        finally:
            continue


if __name__ == "__main__":
    main()

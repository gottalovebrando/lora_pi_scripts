import time
import json
import re
from pathlib import Path
from pprint import pprint

api_token = "29580961234e66e0a6a2be34d77dada1" 

def parse_line(l):
    splits = [s for s in re.split("[\'\s]", l) if s]
    datetime = time.strptime(" ".join(splits[:2]), "%Y-%m-%d %H:%M:%S,%f")
    message_info = re.split(",",splits[-1])
    return {
        "rx_message_number": splits[3],
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
        "time_recieved": datetime
    }

def format_json(m, longitude, latitude):
    working = m["motion_events"] >= "1" and not 2**16-1
    return json.dumps({
            "features": {
                "longitude": longitude,
                "latitude": latitude,
                "id": m["node_id"],
                "name": "Elevator",
                "isWorking": True,
                "isAccessibleWithWheelChair": True,
                "shortDescription": {"string":"An elevator motion event detector."},
                "longDescription": {"string":"A sensor repsonsible for reporting the last known motion event from an elevator"},
                "stateLastUpdate": {"$date": int(time.mktime(m["time_recieved"]))},
        }
    }) if True else None

def main():
    f = Path("lora_python_serial_log_V1.2.txt")

    recent_lines = f.read_text().splitlines()[-10:]
    messages = []
    for l in recent_lines:
        messages.append(parse_line(l))

    json_objects = []
    for m in messages:
        json_objects.append(format_json(m, 1.111111,1.111111))

    with open("sample.json", "w") as outfile:
        outfile.write(json_objects[9])
if __name__ == "__main__":
    main()

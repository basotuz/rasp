import glob
import time

BASE_DIR = "/sys/bus/w1/devices/"
DEVICE_GLOB = BASE_DIR + "28-*"
POLL_INTERVAL_SECONDS = 2


def get_device_file():
    device_folders = glob.glob(DEVICE_GLOB)
    if not device_folders:
        raise FileNotFoundError("Nessun sensore DS18B20 trovato in /sys/bus/w1/devices/")

    return device_folders[0] + "/w1_slave"


def read_temp(device_file):
    with open(device_file, "r", encoding="utf-8") as file_handle:
        lines = file_handle.readlines()

    if len(lines) < 2 or "YES" not in lines[0]:
        return None

    temp_pos = lines[1].find("t=")
    if temp_pos == -1:
        return None

    temp_string = lines[1][temp_pos + 2 :]
    return float(temp_string) / 1000.0


def main():
    try:
        device_file = get_device_file()
    except FileNotFoundError as exc:
        print(exc)
        return

    while True:
        temp_c = read_temp(device_file)
        if temp_c is not None:
            print(f"Temperatura DS18B20: {temp_c:.2f} C")
        else:
            print("Errore lettura")

        time.sleep(POLL_INTERVAL_SECONDS)


if __name__ == "__main__":
    main()

import serial

SERIAL_PORT = "/dev/ttyACM0"
SERIAL_BAUDRATE = 9600
SERIAL_TIMEOUT_SECONDS = 1


def parse_message(line):
    values = {}

    for chunk in line.split(";"):
        if "=" not in chunk:
            continue

        key, value = chunk.split("=", 1)
        values[key.strip()] = value.strip()

    return values


def main():
    ser = serial.Serial(
        SERIAL_PORT,
        SERIAL_BAUDRATE,
        timeout=SERIAL_TIMEOUT_SECONDS,
    )

    try:
        while True:
            line = ser.readline().decode(errors="ignore").strip()

            if not line:
                continue

            print("Ricevuto:", line)

            values = parse_message(line)
            soil_percent = values.get("soil")
            raw_value = values.get("raw")

            if soil_percent is not None:
                print(f"Umidita suolo: {soil_percent}%")

            if raw_value is not None:
                print(f"Valore raw: {raw_value}")
    finally:
        ser.close()


if __name__ == "__main__":
    main()

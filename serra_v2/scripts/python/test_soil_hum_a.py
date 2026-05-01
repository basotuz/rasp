import serial

ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)

while True:
    line = ser.readline().decode().strip()

    if line:
        print("Ricevuto:", line)

        if line.startswith("soil="):
            valore = int(line.split("=")[1])
            print(f"Umidità suolo: {valore}%")

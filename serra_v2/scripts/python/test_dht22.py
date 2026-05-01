import time

import adafruit_dht
import board

DHT_SENSOR_PIN = board.D22  # BCM GPIO22, pin fisico 15
POLL_INTERVAL_SECONDS = 2


def main():
    dht = adafruit_dht.DHT22(DHT_SENSOR_PIN, use_pulseio=False)

    try:
        while True:
            try:
                temperature_c = dht.temperature
                humidity_percent = dht.humidity

                if temperature_c is not None and humidity_percent is not None:
                    print(f"Temperatura: {temperature_c:.1f} C")
                    print(f"Umidita: {humidity_percent:.1f} %")
                    print("RAW ->", temperature_c, humidity_percent)
                    print("------")
                else:
                    print("Nessun dato valido")

            except RuntimeError as exc:
                # Normale con DHT: si riprova al ciclo successivo.
                print("Errore lettura (normale):", exc)

            except Exception as exc:
                print("Errore grave:", exc)
                break

            time.sleep(POLL_INTERVAL_SECONDS)
    finally:
        dht.exit()


if __name__ == "__main__":
    main()

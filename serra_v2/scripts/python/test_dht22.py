import time
import board
import adafruit_dht

# GPIO14 (pin fisico 8)
dht = adafruit_dht.DHT22(board.D22, use_pulseio=False)

while True:
    try:
        temp = dht.temperature
        hum = dht.humidity

        if temp is not None and hum is not None:
            print(f"🌡️ Temperatura: {temp:.1f} °C")
            print(f"💧 Umidità: {hum:.1f} %")
            print("RAW ->", temp, hum)
            print("------")
            
        else:
            print("⚠️ Nessun dato valido")

    except RuntimeError as e:
        # normale con DHT, ignora e riprova
        print("Errore lettura (normale):", e)

    except Exception as e:
        print("Errore grave:", e)
        break

    time.sleep(2)

import RPi.GPIO as GPIO
import time

PIN = 25

GPIO.setmode(GPIO.BCM)
GPIO.setup(PIN, GPIO.IN)

try:
    while True:
        stato = GPIO.input(PIN)

        if stato == 0:
            print("💧 BAGNATO")
        else:
            print("🌵 SECCO")

        time.sleep(1)

except KeyboardInterrupt:
    GPIO.cleanup()

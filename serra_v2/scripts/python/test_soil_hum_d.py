import time

import RPi.GPIO as GPIO

SOIL_DIGITAL_PIN = 25
POLL_INTERVAL_SECONDS = 1

GPIO.setmode(GPIO.BCM)
GPIO.setup(SOIL_DIGITAL_PIN, GPIO.IN)


def main():
    try:
        while True:
            state = GPIO.input(SOIL_DIGITAL_PIN)

            if state == 0:
                print("BAGNATO")
            else:
                print("SECCO")

            time.sleep(POLL_INTERVAL_SECONDS)
    finally:
        GPIO.cleanup()


if __name__ == "__main__":
    main()

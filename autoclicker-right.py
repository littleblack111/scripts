from time import sleep
from random import uniform
from pynput.mouse import Controller, Button
from sys import argv

mouse = Controller()

try:
    if len(argv) > 1:
        delay = int(argv[1]) // 1000
        while True:
            mouse.click(Button.right, 1)
            sleep(delay)
    else:
        while True:
            mouse.click(Button.right, 1)
            sleep(round(uniform(0.035, 0.055), 3))
except KeyboardInterrupt:
    print("\nKeyboardInterrupt, exiting")

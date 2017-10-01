#http://razzpisampler.oreilly.com/ch07.html
import RPi.GPIO as GPIO
import time
import os

# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=133665
from subprocess import call

GPIO.setmode(GPIO.BCM)
GPIO.setup(4,GPIO.IN, pull_up_down=GPIO.PUD_UP)

while True:
  if (GPIO.input(4) == False):
	print("Button pressed")
	time.sleep(0.2)

	# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=133665
	# call("sudo reboot now", shell=True)

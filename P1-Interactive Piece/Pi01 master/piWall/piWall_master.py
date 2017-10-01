# OSC - OMXPlayer Receiver
# Original code https://github.com/ptone/pyosc/blob/master/examples/knect-rcv.py

# RECEIVER - receive message libraries
from OSC import OSCServer
import sys
from time import sleep

# SENDER - send message libraries
from OSC import OSCClient, OSCMessage

from omxplayer import OMXPlayer #https://github.com/willprice/python-omxplayer-wrapper

# BUTTON - to stop all PIs - send message to Master and Master to all Slaves
#http://razzpisampler.oreilly.com/ch07.html
import RPi.GPIO as GPIO
import time
import os

# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=133665
from subprocess import call


# SET UP BUTTON ................................................................................................................................
GPIO.setmode(GPIO.BCM)
GPIO.setup(4,GPIO.IN, pull_up_down=GPIO.PUD_UP)

# SET UP SERVER ................................................................................................................................
server = OSCServer( ("0.0.0.0", 1111) ) # "0.0.0.0" = local ip | port = 1111 (master)
server.timeout = 0 # waiting time to receive
run = True # server is running

# SET UP video
# https://github.com/willprice/python-omxplayer-wrapper/issues/34
# --no-osd = no player on screen - https://github.com/KenT2/pipresents/issues/25
player = OMXPlayer("/home/pi/Videos/scene_01_01_pool.mp4", args = ['--no-osd', '--loop', '--refresh', '--blank'])

# this method of reporting timeouts only works by convention
# that before calling handle_request() field .timed_out is
# set to False
def handle_timeout(self):
    self.timed_out = True

# SET UP CREATE CLIENTS  ...................................................................................................................

# CLIENT 1- slave02.py
client1 = OSCClient()
client1.connect( ("pi02.local", 1111) ) # IP slave02 192.168.1.10

# CLIENT 2- slave03.py
client2 = OSCClient()
client2.connect( ("pi03.local", 1111) ) # IP slave02 192.168.1.13

# CLIENT 3- slave04.py
client3 = OSCClient()
client3.connect( ("pi04.local", 1111) ) # IP slave02 192.168.1.11

# CLIENT 4- slave05.py
client4 = OSCClient()
client4.connect( ("pi05.local", 1111) ) # IP slave02 192.168.1.9

# CLIENT 5- slave06.py
client5 = OSCClient()
client5.connect( ("pi06.local", 1111) ) # IP slave02 192.168.1.12

# TIMEOUT SERVER  ...........................................................................................

# python's way to add a method to an instance of a class
# to control server's timeouts
import types
server.handle_timeout = types.MethodType(handle_timeout, server)

# MAIN LOOP GENERAL PROGRAM ...........................................................................................

# SCENE01 - which OSC message is the server listening /play/scene01

# handle scene/1
def play_scene_01(path, tags, args, source):
    print path
    print source # who is sending the message to the server

    print "play_scene_01"
    client1.send( OSCMessage("/play/scene/1" ) ) # message sent
    client2.send( OSCMessage("/play/scene/1" ) ) # message sent
    client3.send( OSCMessage("/play/scene/1" ) ) # message sent
    client4.send( OSCMessage("/play/scene/1" ) ) # message sent
    client5.send( OSCMessage("/play/scene/1" ) ) # message sent

    print "client messages sent"
    player.load("/home/pi/Videos/scene_01_01_pool.mp4")

# handle scene/2
def play_scene_02(path, tags, args, source):
    print path
    print source # who is sending the message to the server

    print "play_scene_02"
    client1.send( OSCMessage("/play/scene/2" ) ) # message sent
    client2.send( OSCMessage("/play/scene/2" ) ) # message sent
    client3.send( OSCMessage("/play/scene/2" ) ) # message sent
    client4.send( OSCMessage("/play/scene/2" ) ) # message sent
    client5.send( OSCMessage("/play/scene/2" ) ) # message sent

    print "client messages sent"
    player.load("/home/pi/Videos/scene_02_01_flora.mp4")

# handle scene/3
def play_scene_03(path, tags, args, source):
    print path
    print source # who is sending the message to the server

    print "play_scene_03"
    client1.send( OSCMessage("/play/scene/3" ) ) # message sent
    client2.send( OSCMessage("/play/scene/3" ) ) # message sent
    client3.send( OSCMessage("/play/scene/3" ) ) # message sent
    client4.send( OSCMessage("/play/scene/3" ) ) # message sent
    client5.send( OSCMessage("/play/scene/3" ) ) # message sent

    print "client messages sent"
    player.load("/home/pi/Videos/scene_03_01_sailors.mp4")

# handle scene/4
def play_scene_04(path, tags, args, source):
    print path
    print source # who is sending the message to the server

    print "play_scene_04"
    client1.send( OSCMessage("/play/scene/4" ) ) # message sent
    client2.send( OSCMessage("/play/scene/4" ) ) # message sent
    client3.send( OSCMessage("/play/scene/4" ) ) # message sent
    client4.send( OSCMessage("/play/scene/4" ) ) # message sent
    client5.send( OSCMessage("/play/scene/4" ) ) # message sent

    print "client messages sent"
    player.load("/home/pi/Videos/scene_04_01_travel.mp4")

# handle SHUT DOWN ...........................................................................................
def shutdown():

    print "shutdown"
    client1.send( OSCMessage("/shutdown" ) ) # message sent
    client2.send( OSCMessage("/shutdown" ) ) # message sent
    client3.send( OSCMessage("/shutdown" ) ) # message sent
    client4.send( OSCMessage("/shutdown" ) ) # message sent
    client5.send( OSCMessage("/shutdown" ) ) # message sent
    # https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=133665
    call("sudo reboot now", shell=True)

# handle scene messages for different scenes FROM IPAD ...........................................................................................
server.addMsgHandler( "/play/scene/1", play_scene_01 )
server.addMsgHandler( "/play/scene/2", play_scene_02 )
server.addMsgHandler( "/play/scene/3", play_scene_03 )
server.addMsgHandler( "/play/scene/4", play_scene_04 )

def each_frame():
    # set timeout to false
    server.timed_out = False
    # whilst there is no timeout - do a handle request (server receives message)
    while not server.timed_out:
        server.handle_request()

# while the script is running
while run:
    # wait for a second
    sleep(0.1)
    # and do the following
    each_frame()

    # button to stop PIs ...........................................................................................
    if (GPIO.input(4) == False):
  	    #print("Button pressed")
        shutdown()
        time.sleep(0.2)

# END ...........................................................................................
server.close()

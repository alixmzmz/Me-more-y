# OSC - OMXPlayer Receiver
# Original code https://github.com/ptone/pyosc/blob/master/examples/knect-rcv.py

from OSC import OSCServer
import sys
from time import sleep
from omxplayer import OMXPlayer #https://github.com/willprice/python-omxplayer-wrapper

# BUTTON - to stop all PIs - send message to Master and Master to all Slaves
#http://razzpisampler.oreilly.com/ch07.html
import os

# https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=133665
from subprocess import call

# SET UP ...........................................................................................

server = OSCServer( ("0.0.0.0", 1111) ) # "0.0.0.0" = local ip | port = 1111 (master)
server.timeout = 0 # waiting time to receive
run = True # server is running

# SET UP video
# https://github.com/willprice/python-omxplayer-wrapper/issues/34
# --no-osd = no player on screen - https://github.com/KenT2/pipresents/issues/25
player = OMXPlayer("/home/pi/Videos/scene_01_02_family.mp4", args = ['--no-osd', '--loop', '--refresh', '--deinterlace','--blank'])

# this method of reporting timeouts only works by convention
# that before calling handle_request() field .timed_out is
# set to False
def handle_timeout(self):
    self.timed_out = True

# python's way to add a method to an instance of a class
# to control server's timeouts
import types
server.handle_timeout = types.MethodType(handle_timeout, server)

# MAIN LOOP ...........................................................................................

# which OSC message is the server listening /play/video01

# handle scene
def play_scene_01(path, tags, args, source):
    print "play_scene_01"
    print path
    print source # who is sending the message to the server
    player.load("/home/pi/Videos/scene_01_02_family.mp4") # https://github.com/willprice/python-omxplayer-wrapper/issues/50

def play_scene_02(path, tags, args, source):
    print "play_scene_02"
    print path
    print source # who is sending the message to the server
    player.load("/home/pi/Videos/scene_02_02_people.mp4")

def play_scene_03(path, tags, args, source):
    print "play_scene_03"
    print path
    print source # who is sending the message to the server
    player.load("/home/pi/Videos/scene_03_02_shaved.mp4")

def play_scene_04(path, tags, args, source):
    print "play_scene_04"
    print path
    print source # who is sending the message to the server
    player.load("/home/pi/Videos/scene_04_02_food.mp4")

# SHUTDOWN FUNCTION ...........................................................................................
def shutdown(path, tags, args, source):
    # https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=133665
	call("sudo reboot now", shell=True)

server.addMsgHandler( "/play/scene/1", play_scene_01 )
server.addMsgHandler( "/play/scene/2", play_scene_02 )
server.addMsgHandler( "/play/scene/3", play_scene_03 )
server.addMsgHandler( "/play/scene/4", play_scene_04 )
server.addMsgHandler( "/shutdown", shutdown )


#  ..........................................................................................................

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

# END ...........................................................................................

server.close()

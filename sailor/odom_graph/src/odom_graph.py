#!/usr/bin/env python
import math
from math import *
import rospy
from nav_msgs.msg import Odometry

import pygame, sys
from pygame.locals import *

#Initiates the display
pygame.init()
windowSurfaceObj= pygame.display.set_mode((800,800))
pygame.display.set_caption('Husky Odom Graph')
yellow = pygame.Color(200,210,0)
n_color = pygame.Color(150,0,250)
windowSurfaceObj.fill(pygame.Color(0,0,0))
pygame.display.update()

old_x = 300
old_y = 300
old_xx = 300
old_yy = 300
#Callback function, draws a line from the last odom point to a new one
def odomCBC(msg):
	global old_x
	global old_y
	new_x=int(msg.pose.pose.position.x *3)+300
	new_y=int(msg.pose.pose.position.y *3)+300
	pygame.draw.line(windowSurfaceObj, yellow, (old_x,old_y), (new_x, new_y), 2)
	pygame.display.update()
	
	old_x=new_x
	old_y=new_y

def odomCB(msg):
	global old_xx
	global old_yy
	new_xx=int(msg.pose.pose.position.x *3)+300
	new_yy=int(msg.pose.pose.position.y *3)+300
	pygame.draw.line(windowSurfaceObj, n_color, (old_xx,old_yy), (new_xx, new_yy), 2)
	pygame.display.update()
	
	old_xx=new_xx
	old_yy=new_yy

	

def listener():

	rospy.init_node('odom_graph', anonymous=True)

#     change repairs issues under indigo 
	rospy.Subscriber("husky_velocity_controller/odom", Odometry, odomCBC)
	rospy.Subscriber("odometry/filtered", Odometry, odomCB)
	rospy.spin()

if __name__=="__main__":
	
	listener()
		

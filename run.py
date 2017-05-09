from TOSSIM import Tossim
import sys
import random
import time
from TrackerMsg2 import *

N = 25 + 1

t = Tossim([])
r = t.radio()

COORD = 1
DIST = 2
INIT = 3
VOTING = 4
COALITION = 5

channels = ["Init", "Moved"]

for c in channels:
	t.addChannel(c, sys.stdout)

def get_movement():
	with open('Object/out2.txt', 'r') as r:
		lines = [x[:-1] for x in r.readlines()]
		return lines


noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
	str1 = line.strip()
	if str1:
		val = int(str1)
		for i in range(1, N):
			t.getNode(i).addNoiseTraceReading(val)

for i in range(1, N):
	t.getNode(i).createNoiseModel()



nodes = [t.getNode(i) for i in range(1, N)]

for i in nodes:
	i.bootAtTime(random.randint(1000, 5000))


movement = get_movement()
print('First: ' + movement[0] + '\n\n\n')

from random import randint

while not all([n.isOn() for n in nodes]):
	t.runNextEvent()

# Initialize node positions and IDs
for i in range(1, N):
	msg = TrackingMsg()
	msg.set_nodeid(i)
	msg.set_x(randint(-10, 10))
	msg.set_y(randint(-10, 10))
	msg.set_type(INIT);
	pkt = t.newPacket()
	pkt.setData(msg.data)
	pkt.setType(msg.get_amType())
	pkt.setSource(0)
	pkt.setDestination(i)
	pkt.deliver(i, t.time() + 3)

for m in movement:
	msg = TrackingMsg()
	msg.set_nodeid(0)	
	msg.set_type(COORD)
	x, y = m.split(' ')[1].split(',')
	msg.set_x(int(x[1:]))
	msg.set_y(int(y[:-1]))

	tstring = [long(x.replace('.', '')) for x in m.split(' ')[0].split(':')]

	time = tstring[2] * 10 + 60000000000 * tstring[1] + 3600000000000 * tstring[0]

	#print(str(tstring) + ':  ' + str(time))
	#raw_input()

	for i in range(1, N):
		pkt = t.newPacket()
		pkt.setData(msg.data)
		pkt.setType(msg.get_amType())
		pkt.setSource(0)
		pkt.setDestination(i)
		pkt.deliver(i, time)

while True:
	for i in range(200):
		t.runNextEvent()	
	raw_input()

from TOSSIM import *
import sys
import random
import time

t = Tossim([])
r = t.radio()
channels = ["Boot", "Timer", "Moved", "Info"]
for c in channels:
	t.addChannel(c, sys.stdout)


noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
	str1 = line.strip()
	if str1:
		val = int(str1)
		for i in range(1, 3):
			t.getNode(i).addNoiseTraceReading(val)

for i in range(1, 3):
	t.getNode(i).createNoiseModel()

r.add(1, 2, -50)
r.add(1, 3, -50)
r.add(2, 3, -50)
r.add(2, 1, -50)
r.add(3, 1, -50)
r.add(3, 2, -50)
	
nodes = [t.getNode(i) for i in range(1, 3)]

for i in nodes:
	i.bootAtTime(random.randint(1000, 5000))

while not all([n.isOn() for n in nodes]):
	t.runNextEvent()
	break

while True:
	t.runNextEvent()
	raw_input()
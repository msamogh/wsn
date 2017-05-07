from TOSSIM import Tossim
import sys
import random
import signal
import time


def signal_handler(signal, frame):
	with open('out.txt', 'r') as r, open('out2.txt', 'w') as w:
		for line in [x[0] + ' ' + x[-1] for x in [xx.split(' ') for xx in r.readlines()]]:
			print(line)
			w.write(line)
	sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

t = Tossim([])
r = t.radio()
x = open('out.txt', 'w')
t.addChannel("Moved", x)


noise = open("meyer-heavy.txt", "r")
lines = noise.readlines()
for line in lines:
	str1 = line.strip()
	if str1:
		val = int(str1)
		t.getNode(0).addNoiseTraceReading(val)

t.getNode(0).createNoiseModel()


n = t.getNode(0)
n.bootAtTime(0)

while True:
	works = t.runNextEvent()
					

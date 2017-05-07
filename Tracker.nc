#include <time.h>
#include <stdlib.h>
#include <math.h>
#include "Tracker.h"

module Tracker @safe()
{
	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Timer<TMilli> as Timer;
	uses interface Receive;
}

implementation
{
	bool busy = FALSE;
	message_t pkt;
	long r;
	float distance, var;
	int16_t x, y;
	uint16_t id;

	event void Boot.booted()
	{
		dbg("Boot", "%d booted", TOS_NODE_ID);
		call AMControl.start();
		call Timer.startPeriodic( 250 );
		srand(time(NULL));   // should only be called once
	}

	event void Timer.fired()
	{
		if (!busy) {
			TrackerMsg* btrpkt = (TrackerMsg*)(call Packet.getPayload(&pkt, sizeof (TrackerMsg)));
			btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->type = DIST;
			btrpkt->distance = 3;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(TrackerMsg)) == SUCCESS) {
				dbg("Info", "Packet sent");
				busy = TRUE;
			} else {
				dbg("Info", "Couldn't send packet. Busy.");
			}
		}
	}

	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			dbg("Info", "AMControl started");
		}
		else {
			call AMControl.start();
		}
	}

	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
		}
	}

	event void AMControl.stopDone(error_t err) {
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(TrackerMsg)) {
			TrackerMsg* btrpkt = (TrackerMsg*)payload;
			if (btrpkt->type == DIST)
				dbg("Info", "Nodeid: %d, distance: %d\n", btrpkt->nodeid, btrpkt->distance);
			else if (btrpkt->type == COORD) {
				dbg("Moved", "Coords: %d, %d", btrpkt->x, btrpkt->y);
				r = rand();
				var = ((float)((r % 200) / 100.0));
				var = (r % 2 == 0) ? -var : var;
				distance = sqrt(pow(x - btrpkt->x, 2) + pow(y - btrpkt->y, 2)) + var;
				if (distance <= 10)
					dbg("Moved", "Distance: %f\n", distance);
				else
					dbg("Moved", "Out of range\n", distance);
			} else if (btrpkt->type == INIT) {
				x = btrpkt->x;
				y = btrpkt->y;
				dbg("Init", "Positioned at (%d, %d)\n", x, y);
				id = btrpkt->nodeid;
			}
		} else {
			
		}
		return msg;
	}

}

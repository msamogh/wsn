#include "Timer.h"
#include <time.h>
#include <stdlib.h>

module Object @safe()
{
	uses interface Timer<TMilli> as Timer;
	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
}

implementation
{

	int16_t x = 1, y = 1;
	uint16_t dx, dy, x_sign, y_sign;
	bool busy = FALSE;
	message_t pkt;
	
	event void Boot.booted()
	{
		dbg("Boot", "Booted\n");
		call AMControl.start();
		call Timer.startPeriodic( 2000 );
		srand(time(NULL));   // should only be called once
	}

	event void Timer.fired() 

	{
		dbg("Timer", "Timer fired @ %s\n", sim_time_string());
		dx = rand() % 5;
		x_sign = rand() % 2;
		dy = rand() % 5;
		y_sign = rand() % 2;
		dx = x_sign == 0 ? -dx : dx;
		dy = y_sign == 0 ? -dy : dy;

		x = (x + dx);
		y = (y + dy);
		
		if (!busy) {
			TrackerMsg* btrpkt = (TrackerMsg*)(call Packet.getPayload(&pkt, sizeof (TrackerMsg)));
			btrpkt->nodeid = TOS_NODE_ID;
			btrpkt->distance = 77;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(TrackerMsg)) == SUCCESS) {
				dbg("Moved", "Hey! I'm at (%d,%d)\n", x, y);
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

}

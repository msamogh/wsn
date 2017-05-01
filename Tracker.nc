#include <time.h>
#include <stdlib.h>

generic module Tracker (uint16_t i, int16_t x, int16_t y)
{
	provides interface Movement;
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

	event void Boot.booted()
	{
		dbg("Boot", "%d booted", TOS_NODE_ID);
		call AMControl.start();
		call Timer.startPeriodic( 250 );
	}

	event void Timer.fired()
	{
		//dbg("Timer", "Timer fired");
		if (!busy) {
			TrackerMsg* btrpkt = (TrackerMsg*)(call Packet.getPayload(&pkt, sizeof (TrackerMsg)));
			btrpkt->nodeid = TOS_NODE_ID;
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
			dbg("Info", "Message from %d received by %d", btrpkt->nodeid, TOS_NODE_ID);
		}
		return msg;
	}

	command void Movement.movedTo(int16_t nx, int16_t ny) {
		dbg("Info", "Movement noticed");
		dbg("Info", "(%d, %d)", nx, ny);
	}	
}
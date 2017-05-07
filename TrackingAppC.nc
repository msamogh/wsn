#include "Tracker.h"
#include "Timer.h"
#include <stdlib.h>

configuration TrackingAppC
{
}

implementation
{
	components MainC;
	components ActiveMessageC;
	components Tracker;
	components new AMSenderC(6);
	components new AMReceiverC(6);
	components new TimerMilliC() as Timer;

	Tracker.Receive -> AMReceiverC;
	Tracker.Packet -> AMSenderC;
	Tracker.AMPacket -> AMSenderC;
	Tracker.AMSend -> AMSenderC;
	Tracker.AMControl -> ActiveMessageC;
	Tracker.Timer -> Timer;

	Tracker -> MainC.Boot;

}

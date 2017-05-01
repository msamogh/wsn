#include "Tracker.h"
#include "Timer.h"

configuration TrackingAppC
{
}

implementation
{
	components MainC;
	components ActiveMessageC;
	components new AMSenderC(6);
	components new AMReceiverC(6);
	components new TimerMilliC() as Timer;
	components new Tracker(1, 0, 0) as Tracker;

	Tracker.Receive -> AMReceiverC;
	Tracker.Packet -> AMSenderC;
	Tracker.AMPacket -> AMSenderC;
	Tracker.AMSend -> AMSenderC;
	Tracker.AMControl -> ActiveMessageC;
	Tracker.Timer -> Timer;

	Tracker -> MainC.Boot;

}

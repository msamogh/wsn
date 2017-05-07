#include "Timer.h"
#include "Object.h"

configuration ObjectAppC
{
}

implementation
{
	components MainC;
	components ActiveMessageC;
	components Object;
	components new AMSenderC(AM_TRACKER);
	components new TimerMilliC() as Timer;

	Object -> MainC.Boot;
	Object.Timer -> Timer;
	Object.Packet -> AMSenderC;
	Object.AMPacket -> AMSenderC;
	Object.AMSend -> AMSenderC;
	Object.AMControl -> ActiveMessageC;
}

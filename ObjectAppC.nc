#include "Timer.h"

configuration TrackingAppC
{
}

implementation
{
	components MainC;
	components ActiveMessageC;
	components Object;
	components new AMSenderC(AM_BLINKTORADIO);
	components new TimerMilliC() as Timer;

	Object -> MainC.Boot;

}

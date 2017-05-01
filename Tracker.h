#ifndef TRACKER_H
nx_struct TrackerMsg
{
	nx_uint16_t nodeid;
	nx_uint16_t distance;
};

enum {
  AM_TRACKER = 6,
  TIMER_PERIOD_MILLI = 250
};

typedef nx_struct TrackerMsg TrackerMsg;
#define TRACKER_H 
#endif
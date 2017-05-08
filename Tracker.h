#ifndef TRACKER_H
nx_struct TrackerMsg
{
	nx_uint16_t nodeid;
	nx_uint16_t type;
  nx_uint16_t distance;
	nx_int16_t x;
	nx_int16_t y;
};

enum {
  AM_TRACKER = 6,
  COORD = 1,
  DIST = 2,
  INIT = 3,
  VOTING = 4,
  COALITION = 5,
  TIMER_PERIOD_MILLI = 250
};

typedef nx_struct TrackerMsg TrackerMsg;
#define TRACKER_H 
#endif
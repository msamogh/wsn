#include "Timer.h"
#include <time.h>
#include <stdlib.h>


module Object @safe()
{
	uses interface Timer<TMilli> as Timer;
	uses interface Boot;
	uses interface Movement;
}

implementation
{

	int16_t x = 1, y = 1;
	uint16_t dx, dy, x_sign, y_sign;
	
	event void Boot.booted()
	{
		dbg("Boot", "Booted\n");
		call Timer.startPeriodic( 2000 );
		srand(time(NULL));   // should only be called once
	}

	event void Timer.fired() // list(map(lambda d : list([ff['lat'][lat], ff['lon'][lon], ff['mark5_fdi'][d][lat][lon]] for lat in range(256) for lon in range(512)), range(30))

	{
		dbg("Timer", "Timer fired @ %s\n", sim_time_string());
		dx = rand() % 5;
		x_sign = rand() % 2;
		dy = rand() % 5;
		y_sign = rand() % 2;
		x += (x_sign == 0) ? -dx : dx;
		y += (y_sign == 0) ? -dy : dy;
		dbg("Moved", "Object moves to @ (%d, %d)\n", x, y);
		call Movement.movedTo(x, y);
	}
}

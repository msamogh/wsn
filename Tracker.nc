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
	long rr;
	float distance, var;
	float min_distance;

	int16_t x, y;
	TrackerMsg* estimates[25];
	float utility = 0;
	int coalition_size = 0;
	bool open = FALSE;

	float ETA = 0.65;
	float R = 8.0;

	
	float inverse[25][25];

	uint16_t cluster_head_id;

	float determinant(float a[25][25], float k)
	{
		float s = 1, det = 0, b[25][25];
		int i, j, m, n, c;
		if (k == 1)
		{
			return (a[0][0]);
		}
		else
		{
			det = 0;
			for (c = 0; c < k; c++)
			{
				m = 0;
				n = 0;
				for (i = 0;i < k; i++)
				{
					for (j = 0 ;j < k; j++)
					{
						b[i][j] = 0;
						if (i != 0 && j != c)
						{
							b[m][n] = a[i][j];
							if (n < (k - 2))
							n++;
							else
							{
								n = 0;
								m++;
							}
						}
					}
				}
				det = det + s * (a[0][c] * determinant(b, k - 1));
				s = -1 * s;
			}
		}
		return (det);
	}


	void transpose(float d, float fac[25][25], float r)
	{
		int i, j;
		float b[25][25];

		for (i = 0;i < r; i++)
		{
			for (j = 0;j < r; j++)
			{
				b[i][j] = fac[j][i];
			}
		}
		for (i = 0;i < r; i++)
		{
			for (j = 0;j < r; j++)
			{
				inverse[i][j] = b[i][j] / d;
			}
		}
	}

	void cofactor(float num[25][25], float f)
	{
		float b[25][25], fac[25][25];
		int p, q, m, n, i, j;
		for (q = 0;q < f; q++)
		{
			for (p = 0;p < f; p++)
			{
				m = 0;
				n = 0;
				for (i = 0;i < f; i++)
				{
					for (j = 0;j < f; j++)
					{
						if (i != q && j != p)
						{
							b[m][n] = num[i][j];
							if (n < (f - 2))
								n++;
							else
							{
								n = 0;
								m++;
							}
						}
					}
				}
				fac[q][p] = pow(-1, q + p) * determinant(b, f - 1);
			}
		}
		transpose(determinant(num, f), fac, f);
	}

	void multiplyMatrices(float firstMatrix[][25], float secondMatrix[][25], float mult[][25], int rowFirst, int columnFirst, int rowSecond, int columnSecond) {

		int i, j, k;

		// Initializing elements of matrix mult to 0.
		for(i = 0; i < rowFirst; ++i)
		{
			for(j = 0; j < columnSecond; ++j)
			{
				mult[i][j] = 0;
			}
		}

		// Multiplying matrix firstMatrix and secondMatrix and storing in array mult.
		for(i = 0; i < rowFirst; ++i)
		{
			for(j = 0; j < columnSecond; ++j)
			{
				for(k=0; k<columnFirst; ++k)
				{
					mult[i][j] += firstMatrix[i][k] * secondMatrix[k][j];
				}
			}
		}
	}

	void transpose2(float matrix[][25], float trans[][25], int row, int col) {
		int i, j;
		for (i = 0; i < row; i++) {
			for (j = 0; j < col; j++) {
				trans[j][i] = matrix[i][j];
			}
		}
	}	

	float getutility() {
		//float h[25][25], hT[25][25], hhT[25][25], beforeB[25][25], b[25];
		int i, j;
		float value, sum1 = 0, sum2 = 0, avgDistance = 0, temp;

		if (coalition_size == 1) return 0;
		else if (coalition_size == 2) return 0.0001;

		for (i = 0; i < coalition_size; i++)
			avgDistance += estimates[i]->distance / 1000.0;
		avgDistance /= ((float) coalition_size);

		dbg("Moved", "avgDistance: %f", avgDistance);

		for (i = 0; i < coalition_size; i++) {
			temp = (estimates[i]->distance - abs(avgDistance - estimates[i]->distance));
			sum1 += temp;
		}
		sum1 /= pow(R, 2);

		for (i = 0; i < coalition_size; i++) {
			sum2 += pow(x - estimates[i]->originX, 2) + pow(y - estimates[i]->originY, 2);
		}
		sum2 /= pow(R, 2);

		value = (1 - ETA) * (coalition_size - sum1) - ETA * (sum2);

		/* Initialize matrix H */
		// for (i = 0; i < coalition_size; i++) {
		// 	h[i][0] = estimates[i]->x;
		// 	h[i][1] = estimates[i]->y;
		// }

		// /* Initialize matrix b */
		// for (i = 0; i < coalition_size; i++) {
		// 	b[i] = pow(estimates[i]->x , 2) + pow(estimates[i]->y, 2) - (estimates[i]->distance / 1000.0);
		// }

		// transpose2(h, hT, coalition_size, 2);
		// multiplyMatrices(hT, h, hhT, 2, coalition_size, coalition_size, 2);
		// cofactor(hhT, coalition_size);
		// multiplyMatrices(inverse, hT, beforeB, 2, 2, 2, coalition_size);
		dbg("Moved", "Coalition value: %f", value);

		return value;
	}

	event void Boot.booted()
	{
		dbg("Boot", "%d booted", TOS_NODE_ID);
		call AMControl.start();
		call Timer.startPeriodic( 250 );
		srand(time(NULL));   // should only be called once
	}

	event void Timer.fired()
	{
		// if (!busy) {
		// 	TrackerMsg* btrpkt = (TrackerMsg*)(call Packet.getPayload(&pkt, sizeof (TrackerMsg)));
		// 	btrpkt->nodeid = TOS_NODE_ID;
		// 	btrpkt->type = DIST;
		// 	btrpkt->distance = 3;
		// 	if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(TrackerMsg)) == SUCCESS) {
		// 		dbg("Info", "Packet sent");
		// 		busy = TRUE;
		// 	} else {
		// 		dbg("Info", "Couldn't send packet. Busy.");
		// 	}
		// }
	}

	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			dbg("Info", "AMControl started");
		} else {
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

	void sendMessage(uint16_t nodeid, uint16_t type, uint16_t distance, uint16_t x, uint16_t y, uint16_t originX, uint16_t originY) {
		if (!busy) {

			TrackerMsg* btrpkt = (TrackerMsg*)(call Packet.getPayload(&pkt, sizeof (TrackerMsg)));
			btrpkt->nodeid = nodeid;
			btrpkt->type = type;
			btrpkt->distance = distance;
			btrpkt->x = x;
			btrpkt->y = y;
			btrpkt->originX = originX;
			btrpkt->originY = originY;

			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(TrackerMsg)) == SUCCESS) {
				dbg("Info", "Packet sent");
				busy = TRUE;
			} else {
				dbg("Info", "Couldn't send packet. Busy.");
			}
		}
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(TrackerMsg)) {
			TrackerMsg* btrpkt = (TrackerMsg*)payload;

			switch (btrpkt->type) {
/*
			case DIST:
				dbg("Info", "Nodeid: %d, distance: %d\n", btrpkt->nodeid, btrpkt->distance);
				break;
*/
			case COORD:
				dbg("Moved", "Coords: %d, %d", btrpkt->x, btrpkt->y);

				/* TODO Reset coalition parameters */
				open = FALSE;
				coalition_size = 1;
				/* End TODO */

				rr = rand();
				var = ((float)((rr % 100) / 100.0));
				var = (rr % 2 == 0) ? -var : var;
				distance = sqrt(pow(x - btrpkt->x, 2) + pow(y - btrpkt->y, 2)) + var;

				/* Initialize cluster head and minimum distance params to self */
				min_distance = distance;
				cluster_head_id = TOS_NODE_ID;

				if (distance <= 10) {
					dbg("Moved", "Distance: %f\n", distance);
					open = TRUE;

				} else {
					dbg("Moved", "Out of range\n", distance);
				}
				break;

			case INIT:
				x = btrpkt->x;
				y = btrpkt->y;
				dbg("Init", "Positioned at (%d, %d)\n", x, y);
				break;

			case COALITION:
				if (((float) btrpkt->distance) > distance) {
					estimates[++coalition_size] = btrpkt;
					if (getutility() > utility) {

					} else {
						coalition_size--;
					}
				}
				break;
			}
		}
		return msg;
	}

}

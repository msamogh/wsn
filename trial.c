#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
float inverse[25][25];
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

int main() {
	float x[25][25] = {{1, 2}, {1, 1}};
	float d = 0, r = 2;
	int i, j;

	d = determinant(x, r);
	cofactor(x, r);

	for (i = 0;i < r; i++)
	{
		for (j = 0;j < r; j++)
		{
			printf("\t%f", inverse[i][j]);
		}
		printf("\n");
	}
	return 0;
}


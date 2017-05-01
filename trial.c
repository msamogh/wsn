#include <time.h>
#include <stdlib.h>
#include <stdio.h>

int main() {
	srand(time(NULL));
	printf("%d\n", rand());
	printf("%d\n", rand());
	return 0;
}

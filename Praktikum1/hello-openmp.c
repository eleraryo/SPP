#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <time.h>

int main ( int argc, char *argv[] ) {

int n = omp_get_max_threads(void);
printf("maximum number of threads: %d\n", n);

srand(time(0));

void omp_set_num_threads (rand() %n);

#pragma omp parallel{
printf("Hello %d\n", omp_get_thread_num());
}
}
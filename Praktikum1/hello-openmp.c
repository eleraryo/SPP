#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {

  int n = omp_get_max_threads();
  printf("maximum number of threads: %d\n", n);

  srand(time(0));

  int thread_num = rand() % n;
  omp_set_num_threads(thread_num);
  printf("Number of threads set to %d\n", thread_num);

#pragma omp parallel
  printf("Hello %d\n", omp_get_thread_num());
}

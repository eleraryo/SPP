#include <math.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main();
double test01(int n, double x[], double y[]);
double test02(int n, double x[], double y[], int threads);

/******************************************************************************/

int main() {
  int n;

  n = 100;

  while (n < 10000000) {
    n = n * 10;

    double *x = (double *)malloc(n * sizeof(double));
    double *y = (double *)malloc(n * sizeof(double));

    double factor = (double)(n);
    factor = 1.0 / sqrt(2.0 * factor * factor + 3 * factor + 1.0);

    for (int i = 0; i < n; i++) {
      x[i] = (i + 1) * factor;
    }

    for (int i = 0; i < n; i++) {
      y[i] = (i + 1) * 6 * factor;
    }

    printf("\n");
    /*
      Test #1
    */
    double start = omp_get_wtime();
    double xdoty = test01(n, x, y);
    double end = omp_get_wtime();
    double wtime = end - start;

    printf("  Sequential  %8d  %14.6e  %15.10f\n", n, xdoty, wtime);
    /*
      Test #2
    */
    for (int j = 1; j <= 16; j *= 2) {
      double start_p = omp_get_wtime();
      xdoty = test02(n, x, y, j);
      double end_p = omp_get_wtime();
      wtime = end_p - start_p;
      printf("  Parallel    %8d  %14.6e  %15.10f  threads %8d\n", n, xdoty,
             wtime, j);
    }

    free(x);
    free(y);
  }
  /*
    Terminate.
  */
  printf("\n");
  printf("DOT_PRODUCT\n");
  printf("  Normal end of execution.\n");

  return 0;
}

// Sequential version
double test01(int n, double x[], double y[])

{
  double xdoty;

  xdoty = 0.0;

  for (int i = 0; i < n; i++) {
    xdoty += x[i] * y[i];
  }

  return xdoty;
}

// Parallel version
double test02(int n, double x[], double y[], int threads)

{
  double xdoty;

  xdoty = 0.0;
  omp_set_num_threads(threads);

#pragma omp parallel for reduction(+ : xdoty)
  for (int i = 0; i < n; i++) {
    xdoty += x[i] * y[i];
  }

  return xdoty;
}

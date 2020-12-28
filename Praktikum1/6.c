#include <math.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]);
double test01(int n, int m, int p, double **B[m][p], double **C[p][n]);
//double test02(int n, double x[], double y[], int threads);

/******************************************************************************/

int main(int argc, char *argv[]) {
  double factor;
  double wtime;

  int n = 100;
  int m = 90;
  int p = 80;

  //while (n < 10000000) {
  //  n = n * 10;

    double **B = (double **)malloc(m * p * sizeof(double));
    double **C = (double **)malloc(p * n * sizeof(double));

    factor = (double)(n);
    factor = 1.0 / sqrt(2.0 * factor * factor + 3 * factor + 1.0);

    for (int i = 0; i < m; i++) {
        for(int j = 0; j < p; j++){
      B[i][j] = (i + j + 1) * factor;
    }}

    for (int i = 0; i < p; i++) {
        for(int j = 0; j < n; j++){
      C[i][j] = (i + j + 1) * 6 * factor;
    }}

    printf("\n");
    /*
      Test #1
    */
    double start = omp_get_wtime();
    double **A = test01(n, m ,p , **B, **C);
    double end = omp_get_wtime();
    wtime = end - start;

    //printf("  Sequential  %8d  %14.6e  %15.10f\n", n, A, wtime);
    free(C);
    free(B);
    free(A);
    /*
      Test #2
    */
    /*for (int j = 1; j <= 16; j *= 2) {
      double start_p = omp_get_wtime();
      xdoty = test02(n, x, y, j);
      double end_p = omp_get_wtime();
      wtime = end_p - start_p;
      printf("  Parallel    %8d  %14.6e  %15.10f  threads %8d\n", n, xdoty,
             wtime, j);
    }

    free(x);
    free(y);*/
  //} //WHILE
  /*
    Terminate.
  */
  //printf("\n");
  //rintf("DOT_PRODUCT\n");
  printf("  Normal end of execution.\n");

  return 0;
}

// Sequential version
double test01(int n,int m, int p, double **B[m][p], double **C[p][n])

{
  double **A = (double **)malloc(m * n * sizeof(double));
 
 
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++){
              A[i][j]=0.0;
      }
    }

  for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++){
          for (int k = 0; k < p; k++){
            A[i][j]+=B[i][k] * C[k][j];
            }
        }
    }

  return 0.0; //A
}

// Parallel version
/*double test02(int n, double x[], double y[], int threads)

{
  int i;
  double xdoty;

  xdoty = 0.0;
  omp_set_num_threads(threads);

#pragma omp parallel for reduction(+ : xdoty)
  for (int i = 0; i < n; i++) {
    xdoty += x[i] * y[i];
  }

  return xdoty;
}
*/
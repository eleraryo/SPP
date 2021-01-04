#include <math.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

// create three different sized matrices
#define N 500
#define M 550
#define P 530

/******************************************************************************/

// Sequential version
int matMulSeq(double A[M][N], double B[M][P], double C[P][N]) {
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      A[i][j] = 0.0;
    }
  }

  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      for (int k = 0; k < P; k++) {
        A[i][j] += B[i][k] * C[k][j];
      }
    }
  }

  return 0;
}

int matMulPar(double A[M][N], double B[M][P], double C[P][N], int threads) {
  omp_set_num_threads(threads);

#pragma omp parallel for collapse(2) schedule(static)
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      A[i][j] = 0.0;
    }
  }

#pragma omp parallel for collapse(2) schedule(static)
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      for (int k = 0; k < P; k++) {
        A[i][j] += B[i][k] * C[k][j];
      }
    }
  }

  return 0;
}

int main(int argc, char *argv[]) {
  double factor;
  double wtime;

  // initialize arrays
  double B[M][P];
  double C[P][N];

  factor = (double)(N);
  factor = 1.0 / sqrt(2.0 * factor * factor + 3 * factor + 1.0);

  for (int i = 0; i < M; i++) {
    for (int j = 0; j < P; j++) {
      B[i][j] = (i + j + 1) * factor;
    }
  }

  for (int i = 0; i < P; i++) {
    for (int j = 0; j < N; j++) {
      C[i][j] = (i + j + 1) * 6 * factor;
    }
  }

  /*
    Test #1
  */
  double start = omp_get_wtime();

  double A[M][N];
  matMulSeq(A, B, C);

  double end = omp_get_wtime();
  wtime = end - start;

  printf("time taken in sequential: %f\n", wtime);
  /*
    Test #2
  */
  for (int j = 1; j <= 32; j *= 2) {
    double start_p = omp_get_wtime();

    matMulPar(A, B, C, j);

    double end_p = omp_get_wtime();
    wtime = end_p - start_p;

    printf("time taken in parallel with %d threads: %f\n", j, wtime);
  }

  printf("  Normal end of execution.\n");

  return 0;
}

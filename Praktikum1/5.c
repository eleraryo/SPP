#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
int a = 42;

#pragma omp parallel private(a) //firstprivate Wert vor Schleife
{
    a++;
    printf("%d\n", a);
}
printf("%d\n", a);
}
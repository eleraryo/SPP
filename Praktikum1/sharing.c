int g1, g2;

int foo(int p)
{
    return p + g1 + g2;
}

int main()
{
    int i, j;

#pragma omp parallel for private(g1)
    for (i=0; i<10; i++)
    {
        j += g1 + g2 + i;
        j += foo( g2 );
    }
    return 0;
}
